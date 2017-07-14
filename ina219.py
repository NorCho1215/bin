# Copyright (c) 2013, NVIDIA CORPORATION.  All Rights Reserved.
#
# NVIDIA CORPORATION and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA CORPORATION is strictly prohibited.

class INA219(object):
    def __init__(self, hI2c, seven_bit_address, resistance, rail_name='', imax=None, cal=None, power_lsb=None):
        self._h = hI2c
        self._addr = seven_bit_address
        self._resistance = resistance
        self.name = rail_name

        # resitance+imax and cal+power_lsb are mutually exclusive ways to initialize
        if imax != None and cal == None and power_lsb == None:
            self._imax = imax
            self._cal = None
            self._power_lsb = None
        elif imax == None and cal != None and power_lsb != None:
            self._imax = None
            self._cal = cal
            self._power_lsb = power_lsb
        else:
            raise ValueError("Must specify either resitance+imax or cal+power_lsb")
        self.reinit()

    def reinit(self):
        self.config_reg(reset=1)
        self.config_reg(bus_range=0,
                        pga_gain=0,
                        bus_adc_setting=0x3, # 12-bit w/o oversampling (532us)
                        shunt_adc_setting=0xb,
                        mode=0x7) # continuous shunt & bus
        if self._cal is not None:
            self.calibration_reg(self._cal)
        else:
            self._update_cal_values()

    def set_calibration(self, cal, power_lsb):
        assert cal > 0 and cal <= 0xffff and power_lsb > 0
        if self._imax is not None:
            raise ValueError("Must not specify cal+power_lsb if device is configured via resistance+imax")
        self._power_lsb = power_lsb
        self._cal = cal
        self.calibration_reg(cal)

    def set_imax(self, imax):
        assert imax > 0
        if self._cal is not None:
            raise ValueError("Must not specify imax if device is configured via cal+power_lsb")
        self._imax = imax
        self._update_cal_values()

    def _update_cal_values(self):
        """Update calibration register and power_lsb based on resistance and imax"""
        current_lsb = self._imax/(1000.0 * 2**15)
        cal = int(round(0.04096 / (current_lsb * self._resistance)))
        cal = min([cal, 0xffff])
        cal &= 0xfffe # LSB always zero, only bits 15:1 used
        self._power_lsb = 20 * 1000 * 0.04096/(cal * self._resistance)
        self.calibration_reg(cal)

    def _read_reg(self, offs, retry=5):
        # (recursively) retry register reads
        try:
            self._h.send_bytes(self._addr, [offs])
            val = self._h.read_bytes(self._addr, 2)
        except AssertionError:
            if retry >= 0:
                return self._read_reg(offs, retry - 1 )
            raise
        return (ord(val[0]) << 8) + ord(val[1])

    def _write(self, offs, val, *args, **kwds):
        dat = [offs, (val>>8) & 0xff, val & 0xff]
        return self._h.send_bytes(self._addr, dat, *args, **kwds)

    def calibration_reg(self, val):
        self._write(5, val)

    def config_reg(self,
                   reset=None,
                   bus_range=None,
                   pga_gain=None,
                   bus_adc_setting=None,
                   shunt_adc_setting=None,
                   mode=None):
        val = self._read_reg(0)

        if reset is not None:
            val &= 0xffff ^ 0x8000
            val |= 0x8000
        if bus_range is not None:
            val &= 0xffff ^ (1 << 13)
            val |= (bus_range & 1) << 13
        if pga_gain is not None:
            val &= 0xffff ^ (3<<11)
            val |= (pga_gain & 3) << 11
        if bus_adc_setting is not None:
            val &= 0xffff ^ (0xf << 7)
            val |= (bus_adc_setting & 0xf) << 7
        if shunt_adc_setting is not None:
            val &= 0xffff ^ (0xf << 3)
            val |= (shunt_adc_setting & 0xf) << 3
        if mode is not None:
            val &= 0xffff ^ 0x7
            val |= mode & 0x7

        self._write(0, val)
        return self._read_reg(0)

    def bus_voltage(self):
        val = self._read_reg(2)
        val = (val & 0xfff8) >> 3
        val *= 4.0 # LSB is 4mV
        return val

    def current(self):
        val = self._read_reg(2)
        if (val & 1):
            raise OverflowError(self.name)
        val = self._read_reg(4)
        if (val & 0x8000):
            val = -((val ^ 0xffff)+1)
        val *= self._power_lsb / 20.0
        return val

    def power(self, blocking=False):
        while True:
            val = self._read_reg(2)
            if (val & 1):
		raise OverflowError(self.name)
            if (val & 2) or (not blocking):
                break
	val = self._read_reg(3)
        val *= self._power_lsb
        return val

    def set_sampling_profile(self, profile, bus_adc=None, shunt_adc=None):
        if profile == "high_frequency":
            bus_adc_setting = 0x3 # 532us
            shunt_adc_setting = 0xa # 2.13ms (average of 4)
        elif profile == "medium_frequency":
            bus_adc_setting = 0x3 # 532us
            shunt_adc_setting = 0xc # 8.51ms (average of 16)
        elif profile == "low_frequency":
            bus_adc_setting = 0x3 # 532us
            shunt_adc_setting = 0xf # 68.10ms (average of 128)
        elif profile == 'custom':
            if bus_adc < 0x0 or bus_adc > 0xf:
                raise ValueError('Invalid bus adc value')
            if shunt_adc < 0x0 or shunt_adc > 0xf:
                raise ValueError('Invalid shunt adc value')
            bus_adc_setting = bus_adc
            shunt_adc_setting = shunt_adc
        else:
            bus_adc_setting = 0x3 # 532us
            shunt_adc_setting = 0xc # 8.51ms (average of 16)

        self.config_reg(bus_adc_setting=bus_adc_setting,
                        shunt_adc_setting=shunt_adc_setting)
