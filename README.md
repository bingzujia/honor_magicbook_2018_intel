# OpenCore for Honor MagicBook 2018 Intel (macOS Big Sur)

***免责声明：***
本项目仅供学习交流，请勿用于商业用途。如果您的设备因使用本项目而出现任何问题，本人概不负责。

## 电脑配置

| 规格 | 详情 |
| :--- | :--- |
| 电脑型号 | 荣耀 MagicBook 2018 (Intel 版) |
| 处理器 | Intel Core i5-8250U (Kaby Lake R) |
| 显卡 | Intel UHD Graphics 620 (集显) / NVIDIA MX150 (已屏蔽) |
| 内存 | 8GB LPDDR3 2133MHz |
| 硬盘 | SATA SSD (原装 SanDisk) |
| 声卡 | Realtek ALC256 |
| 网卡 | Intel Wireless-AC 8265 |
| 屏幕 | 14英寸 1080P (触摸屏已禁用) |

## 当前状态

**系统版本**: macOS Big Sur 11.x
**引导工具**: OpenCore

### ✅ 正常工作
- **显卡**: UHD 620 硬件加速正常 (H.264/HEVC)。
- **CPU**: 原生电源管理 (XCPM)，SMBIOS `MacBookPro15,2`，低频/睿频正常。
- **声卡**: ALC256 内建扬声器/麦克风工作正常。
- **Wi-Fi**: Intel 8265 使用 `AirportItlwm` 驱动，支持原生 Wi-Fi 菜单。
- **蓝牙**: Intel 蓝牙工作正常 (开关/连接)。
- **触控板**: Elan 2203 多指手势正常。
- **USB**: USB 2.0/3.0/Type-C 均已定制。
- **电池**: 电量显示准确。
- **睡眠/唤醒**: 盒盖睡眠正常。
- **背光**: 快捷键调节亮度正常 (SSDT-PNLF + WhateverGreen)。

### ⚠️ 已禁用/已知问题
- **触摸屏**: 已通过 SSDT 默认禁用 (为了避免兼容性问题和误触)。如需开启，请禁用 `SSDT-TPD0.aml`。
- **独显**: MX150 已通过 SSDT 全局屏蔽以省电。
- **指纹**: macOS 不支持。
- **耳机孔**: 3.5mm 接口可能需要插拔修正 (ComboJack) 或手动切换。
- **隔空投送 (AirDrop)**: 需要博通网卡才能完美支持，Intel 网卡仅支持部分接力功能。

## 安装说明

### 1. 生成序列号 (必须)
本项目 `config.plist` 中的三码 (Serial Number, MLB, UUID) 为空。请在安装前使用 [GenSMBIOS](https://github.com/corpnewt/GenSMBIOS) 生成：
- **SystemProductName**: `MacBookPro15,2`
- 将生成的 Serial, Board Serial (MLB), SmUUID 填入 `config.plist` -> `PlatformInfo` -> `Generic`。

### 2. Kext 注意事项
- **Wi-Fi**: 默认配置为 macOS Big Sur 适用的 `AirportItlwm.kext`。如果你安装的是 Catalina 或 Monterey，请替换为对应版本的 Kext。
- **NVMeFix**: 建议自行添加 `NVMeFix.kext` 以优化非 Apple SSD 的电源管理。

## 补丁说明
详细的 ACPI 补丁修改记录请参考 [Workspace/README-patch.md](Workspace/README-patch.md)。

## 鸣谢

- [Acidanthera](https://github.com/acidanthera)：OpenCore 文档
- [OC-little](https://github.com/daliansky/OC-little)：ACPI 热补丁
- [xjn](https://github.com/xjn819)：[《使用OpenCore引导黑苹果》](https://blog.xjn819.com/?p=543)
- [Daliansky](https://github.com/daliansky)：[《精解OpenCore》](https://blog.daliansky.net/OpenCore-BootLoader.html)
- [Steve Zheng](https://github.com/stevezhengshiqi)：[one-key-cpufriend 脚本](https://github.com/stevezhengshiqi/one-key-cpufriend)
- [hjmmc](https://github.com/hjmmc) : [Honor-Magicbook 项目](https://github.com/hjmmc/Honor-Magicbook)
- [gnodipac886](https://github.com/gnodipac886) : [MatebookXPro-hackintosh 项目](https://github.com/gnodipac886/MatebookXPro-hackintosh)
- [frezs](https://github.com/frezs) : [MateBook14-Hackintosh 项目](https://github.com/frezs/MateBook14-Hackintosh)
- [@Zero-zer0](https://github.com/Zero-zer0) : [Matebook_D_2018_Hackintosh_OpenCore  项目](https://github.com/Zero-zer0/Matebook_D_2018_Hackintosh_OpenCore)

