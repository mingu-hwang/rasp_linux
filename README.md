Linux kernel
============

There are several guides for kernel developers and users. These guides can
be rendered in a number of formats, like HTML and PDF. Please read
Documentation/admin-guide/README.rst first.

In order to build the documentation, use ``make htmldocs`` or
``make pdfdocs``.  The formatted documentation can also be read online at:

    https://www.kernel.org/doc/html/latest/

There are various text files in the Documentation/ subdirectory,
several of them using the Restructured Text markup notation.

Please read the Documentation/process/changes.rst file, as it contains the
requirements for building and running the kernel, and information about
the problems which may result by upgrading your kernel.

Build status for rpi-5.15.y:
[![Pi kernel build tests](https://github.com/raspberrypi/linux/actions/workflows/kernel-build.yml/badge.svg?branch=rpi-5.15.y)](https://github.com/raspberrypi/linux/actions/workflows/kernel-build.yml)
[![dtoverlaycheck](https://github.com/raspberrypi/linux/actions/workflows/dtoverlaycheck.yml/badge.svg?branch=rpi-5.15.y)](https://github.com/raspberrypi/linux/actions/workflows/dtoverlaycheck.yml)

Build status for rpi-6.1.y:
[![Pi kernel build tests](https://github.com/raspberrypi/linux/actions/workflows/kernel-build.yml/badge.svg?branch=rpi-6.1.y)](https://github.com/raspberrypi/linux/actions/workflows/kernel-build.yml)
[![dtoverlaycheck](https://github.com/raspberrypi/linux/actions/workflows/dtoverlaycheck.yml/badge.svg?branch=rpi-6.1.y)](https://github.com/raspberrypi/linux/actions/workflows/dtoverlaycheck.yml)

Build status for rpi-6.5.y:
[![Pi kernel build tests](https://github.com/raspberrypi/linux/actions/workflows/kernel-build.yml/badge.svg?branch=rpi-6.5.y)](https://github.com/raspberrypi/linux/actions/workflows/kernel-build.yml)
[![dtoverlaycheck](https://github.com/raspberrypi/linux/actions/workflows/dtoverlaycheck.yml/badge.svg?branch=rpi-6.5.y)](https://github.com/raspberrypi/linux/actions/workflows/dtoverlaycheck.yml)

# Setup Guide for RPi4b + MAX98390 EVKit
## HW information
RPi baord <==== I2C/I2S ====> Level Shifter <==== I2C/I2S ====> EVKit
* RPi board: Raspberry Pi 4b model
* Level Shifter: TP240610A
* EVKit: MAX98390 EVKit

## Install Default OS
Install default OS in RPi4b by using Raspberry Pi Imager. You can install the default OS based on following document.
* Docs: https://www.raspberrypi.com/documentation/computers/getting-started.html#installing-the-operating-system

## Download source
Get kernel source to setup RPi4b + MAX98390 evkit.
```
~# git clone https://github.com/mingu-hwang/rasp_linux.git -b SUPPORT_MAX98390 --single-branch proj_max98390
```

## Build kernel
```
~# cd proj_max98390/linux
~# KERNEL=kernel8
~# make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- bcm2711_defconfig
```

## Extract outputs
If you successfully build the kernel, You need to move build outputs into your RPi board to install your kernel.
When you execute following commands, you can see the follwoing outputs: "outputs/" and "mnt.tar.gz"
```
~# sh copy_boot_to_ouput_arm64.sh
```

## Move outputs into your RPi board
Please move your outputs ("outputs/" and "mnt.tar.gz") into your RPi board.
I will not specify how to transfer the build output to the RPi board. Transfer it in a way that suits your environment.

## Install kernel in RPi board
Modify /boot/firmware/config.txt like below
```
mingu@raspberrypi:~$ cat /boot/firmware/config.txt
# For more options and information see
# http://rptl.io/configtxt
# Some settings may impact device functionality. See link above for details

# Uncomment some or all of these to enable the optional hardware interfaces
dtparam=i2c_arm=on
dtparam=i2s=on
#dtparam=spi=on

# Disable default audio (loads snd_bcm2835)
#dtparam=audio=on

# Additional overlays and parameters are documented
# /boot/firmware/overlays/README
dtoverlay=audioinjector-max98390-audio

# Automatically load overlays for detected cameras
camera_auto_detect=1

# Automatically load overlays for detected DSI displays
display_auto_detect=1

# Automatically load initramfs files, if found
auto_initramfs=1

# Enable DRM VC4 V3D driver
dtoverlay=vc4-kms-v3d,noaudio
max_framebuffers=2

# Don't have the firmware create an initial video= setting in cmdline.txt.
# Use the kernel's default instead.
disable_fw_kms_setup=1

# Run in 64-bit mode
arm_64bit=1

# Disable compensation for displays with overscan
disable_overscan=1

# Run as fast as firmware / board allows
arm_boost=1

[cm4]
# Enable host mode on the 2711 built-in XHCI USB controller.
# This line should be removed if the legacy DWC2 controller is required
# (e.g. for USB device mode) or if USB support is not required.
otg_mode=1

[cm5]
dtoverlay=dwc2,dr_mode=host

[all]
enable_uart=1
```

Install kernel
```
mingu@raspberrypi:~$ sh install_rpi4b_arm64.sh
```

Reboot RPi board
```
mingu@raspberrypi:~$ sudo reboot
```

Check if sound card is successfully registered. If you can see the follwing logs, the setup is done.
```
mingu@raspberrypi:~$ aplay -l
**** List of PLAYBACK Hardware Devices ****
card 0: audioinjectorma [audioinjector-maxim-soundcard], device 0: AudioInjector audio max98390-aif1-0 [AudioInjector audio max98390-aif1-0]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
```

