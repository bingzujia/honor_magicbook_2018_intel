# Patch 文件说明（Workspace/patch）

本说明文档（中文）针对仓库内 `Workspace/patch` 目录下的 SSDT/DSL 补丁文件，解释每个补丁文件的用途、编译、部署与测试方法，以及常见注意事项与调试建议。

---

📋 目录
- 概述
- 文件清单与简要说明
- 编译与部署（Windows PowerShell / macOS）
- 在 OpenCore 中加载与回滚
- 测试与诊断步骤（macOS）
- 风险与注意事项
- 建议的工作流程

---

## 一、概述

`Workspace/patch` 中包含了与显示、唤醒、EC、电源、背光、GPIO、设备信息等相关的 SSDT/DSL 补丁。
它们通常用于修复 BIOS 原始 ACPI 的不兼容项、在 macOS 下提供更合适的设备接口、或触发需要的 `Notify` 事件以让驱动正确初始化。

多数补丁会在 ACPI 运行时修改或补充 DSDT 中的 Device/Method（例如 `_LID`, `_WAK`, `PNLF`, `ALS0`, `EC0`）以便 macOS 能正确识别和处理对应硬件。

---

## 二、文件清单与简要说明

以下为当前 `Workspace/patch` 下的文件及其简要用途（基于 DSL 内容和命名推断）：

- `SSDT-_LID.dsl`：覆盖/替换 `LID0/_LID` 方法（原补丁），让 macOS 正确读取 LID 状态（LIDS）。
- `SSDT-LID-Assist.dsl`：增强版 `_LID`，在返回 LID 状态的同时尝试触发 GPU `GLID`/`Notify`，以帮助唤醒后恢复画面/背光。<br>
  说明：该补丁使用 `CondRefOf` 做保护，避免在目标对象不存在时调用导致错误。
- `SSDT-ALS0.dsl`：Ambient Light Sensor（环境光）补丁，为 macOS 提供 `ACPI0008` HID / `_ALI` 值，帮助自动亮度/背光等功能。
- `SSDT-PNLF.dsl`：Panel/Backlight (`PNLF`) 设备补丁，已更新为简化版，配合 `WhateverGreen.kext` 自动管理背光，适用于 8 代 CPU (Coffee Lake/Kaby Lake R)。
- `SSDT-DGPU.dsl`：`DGPU`（离散显卡）相关补丁，用于调用 `_OFF` 方法禁用独立显卡，节省电量。
- `SSDT-EC.dsl`：Embedded Controller 补丁（EC），定义 `_STA`、DSM、其他 EC 行为，便于 macOS 识别 EC 状态以及接收 EC 给出的 notify（如盖子、键盘、光标事件）。
- `SSDT-DMAC.dsl`：DMA 控制器补丁（`PNP0200`），用于为 macOS 显示 DMA 控制器设备信息、避免资源冲突或补充设备 `_CRS`。
- `SSDT-MCHC.dsl`：MCHC（Platform Controller）补丁，通常用于 SMBus、I2C、SBC 等设备的 `SMBus`/`DSM` 支持；也可以用于让 macOS 识别特定子设备。
- `SSDT-MEM2.dsl`：内存/板级设备补丁，可能用于修复 BIOS 的资源定义或映射内存资源（`_CRS`），并在 macOS 下通过 `_STA` 返回可见性。
- `SSDT-PLUG.dsl`：与处理器 `PLUG`/XCPM 相关功能，`_DSM`/plugin-type 提供 CPU 插件/性能管理属性，帮助电源管理兼容 macOS。
- `SSDT-TPD0.dsl`：**禁用触摸屏补丁**（原名 TPD0，实为禁用 I2C1/TPL1），用于禁用 I2C1 控制器以关闭触摸屏，避免兼容性问题或省电。

> **已移除/废弃的补丁**：
> - `SSDT-RMNE.dsl`：虚拟网卡补丁，因使用 `AirportItlwm` 原生 Wi-Fi 驱动，不再需要此补丁来修复 App Store 登录，已删除。

> 说明：这些描述基于补丁的 DSL 名称与内容片段推断。不同机器/机型的补丁细节可能不同，部署前请先阅读 DSL 内容并理解作用。

---

## 三、编译与部署（示例）

下面给出常见的 Windows PowerShell / macOS 下的编译与部署流程：

1) 使用 iasl 编译（Windows PowerShell 示例）

```powershell
# 示例：编译单个 DSL
iasl -ve "Workspace\patch\SSDT-PNLF.dsl"
# 这会在同目录生成 SSDT-PNLF.aml 和 .log/.lst 平台文件

# 批量编译：
Get-ChildItem "Workspace\patch\*.dsl" | ForEach-Object { iasl -ve $_.FullName }
```

2) 把 .aml 文件复制到 `EFI/OC/ACPI/`，并在 `config.plist` 的 `ACPI -> Add` 中引用（`Path` 为 AML 文件名）。

