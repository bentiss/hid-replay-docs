---
layout: default
title: HID-replay
---

# HID replay - HID recorder for Linux

*hid-recorder* captures hidraw events, i.e. the raw events emited
by the HID device before the processing in the kernel.

*hid-replay* replays the captured events through the uhid kernel
module.

**Note:** In order to replay the HID events, you will need to load the
module uhid which is available in kernels v3.6+.

***WARNING:*** *hid-replay* is a very low level events injector. To have
the virtual device handled by the right HID kernel module, hid-replay
fakes that the device is on the original bus (USB, I2C or BT).
Thus, if the kernel module in use has to write _back_ to the device
the kernel may oops if the module is trying to direclty talk to the
physical layer.

Be sure to use this program with friendly HID modules that rely only
on the generic hid callbacks.

Starting with kernel 3.10, most HID modules are friendly with
*hid-replay*, but some are not (hid-logitech-dj, hid-roccat, etc...)

## Purpose:

This is mainly for debugging kernel drivers. If your goal
is just to replay events, have a look at evemu:
[http://wiki.freedesktop.org/wiki/Evemu](http://wiki.freedesktop.org/wiki/Evemu)

## Getting it:

#### Fedora
If you are running Fedora, see our packages [here](Fedora.html).

#### From the source
If you want to compile from the source:

	$> git clone https://github.com/bentiss/hid-replay.git
	$> cd hid-replay
	$> ./autogen.sh
	$> ./configure --prefix=/usr
	$> make && sudo make install

## Running HID-replay:

### HID-recorder:

*hid-recorder* is safe to be run on any kernel. All you need is to have a
hid device plugged and the hidraw module loaded. The syntax is the
following:
	#> hid-recorder /dev/hidrawN > mydevice.hid
Where */dev/hidrawN* is a valid device (replace N by the correct number).

If you ommit */dev/hidrawN* or if you don't know the right number, just run hid-recorder
without arguments:
	#> hid-recorder > mydevice.hid
hid-recorder will show you a list of available devices.

### HID-replay:

*hid-replay* may harm your kernel...

If you are sure to want to run it, you need to have a at least a
3.6 kernel and te module uhid loaded.

The syntax is the following:
	#> hid-replay mydevice.hid

If everything is correct, the new virtual device will appear, and
the line "*hit enter (re)start replaying the events*" will appear.
You can inject the previously recorded events by hitting the enter
key as requested by the tool.

Hit Ctrl-C to leave the application.

## Reporting bugs

File a bug in the github issues tracker at [https://github.com/bentiss/hid-replay/issues](https://github.com/bentiss/hid-replay/issues)

