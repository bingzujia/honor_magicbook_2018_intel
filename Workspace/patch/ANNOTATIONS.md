# Patch 注释（Detailed Annotations for Workspace/patch）

本文档为 `Workspace/patch` 下每个 DSL 提供更详细的注释：列出关键 `Method`（如 `_INI`、`_STA`、`_LID`、`GLID` 等）、`Field`/`OperationRegion`、重要 `Notify` 调用与实现意图，以及测试建议和注意事项，帮助你理解每个补丁的运作。

---

## 目录
- SSDT-_LID.dsl
- SSDT-LID-Assist.dsl
- SSDT-ALS0.dsl
- SSDT-PNLF.dsl
- SSDT-DGPU.dsl
- SSDT-EC.dsl
- SSDT-DMAC.dsl
- SSDT-MCHC.dsl
- SSDT-PLUG.dsl
- SSDT-RMNE.dsl
- SSDT-GPRW.dsl
  - EC0 中新增了一个非常保守的 `_DSM`（function 0 返回 capability buffer），用于提供 EC DSM 能力并且不会覆盖复杂 DSDT 实现。
---

### SSDT-_LID.dsl
主要作用：覆盖 `\_SB.LID0._LID` 方法，确保 Darwin (macOS) 能正确返回盖子状态 `LIDS`。

- Key externals / globals
  - `\_SB.LID0`（Device）
  - `\_SB.LID0.LDRT`（Int）标记 lid status changed
  - `\_SB.LID0.XLID()`：设备原生 `_LID`，fallback
  - `ECOK`：EC 是否可用（Int）
  - `UPDL()`：EC 更新读取方法，用于刷新 `LIDS`
  - `LIDS`：EC 存储的 lid 状态

- 主要方法
  - `_SB.LID0._LID()`（被 override）
    - macOS 分支（_OSI("Darwin")): 
      - 若 `ECOK` 为真：调用 `UPDL()` 并清 `LDRT`。
      - 再次调用 `UPDL()`（原补丁含两次）并 `Return LIDS`。
    - 其他平台 fallback：Return `XLID()`。

- 安全性建议
  - `UPDL()` 已经包含 EC 读取操作，确保 `ECOK` 热区可用；频繁调用 `UPDL()` 可能造成多余操作或重复 notify。
  - 如需呼叫 GPU/Notify，用 `CondRefOf(\_SB.PCI0.GFX0)` 来避免调用不存在对象。

- 测试建议
  - 在 macOS 通过 `ioreg` 检查 `PNP0C0D` 是否可见；通过盖子操作观察 `pmset` 的 `Wake reason`。

- 依赖补丁 (config.plist)
  - `change _LID to XLID`: 将 DSDT 中的 `_LID` 重命名为 `XLID`，以便 SSDT 可以重定义 `_LID` 并调用原始 `XLID`。
    - Find: `5F 4C 49 44` (_LID)
    - Replace: `58 4C 49 44` (XLID)


---

### SSDT-LID-Assist.dsl
主要作用：在 `_LID` 事件时在 macOS 侧额外激活 GPU 相关代码（`GLID` 和 `Notify`），以便增强盖子唤醒后恢复显示/背光。

- Key externals / globals
  - 同 `SSDT-_LID.dsl` 的 `LID`/`ECOK`/`LIDS`/`UPDL`
  - `\_SB.PCI0.GFX0`（Device）
  - `\_SB.PCI0.GFX0.GLID(Arg)`：GLID 函数，用于 GPU 状态变更
  - `\_SB.PCI0.GFX0.DD1F`（Device）: 厂商特殊 device（常用于 vendor-specific notify）

- 主要方法
  - `_SB.LID0._LID()`（覆盖）
    - 如果 `Darwin`：
      - 如果 `ECOK`：调用 `UPDL()` 并复位 `LDRT`。
      - 使用 `CondRefOf` 检查 `GFX0` 是否存在；若存在则尝试调用 `GLID(LIDS)`；随后 `Notify(GFX0, 0x80)` 触发一般状态变化；若 `DD1F` 存在，会用 `0x86/0x87` 基于 `LIDS` 的值发送厂商 notify（open/close）。
    - 非 `Darwin`：fallback `Return XLID()`。

- 字段/寄存器
  - 无专门 OperationRegion（尽属调用与 notify）。

- 关键 Notify/Call
  - `GFX0.GLID(LIDS)`：强制 GPU 在 lid 状态变化时运行 GNOT / GLID 流程；
  - `Notify(GFX0, 0x80)`：通用状态变更通告；
  - `Notify(GFX0.DD1F, 0x86/0x87)`：厂商特定 notify（可能触发更低层的 HW 路径）；