3) 保存 `config.plist` 并重启进行测试。

4) 在 macOS 下若需要回滚，移除 `ACPI -> Add` 条目并删除 `aml`，或还原 `EFI` 分区备份。

---

## 四、测试与诊断（macOS）

部署补丁后，建议按下列步骤检测和排查：

- 检查唤醒与盖子行为：
```bash
pmset -g log | grep -i "Wake reason"
log show --style syslog --predicate 'eventMessage contains "Wake reason"' --last 1h
```
- 检查 LID、Backlight、Battery、Touchpad 是否在 IORegistry 中显示：
```bash
ioreg -lw0 | grep -i PNP0C0D   # LID device
ioreg -lw0 | grep -i AppleBacklightDisplay
ioreg -lw0 | grep -i PNP0C0A   # Battery
ioreg -lw0 | grep -i IOPCIFamily
ioreg -lw0 | grep -i HID
```
- 查看 Kext 是否加载：
```bash
kextstat | grep -i Lilu
kextstat | grep -i WhateverGreen
kextstat | grep -i VirtualSMC
```
- 检查系统日志来定位 ACPI 通知或错误：
```bash
log show --style syslog --predicate 'process == "kernel"' --last 30m | grep -i acpi
a | grep -i "ACPI"  # 可用工具查看更多 ACPI 日志
```
- 对于背光/屏幕：
  - 检查是否有 `PNLF` 对象或 `AppleBacklightDisplay` 出现；
  - 在唤醒后尝试亮度按键（Fn+亮度键）或连接外接显示器；
  - 如果背光仍然不亮但系统已唤醒，通常需要检查 framebuffer/connector 的 patch（和 WhateverGreen 相关）。

---

## 五、风险与注意事项

- 备份是必须的：修改 `EFI`（OpenCore）或 ACPI 补丁前，请备份原始 `EFI` 分区与 `config.plist`。
- 冲突：不要同时加载有冲突的补丁（例如加载两个不同版本的 `_LID` 替换可能产生冲突），确保 `config.plist` 的 `ACPI -> Add` 里不会重复出现兼容对象或覆盖逻辑。
- 使用 `CondRefOf`：补丁中若能使用 `CondRefOf` 保护 `
_` 对象或方法更安全，避免在不同机型出现错误。
- 测试方法：每次修改只加载一个补丁并测试，若问题仍然存在，再逐一启用其它补丁排查。
- 代码审阅：在合并到主分支前（或部署到 `EFI`），最好通过 `iasl -ve` 做一次编译检查，确保无语法/严重错误。

---

## 六、建议的工作流程（推荐）

1. 在 `Workspace/patch` 下选择目标补丁（例如 `SSDT-LID-Assist.dsl`），先用 `iasl -ve` 编译并检查生成的 `.aml`；
2. 把 `.aml` 放到 `EFI/OC/ACPI` 并在 `config.plist` 中添加一条记录；
3. 启动 macOS 并进行一次完整的睡眠/唤醒/盖子开关测试；
4. 如果补丁无效或出现异常，查看 `log show` 与 `pmset` 日志，记录 `Wake reason`，查看 `ioreg` 中设备是否存在；
5. 根据日志修改补丁（例如更换 notify 值 0x80/0x81/0x86/0x87，或增加 `GLID` / `GSCI`），重复测试，直到问题修复。

---

## 七、示例：编译所有 patch 并移动到 EFI

下面是 Windows PowerShell 的批量编译示例（仅示例，先备份 FP）：

```powershell
# 切换到仓库根目录
cd "c:\Users\bingz\Desktop\honor_magicbook_2018_intel"
# 编译所有 patch目录下的 DSL
Get-ChildItem "Workspace\patch\*.dsl" | ForEach-Object {
   iasl -ve $_.FullName
}
# 假设编译生成 .aml 文件，复制到 EFI（先挂载 EFI 分区）
# 使用 mountvol 或已有挂载脚本来挂载 EFI
# cp generated .aml to EFI/OC/ACPI/
```

---

## 八、帮助与下一步

如果你需要我做以下任一项，请回复数字：
- 1) 为 `Workspace/patch` 中每个 DSL 生成更详细的注释（函数/字段/notify 等），并提交为 README 或独立注释 DSL；
- 2) 生成批量编译脚本 `Workspace/build-patches.ps1`（Windows PowerShell）并加入到仓库；
- 3) 编译并把选中的 `<SSDT-xxx.dsl>` 生成的 `AML` 添加到 `EFI/OC/ACPI`（需你授权仓库直接修改）；
- 4) 为 `SSDT-LID-Assist.dsl` 或 `SSDT-PNLF.dsl` 做更明确的注释和测试说明；

如果有任何其他问题或需要我先执行某项改动，请告诉我你要我做什么，我会继续操作。