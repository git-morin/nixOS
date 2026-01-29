# Pixel Phones

Jailbreaking an Android device is done through the act of **rooting**, which grants access to the `root` account of the underlying Linux system.

## Why Rooting?

- Full control over your device
- Remove bloatware and carrier apps
- Use apps that require root access (AdAway, Viper4Android, etc...)
- Custom ROMs and kernels
- Modify system files
- Completely compatible with the newest Android builds (I run the beta builds rooted)

## Tools I Use

### PixelFlasher

[PixelFlasher](https://github.com/badabing2005/PixelFlasher) is a GUI tool that simplifies the rooting process for Pixel phones. It handles:

- Downloading factory images.
- Patching the boot images with Magisk (or other root solutions).
- Flashing the patched image to my phone easily.

### Magisk

[Magisk](https://github.com/topjohnwu/Magisk) is the solution I use for Android rooting:

- **Systemless root** - Doesn't modify the system partition.
- **MagiskHide/Zygisk** - Hide root from apps that detect it (banking apps, games).
- **Modules** - Extend functionality without modifying system files.

## Process Overview

1. **Unlock bootloader** - Enable OEM unlocking in Developer Options, then use `fastboot oem unlock`
2. **Download factory image** - Get the correct image for your device/build
3. **Patch boot.img** - Use Magisk app to patch the boot image
4. **Flash patched image** - Use PixelFlasher or `fastboot flash boot magisk_patched.img`

## Caveats

- Unlocking the bootloader **wipes the device**. Make sure you have a backup of important data you want to recover post rooting.
- Some apps need additionnal patches that don't last forever (cat and mouse) to work (Google Wallet being the main example).
- Android System Updates require re-rooting after applying.