- 测试建议与注意事项
  - 在部署前需要先备份 `EFI`，并在 macOS 下通过 `log` 捕获 `ACPI` 的 `Notify` 或 kernel 日志，确认 GLID/Notify 有无触发；
  - `DD1F` 的 0x86/0x87 含义因 OEM 不同，若效果相反，请交换；
  - 若你的 GPU 命名不是 `\_SB.PCI0.GFX0`，则 `CondRefOf` 会阻止调用，保安全性，但也会使补丁失效。

  - 新增 `Notify(\_SB.PCI0.RP01, Zero)`：
    - 我们已经在 `SSDT-LID-Assist.dsl` 的 `Darwin` 路径中新增 `Notify(\_SB.PCI0.RP01, Zero)`（有 `CondRefOf` 保护），以便在盖子开/关事件时触发 RP01 的 Bus Check 并强制 OS 重新枚举 / 刷新 PCI 子设备。可在 `ioRegistry` / `log show` 中观察到由此带来的设备消失/重现（若成功）。
    - 目的：补充 `GLID/Notify` 对 GPU 的软件重新初始化路径；当 GLID 或 GPU notify 无效时，此 bus check 能触发内核层的最终设备重枚举，修复一些唤醒黑屏或背光不亮的问题。注意：bus check 可能在 kernel 日志中出现设备重枚举条目，并在个别场景造成短暂 I/O 冲突/断开。

---

### SSDT-ALS0.dsl
主要作用：提供 `Ambient Light Sensor` 设备映射给 macOS，以便自动亮度/背光调节。

- 关键点
  - `Device (ALS0)`，`_HID` 被设置为 `"ACPI0008"`（Ambient Light Sensor）;
  - `_STA`：仅在 macOS (`_OSI("Darwin")`) 返回 `0x0F`（可见），否则 `Zero`（隐藏）。
  - `ALR`/_ALI 字段：提供 ALS 的响应配置（包结构）。

- 测试建议
  - 检测 `ioreg` 中是否出现 `smc-als` 或 `ACPI0008`；验证自动亮度是否正常；对 ALS 值读取做日志输出。

---

### SSDT-PNLF.dsl
主要作用：注入 `PNLF` (Panel Backlight) 设备，配合 WhateverGreen.kext 实现背光控制。

- 关键点
  - `Device (_SB.PCI0.GFX0.PNLF)`：定义 PNLF 设备。
  - `Name (_UID, 0x13)`：设置 UID 为 19 (0x13)，这是 WhateverGreen 推荐用于 Coffee Lake/Kaby Lake R (8th Gen) 平台的配置。
  - `Name (_STA, 0x0B)`：设置状态。

- 注意事项
  - 此版本为简化版，依赖 WhateverGreen 自动处理背光寄存器，不再包含复杂的寄存器映射逻辑。
  - 适用于 Intel UHD 620 等 8代核显。

- 测试项
  - 检查系统偏好设置中是否有亮度滑块；检查快捷键是否可用。

---

### SSDT-DGPU.dsl
主要作用：在补丁中提供 `DGPU`（离散 GPU）相关的初始化与 `_STA`，以便 macOS 能正确识别该设备或避免电源管理问题。

- 一般结构
  - `Device (RMD1)` 提供 `_HID` 和 `_INI`（内部会尝试调用 `\_SB.PCI0.RP01.PXSX._OFF()` 如果存在）;
  - `_STA`：对 `Darwin` 返回 `0x0F`（使设备可见）;

- 风险/注意点：
  - 如果该补丁不正确处理 RP 电源或与 iGPU 路径冲突，会造成设备不可用或电源问题；

- 测试
  - 检查 `ioreg` 中是否能看到 `RMD1`（或者你设备的 DGPU）; 验证唤醒后是否仍存在 GPU 设备。

*改动说明：*
 - 本仓库中的 `SSDT-DGPU.dsl` 在 `_INI` 中添加了 `Notify(\\_SB.PCI0.RP01, Zero)` 的 Bus Check（在调用 `RP01.PXSX._OFF()` 后）。
 - 目的：在 RP 被关闭后，强制操作系统重新枚举该 Root Port，从而更可能让 macOS 在内核层面卸载/隐藏 DGPU 驱动，实现更彻底的 DGPU 禁用。
 - 注意：Bus Check 可能触发系统重新枚举（可能在内核日志中看到设备消失/重现），若出现异常请回滚补丁并查看日志。

---

### SSDT-EC.dsl
主要作用：覆盖或新增 EC (Embedded Controller) 行为，以保证 macOS 能识别并获取电池/盖子/其他硬件信息。

- 关键函数与行为
  - `Device (EC)`，提供 `_HID`（`ACID0001`）和 `_STA` 返回 macOS 可见性；
  - `_DSM`：示例 DSM，提供 USBX 的电源/端口配置；
  - 该补丁旨在让 EC 在 Darwin 中展示可见（`_STA` = 0x0F），避免某些厂商用非标准方法隐藏 EC；

- 测试
  - 检查 `ioreg` 中 `EC` 是否可见；在唤醒与盖子/电源操作中查看 EC 提供的信息是否稳定（battery updates / lid notify）；

---

### SSDT-DMAC.dsl
主要作用：为 DMA 控制器提供正确的 `PNP0200` 资源/描述（_CRS），避免资源/IO 冲突。

- 关键字段
  - `_CRS`（ResourceTemplate）声明了 IO 和 DMA 等资源；
  - `_STA`：在 macOS 下返回 0x0F（可见），否则隐藏。

