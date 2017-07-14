# Copyright (c) 2013, NVIDIA CORPORATION.  All Rights Reserved.
#
# NVIDIA CORPORATION and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA CORPORATION is strictly prohibited.

class INA226(object):
    def __init__(self, hI2c, seven_bit_address, resistance, rail_name, cal=None, power_lsb=None, imax=None):
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
        self.config_reg(avg_mode=0, # Average 4 samples
                        bus_adc_setting=0x4, # 1.1ms
                        shunt_adc_setting=0x4,
                        mode=0x7) # continuous shunt & bus
        if self._cal is not None:
            self.calibration_reg(self._cal)
        else:
            self._update_cal_values()

    def set_calibration(self, cal, power_lsb):
        assert cal > 0 and cal <= 0x7fff and power_lsb > 0
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
        cal = int(round(0.00512 / (current_lsb * self._resistance)))
        cal = min([cal, 0x7fff])
        self._power_lsb = 25 * 1000 * 0.00512/(cal * self._resistance)
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
                   avg_mode=None,
                   bus_adc_setting=None,
                   shunt_adc_setting=None,
                   mode=None):
        val = self._read_reg(0)

        if reset is not None:
            val &= 0xffff ^ 0x8000
            val |= 0x8000
        if avg_mode is not None:
            val &= 0xffff ^ (0x7 << 9)
            val |= (avg_mode & 0x7) << 9
        if bus_adc_setting is not None:
            val &= 0xffff ^ (0x7 << 6)
            val |= (bus_adc_setting & 0x7) << 6
        if shunt_adc_setting is not None:
            val &= 0xffff ^ (0x7 << 3)
            val |= (shunt_adc_setting & 0x7) << 3
        if mode is not None:
            val &= 0xffff ^ 0x7
            val |= mode & 0x7

        self._write(0, val)

        return self._read_reg(0)

    def bus_voltage(self):
        val = self._read_reg(2)
        val *= 1.25 # LSB is 1.25mV
        return val

    def current(self):
        # Should check for overflow(?)

        val = self._read_reg(4)
        if (val & 0x8000):
            val = -((val ^ 0xffff)+1)
        val *= self._power_lsb / 25.0
        return val

    def power(self, blocking=False):
        while True:
            val = self._read_reg(6)
            # check overflow
            if (val & 4):
                raise OverflowError(self.name)
            # check conversion ready
            if (val & 8 or not blocking):
                break

        val = self._read_reg(3)
        val *= self._power_lsb
        return val

    def set_sampling_profile(self, profile, avg=None, ct=None):
        if profile   == "high_frequency":
            avg_bits = 1 # average over 4 samples
            ct_bits  = 4  # conversion time 1.1ms
        elif profile == "medium_frequency":
            avg_bits = 4
            ct_bits  = 4
        elif profile == "low_frequency":
            avg_bits = 7 # average over 1024 samples
            ct_bits  = 7 # conversion time 8.244ms
        elif profile == 'custom':
            if avg < 0 or avg > 7: raise ValueError('Invalid averaging value')
            if ct < 0 or ct > 7: raise ValueError('Invalid conversion time value')
            avg_bits = avg
            ct_bits  = ct
        else:
            avg_bits = 1 # average over 4 samples
            ct_bits  = 4  # conversion time 1.1ms

        self.config_reg(avg_mode=avg_bits,
                        bus_adc_setting=ct_bits,
                        shunt_adc_setting=ct_bits)

    # Legacy
    def check_ovf(self):
        val = self._read_reg(3)
        val = self._read_reg(6)
	if (val & 4):
            return True
	return False

    # Legacy
    def auto_cal(self):
	val = self._read_reg(5)
	val -= 0x10
	self._write(5, val)
	self._cal = val
	return val

    # Legacy
    def calc_gain(self, cal=None):
	if cal is None:
		cal = self._cal
	val = (2.5/1000000)/self._resistance*2048/cal*1000
	val *= 25
	self._power_lsb = val
	return val

    # Legacy
    def calc_cal(self):
	val = float(2.5/1000000)*2048*(32767)
	val /= float(self._imax)/1000
	val /= float(self._resistance)
	if val > 0x7FFF:
		val = 0x7FFF
	self._cal = int(val)
	return val
