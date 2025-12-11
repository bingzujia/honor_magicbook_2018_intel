# OpenCore for Honor MagicBook 2018 Intel (macOS Big Sur)

**DISCLAIMER:**
This project is for educational purposes only. Do not use it for commercial purposes. I am not responsible for any damage caused to your device by using this project.

## Hardware Configuration

| Specification | Details |
| :--- | :--- |
| Model | Honor MagicBook 2018 (Intel Version) |
| Processor | Intel Core i5-8250U (Kaby Lake R) |
| Graphics | Intel UHD Graphics 620 (iGPU) / NVIDIA MX150 (Disabled) |
| Memory | 8GB LPDDR3 2133MHz |
| Storage | SATA SSD (Stock SanDisk) |
| Audio | Realtek ALC256 |
| Wi-Fi/BT | Intel Wireless-AC 8265 |
| Display | 14-inch 1080P (Touchscreen Disabled) |

## Current Status

**OS Version**: macOS Big Sur 11.x
**Bootloader**: OpenCore

### ✅ Working
- **Graphics**: UHD 620 Hardware Acceleration (H.264/HEVC).
- **CPU**: Native Power Management (XCPM), SMBIOS `MacBookPro15,2`, Low frequency/Turbo boost working.
- **Audio**: ALC256 Internal Speakers/Microphone.
- **Wi-Fi**: Intel 8265 using `AirportItlwm`, supports native Wi-Fi menu.
- **Bluetooth**: Intel Bluetooth (Toggle/Connect).
- **Trackpad**: Elan 2203 with multi-touch gestures.
- **USB**: USB 2.0/3.0/Type-C mapped.
- **Battery**: Percentage display.
- **Sleep/Wake**: Lid sleep working.
- **Backlight**: Brightness keys working (SSDT-PNLF + WhateverGreen).

### ⚠️ Disabled/Known Issues
- **Touchscreen**: Disabled by default via SSDT (to avoid compatibility issues and accidental touches). To enable, disable `SSDT-TPD0.aml`.
- **dGPU**: MX150 disabled globally via SSDT to save power.
- **Fingerprint**: Not supported in macOS.
- **Headphone Jack**: 3.5mm jack might need replugging or manual switching (ComboJack).
- **AirDrop**: Requires Broadcom card for full support; Intel card supports limited Handoff features.

## Installation Instructions

### 1. Generate Serial Numbers (Required)
The `config.plist` in this project has empty Serial Number, MLB, and UUID. Please use [GenSMBIOS](https://github.com/corpnewt/GenSMBIOS) to generate them before installation:
- **SystemProductName**: `MacBookPro15,2`
- Fill the generated Serial, Board Serial (MLB), and SmUUID into `config.plist` -> `PlatformInfo` -> `Generic`.

### 2. Kext Notes
- **Wi-Fi**: Default configuration uses `AirportItlwm.kext` for macOS Big Sur. If you are installing Catalina or Monterey, please replace it with the corresponding version.
- **NVMeFix**: It is recommended to add `NVMeFix.kext` to optimize power management for non-Apple SSDs.

## Patch Notes
For detailed ACPI patch modification records, please refer to [Workspace/README-patch.md](Workspace/README-patch.md).

## Credits

- [Acidanthera](https://github.com/acidanthera)：OpenCore documents
- [OC-little](https://github.com/daliansky/OC-little)：ACPI hotpatch
- [xjn](https://github.com/xjn819)：[《使用OpenCore引导黑苹果》](https://blog.xjn819.com/?p=543)
- [Daliansky](https://github.com/daliansky)：[《精解OpenCore》](https://blog.daliansky.net/OpenCore-BootLoader.html)
- [Steve Zheng](https://github.com/stevezhengshiqi)：[one-key-cpufriend scripts](https://github.com/stevezhengshiqi/one-key-cpufriend)
- [hjmmc](https://github.com/hjmmc) : [Honor-Magicbook Project](https://github.com/hjmmc/Honor-Magicbook)  
- [gnodipac886](https://github.com/gnodipac886) : [MatebookXPro-hackintosh Project](https://github.com/gnodipac886/MatebookXPro-hackintosh)
- [frezs](https://github.com/frezs) : [MateBook14-Hackintosh Project](https://github.com/frezs/MateBook14-Hackintosh)
- [@Zero-zer0](https://github.com/Zero-zer0) : [Matebook_D_2018_Hackintosh_OpenCore Project](https://github.com/Zero-zer0/Matebook_D_2018_Hackintosh_OpenCore)