- 测试
  - 验证 `ioreg` 中是否有 DMA 设备，检查坐标 IO 资源冲突是否消失。

---

### SSDT-MCHC.dsl
主要作用：为 `MCHC`（主机控制器）添加设备信息与 `SMBus` `_DSM` 支持，帮助 macOS 使用 SMBus/主控制器子设备。

- 关键点
  - `Device (MCHC)`，`_STA`：macOS 可见性；
  - `SMBus` 子设备 `SBUS` 的 `_DSM`/`_STA` 和 `DVL0` 的 `address` 给出 SMBus 子设备；

- 测试
  - 使用 `ioreg` 确认 `SMBus` 设备是否存在并可以被识别（有些外设如电池、温度传感器依赖它）。

---

### SSDT-MEM2.dsl
主要作用：为板级内存映射/资源定义（`MEM2`）提供补丁或所需 `CRS`，便于 macOS 识别系统资源。

- 关键行为
  - 定义 `MEM2` Device `_HID`=`PNP0C01`，指定 `Memory32Fixed` 区域；
  - `_STA` 在 macOS 下返回可见；

- 测试
  - `ioreg` 下检索 `MEM2`，确认内存区域被正确识别并不会冲突。

---

### SSDT-PLUG.dsl
主要作用：为 CPU 的 XCPM/PLUG 属性提供 `_DSM`/DTGP 支持，便于 macOS 对 CPU 的电源管理与性能属性识别。

- 关键函数
  - `DTGP(...)`：处理提供 plugin-type, CPU performance GUID 的 `_DSM` 返回。
  - `_DSM`：返回 plugin-type 等数据，帮助 macOS 识别 CPU 插件类型；

- 测试
  - 检查 macOS 中 CPU 倍率、电源管理和节能状态是否正常并无异常告警。

---

### SSDT-RMNE.dsl (已移除)
- **状态**：已删除。
- **原因**：使用 `AirportItlwm.kext` 驱动 Intel 网卡后，系统内建网卡 (en0) 可由 Wi-Fi 接口承担，不再需要 NullEthernet 模拟有线网卡。

---

### SSDT-TPD0.dsl
主要作用：为触摸板/输入设备（`I2C1` 子设备）提供 `_STA` 控制，让 macOS 在需要时隐藏或显示该设备。

- 关键点
  - `Scope (_SB.PCI0.I2C1)` 内 `_STA`：在 macOS 环境下返回 `Zero`（这里做为隐藏示例），其他系统返回 `0x0F`。

### SSDT-TPD0.dsl
主要作用：禁用触摸屏 (I2C1 设备)，以避免在 macOS 下的兼容性问题或误触。

- 关键点
  - `Scope (_SB.PCI0.I2C1)`：作用于 I2C1 控制器（连接触摸屏）。
  - `Method (_STA)`：
    - `If (_OSI ("Darwin"))`：如果是 macOS，返回 `Zero` (隐藏/禁用)。
    - `Else`：返回 `0x0F` (启用，保持 Windows 兼容性)。

- 测试
  - 检查 `ioreg` 或系统报告，确认 I2C1 下的触摸屏设备在 macOS 下不再出现。

- 依赖补丁 (config.plist)
  - `OSYS=0x07D0 to OSYS=0x07DF`: 强制将 OSYS 变量设置为 Windows 2015 (0x07DF)，以启用 I2C 控制器的高级特性（通常用于触控板/触摸屏）。
    - Find: `70 0B D0 07 4F 53 59 53` (Store(0x07D0, OSYS))
    - Replace: `70 0B DF 07 4F 53 59 53` (Store(0x07DF, OSYS))


---

### SSDT-GPRW.dsl
主要作用：修复盒盖睡眠后无故唤醒（秒醒）问题，拦截特定 GPE 的唤醒信号。

- 问题分析
  - 电脑在盒盖睡眠后无故唤醒，通常是因为 USB 设备 (XHC) 或其他 PCIe 设备 (如网卡) 发送了唤醒信号。
  - 在 DSDT 中，USB 控制器 (XHC) 和网卡 (GLAN) 使用 GPE `0x6D`，PCIe 设备 (PXSX) 使用 GPE `0x69`。

- 解决方案
  - 拦截 `GPRW` 方法，禁止 `0x6D` 和 `0x69` 号 GPE 的唤醒功能。
  - 需要配合 `config.plist` 中的 `GPRW` -> `XPRW` 重命名补丁使用。

- 注意事项
  - 该补丁会禁用 USB 唤醒功能（即无法通过点击鼠标或键盘唤醒电脑），需要使用电源键唤醒。
  - 盒盖/开盖唤醒不受影响（使用 `0x50` 号中断）。

- 测试
  - 重启电脑，测试盒盖睡眠是否还会无故唤醒。

- 依赖补丁 (config.plist)
  - `change GPRW to XPRW`: 将 DSDT 中的 `GPRW` 重命名为 `XPRW`，以便 SSDT 可以重定义 `GPRW` 并调用原始 `XPRW`。
    - Find: `47 50 52 57 02` (GPRW)
    - Replace: `58 50 52 57 02` (XPRW)

