# Copyright (c) 2015, NVIDIA CORPORATION.  All Rights Reserved.
#
# NVIDIA CORPORATION and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA CORPORATION is strictly prohibited.

class INA3221(object):
    def __init__(self, hI2c, seven_bit_address, channel, resistance, rail_name):
        self._h = hI2c
        self._addr = seven_bit_address
        self._channel = channel
        self._channel_base = (channel * 2) - 1
        self._resistance = resistance
        self.name = rail_name

        if channel < 1 or channel > 3:
            raise ValueError("Invalid channel number.  Must be either 1, 2, or 3")

        self.reinit()

    def reinit(self):
        self.config_reg(reset=1)
        self.config_reg(avg_mode=1, # Average 4 samples
                        ch_en=7, # Enable all channels
                        bus_adc_setting=0x4, # 1.1ms
                        shunt_adc_setting=0x4,
                        mode=0x7) # continuous shunt & bus

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

    def config_reg(self,
                   reset=None,
                   ch_en=None,
                   avg_mode=None,
                   bus_adc_setting=None,
                   shunt_adc_setting=None,
                   mode=None):
        val = self._read_reg(0)

        if reset is not None:
            val &= 0xffff ^ 0x8000
            val |= 0x8000
        if ch_en is not None:
            val &= 0xffff ^ (0x7 << 12)
            val |= (ch_en & 0x7) << 12
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
        # Get voltage in mV
        val = self._read_reg(self._channel_base+1)
        return val

    def shunt_voltage(self, blocking=False):
        # Get shunt voltage in mV
        while True:
            if self._channel != 1:
                break
            val = self._read_reg(0xf)
            # check conversion ready
            if (val & 1 or not blocking):
                break

        val = self._read_reg(self._channel_base)
        val *= 0.005
        return val

    def current(self, blocking=False):
        # Get shunt voltage and divide by resistant value in mA
        val = self.shunt_voltage(blocking)
        val /= self._resistance
        return val

    def power(self, blocking=False):
        # Get power in mW is equal to (current * voltage)/1000
        val = self.current(blocking)
        val *= self.bus_voltage()
        val /= 1000
        return val

    def set_sampling_profile(self, profile, avg=None, ct=None):
        if profile   == "high_frequency":
            avg_bits = 0 # average over 1 sample
            ct_bits  = 0 # conversion time 140us
        elif profile == "medium_frequency":
            avg_bits = 2 # average over 16 samples
            ct_bits  = 4 # conversion time 1.1ms
        elif profile == "low_frequency":
            avg_bits = 4 # average over 128 samples
            ct_bits  = 5 # conversion time 2.116ms
        elif profile == 'custom':
            if avg < 0 or avg > 7: raise ValueError('Invalid averaging value')
            if ct < 0 or ct > 7: raise ValueError('Invalid conversion time value')
            avg_bits = avg
            ct_bits  = ct
        else:
            avg_bits = 2 # average over 16 samples
            ct_bits  = 4  # conversion time 1.1ms

        self.config_reg(avg_mode=avg_bits,
                        bus_adc_setting=ct_bits,
                        shunt_adc_setting=ct_bits)
