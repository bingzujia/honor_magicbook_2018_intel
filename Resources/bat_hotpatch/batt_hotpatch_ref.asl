/* 16 位读取
*/
Method (B1B2, 2, NotSerialized)
{
    Return ((Arg0 | (Arg1 << 0x08)))
}
/* 
16 位读取 */

/* 16 位写入
*/
Method (W16B, 3, NotSerialized)
{
    Arg0 = Arg2
    Arg1 = (Arg2 >> 0x08)
}
/*
16 位写入 */

/* 32 位以上读取
*/
Method (RE1B, 1, NotSerialized)
{
    Local0 = (0xFE708300 + Arg0)
    OperationRegion (ERM2, EmbeddedControl, Local0, One) // 作用域为 EmbeddedControl，Arg0 定义起始偏移量
    Field (ERM2, ByteAcc, NoLock, Preserve)
    {
        BYTE,   8 // 指定一个 8 位寄存器映射对应区域数据
    }

    Return (BYTE) // 返回结果
}

Method (RECB, 2, Serialized)
{
    Arg1 = ((Arg1 + 0x07) >> 0x03) // 计算 Arg1 除 8 并向上取整，位移运算更快
    Name (TEMP, Buffer (Arg1){}) // 初始化作为返回值的 Buffer
    Arg1 += Arg0 // 加上偏移量，即循环终止值
    Local0 = Zero // 定义 Buffer 索引为 0
    While ((Arg0 < Arg1)) // 进行循环，循环次数为初次计算的 Arg1，自行理解
    {
        TEMP [Local0] = RE1B (Arg0) // 调用 RE1B 依次返回 8 位数据
        Arg0++ // 偏移量自增
        Local0++ // 索引自增
    }

    Return (TEMP) // 返回最终结果
}
/*
32 位以上读取 */

/* 32 位以上写入
*/
Method (WE1B, 2, NotSerialized)
{
    Local0 = (0xFE708300 + Arg0)
    OperationRegion (ERM2, EmbeddedControl, Local0, One) // EmbeddedControl 为 EC 作用域，Arg0 定义起始偏移量
    Field (ERM2, ByteAcc, NoLock, Preserve)
    {
        BYTE,   8 // 指定一个 8 位寄存器映射对应区域数据
    }

    BYTE = Arg1 // 将 Arg1 通过寄存器间接写入对应区域
}

Method (WECB, 3, Serialized)
{
    Arg1 = ((Arg1 + 0x07) >> 0x03) // 计算 Arg1 除 8 并向上取整，位移运算更快
    Name (TEMP, Buffer (Arg1){}) // 初始化作为写入值的 Buffer
    TEMP = Arg2 // 将被写入的数据或对象赋值给 TEMP
    Arg1 += Arg0 // 加上偏移量，即循环终止值
    Local0 = Zero // 定义 Buffer 索引为 0
    While ((Arg0 < Arg1)) // 进行循环，循环次数为初次计算的 Arg1，自行理解
    {
        WE1B (Arg0, DerefOf (TEMP [Local0])) // 调用 WE1B 依次写入 8 位数据
        Arg0++ // 偏移量自增
        Local0++ // 索引自增
    }
}
/*
32 位以上写入 */

Field (ERAM, ByteAcc, Lock, Preserve)
{
    Offset (0x7E), 
    BATD,   16, // 0x7E + 0x02 = 0x80
    // 拆分
    // Offset (0x7E)
    // BTD0, 8
    // BTD1, 8
}

External (_SB.PCI0.LPCB.EC0.SELE, MethodObj)
Method (SELE, 0, Serialized)
{
    Store (BATD, BATN)
    // 
    // W16B (BTD0, BTD1, BATN)
}


Field (ERAM, ByteAcc, Lock, Preserve)
{
    Offset (0x30), 
    BNAM,   120,
    Offset (0x60), 
    BMFN,   152, // 0x60 + 0x13 = 0x73
    Offset (0x7A), 
    BTCC,   16, // 0x7A + 0x02 = 0x7C
    // BTC0, 8
    // BTC1, 8
    Offset (0x81), 
    BTML,   8,  // 0x81 + 0x01 = 0x82
    BTSN,   16, // 0x82 + 0x02 = 0x84
    // BTN0, 8
    // BTN1, 8
    BTAP,   16, // 0x84 + 0x02 = 0x86
    // BTP0, 8
    // BTP1, 8
    BTDV,   16, // 0x86 + 0x02 = 0x88
    // BDV0, 8
    // BDV1, 8
    Offset (0x8E), 
    BT1I,   16, // 0x8E + 0x02 = 0x90
    // BTI0, 8
    // BTI1, 8
    BT1V,   16, // 0x90 + 0x02 = 0x92
    // BTV0, 8
    // BTV1, 8 
    BT1C,   16, // 0x92 + 0x02 = 0x94
    // BTC0, 8
    // BTC1, 8
    BTFC,   16, // 0x94 + 0x02 = 0x96
    // BTF0, 8
    // BTF1, 8
    Offset (0x9E), 
    RSOC,   16, // 0x9E + 0x02 = 0xA0
    // ROC0, 8
    // ROC1, 8
}

External (\_SB.BAT1.UPBI, MethodObj)
Method (UPBI, 0, NotSerialized)
{
    PBIF [0x04] = ^^PCI0.LPCB.EC0.BTDV /* \_SB_.PCI0.LPCB.EC0_.BTDV */
    // PBIF [0x04] = B1B2(^^PCI0.LPCB.EC0.BDV0, ^^PCI0.LPCB.EC0.BDV1) /* \_SB_.PCI0.LPCB.EC0_.BTDV */
    PBIF [One] = ^^PCI0.LPCB.EC0.BTAP /* \_SB_.PCI0.LPCB.EC0_.BTAP */
    // PBIF [One] = B1B2(^^PCI0.LPCB.EC0.BTP0, ^^PCI0.LPCB.EC0.BTP1) /* \_SB_.PCI0.LPCB.EC0_.BTAP */
    Local0 = ^^PCI0.LPCB.EC0.BMFN /* \_SB_.PCI0.LPCB.EC0_.BMFN */
    // Local0 = RECB (0x60, 0x98) /* \_SB_.PCI0.LPCB.EC0_.BMFN */
    PBIF [0x0A] = ITOS (ToBCD (^^PCI0.LPCB.EC0.BTSN))
    // PBIF [0x0A] = ITOS (ToBCD (B1B2（^^PCI0.LPCB.EC0.BTN0, ^^PCI0.LPCB.EC0.BTN1))
}

External (\_SB.BAT1.UPBX, MethodObj)
Method (UPBX, 0, NotSerialized)
{
    If ((^^PCI0.LPCB.EC0.BTFC >= FDDC))
    // If (B1B2(^^PCI0.LPCB.EC0.BTF0, ^^PCI0.LPCB.EC0.BTF1) >= FDDC))
    PBIX [0x03] = ^^PCI0.LPCB.EC0.BTFC /* \_SB_.PCI0.LPCB.EC0_.BTFC */
    // PBIX [0x03] = B1B2(^^PCI0.LPCB.EC0.BTF0, ^^PCI0.LPCB.EC0.BTF1) /* \_SB_.PCI0.LPCB.EC0_.BTFC */
    PBIX [0x02] = ^^PCI0.LPCB.EC0.BTAP /* \_SB_.PCI0.LPCB.EC0_.BTAP */
    // PBIX [0x02] = B1B2(^^PCI0.LPCB.EC0.BTP0, ^^PCI0.LPCB.EC0.BTP1) /* \_SB_.PCI0.LPCB.EC0_.BTAP */
    FDDC = ((^^PCI0.LPCB.EC0.BTAP / 0x0A) * 0x0B)
    // FDDC = ((B1B2(^^PCI0.LPCB.EC0.BTP0, ^^PCI0.LPCB.EC0.BTP1) / 0x0A) * 0x0B)
    PBIX [0x05] = ^^PCI0.LPCB.EC0.BTDV /* \_SB_.PCI0.LPCB.EC0_.BTDV */
    // PBIX [0x05] = B1B2(^^PCI0.LPCB.EC0.BDV0, ^^PCI0.LPCB.EC0.BDV1) /* \_SB_.PCI0.LPCB.EC0_.BTDV */
    PBIX [0x08] = ^^PCI0.LPCB.EC0.BTCC /* \_SB_.PCI0.LPCB.EC0_.BTCC */
    // PBIX [0x08] = B1B2(^^PCI0.LPCB.EC0.BTC0, ^^PCI0.LPCB.EC0.BTC1) /* \_SB_.PCI0.LPCB.EC0_.BTDV */
    Local0 = ^^PCI0.LPCB.EC0.BNAM /* \_SB_.PCI0.LPCB.EC0_.BNAM */
    // Local0 = RECB (0x30, 0x78) /* \_SB_.PCI0.LPCB.EC0_.BNAM */
    PBIX [0x11] = ITOS (ToBCD (^^PCI0.LPCB.EC0.BTSN))
    // PBIX [0x11] = ITOS (ToBCD (B1B2(^^PCI0.LPCB.EC0.BTN0, ^^PCI0.LPCB.EC0.BTN1))
    Local0 = ^^PCI0.LPCB.EC0.BMFN /* \_SB_.PCI0.LPCB.EC0_.BMFN */
    // Local0 = RECB (0x60, 0x98) /* \_SB_.PCI0.LPCB.EC0_.BMFN */
}

External (\_SB.CHKB, MethodObj)
Method (CHKB, 0, NotSerialized)
{
    If ((\_SB.BAT1.BATP == 0x1F))
    {
        If ((DerefOf (\_SB.BAT1.PBIF [One]) != \_SB.PCI0.LPCB.EC0.BTAP))
        // If ((DerefOf (\_SB.BAT1.PBIF [One]) != B1B2(\_SB.PCI0.LPCB.EC0.BTP0, \_SB.PCI0.LPCB.EC0.BTP1)))
        {
            Notify (\_SB.BAT1, 0x81) // Information Change
        }
    }
}

External (\_SB.BAT1.UPBS, MethodObj)
Method (UPBS, 0, NotSerialized)
{
    Local1 = ^^PCI0.LPCB.EC0.BT1I /* \_SB_.PCI0.LPCB.EC0_.BT1I */
    // Local1 = B1B2(^^PCI0.LPCB.EC0.BTI0, ^^PCI0.LPCB.EC0.BTI1) /* \_SB_.PCI0.LPCB.EC0_.BT1I */
    PBST [0x02] = ^^PCI0.LPCB.EC0.BT1C /* \_SB_.PCI0.LPCB.EC0_.BT1C */
    // PBST [0x02] = B1B2(^^PCI0.LPCB.EC0.BTC0, ^^PCI0.LPCB.EC0.BTC1) /* \_SB_.PCI0.LPCB.EC0_.BT1C */
    PBST [0x03] = ^^PCI0.LPCB.EC0.BT1V /* \_SB_.PCI0.LPCB.EC0_.BT1V */
    // PBST [0x03] = B1B2(^^PCI0.LPCB.EC0.BTV0, ^^PCI0.LPCB.EC0.BTV1) /* \_SB_.PCI0.LPCB.EC0_.BT1V */
}

External (\_SB.BAT1.UPBI, MethodObj)
Method (UPBI, 0, NotSerialized)
{
    PBIF [0x02] = ^^PCI0.LPCB.EC0.BTFC /* \_SB_.PCI0.LPCB.EC0_.BTFC */
    // PBIF [0x02] = B1B2(^^PCI0.LPCB.EC0.BTF0, ^^PCI0.LPCB.EC0.BTF1) /* \_SB_.PCI0.LPCB.EC0_.BTFC */
    Local0 = ^^PCI0.LPCB.EC0.BNAM /* \_SB_.PCI0.LPCB.EC0_.BNAM */
    // Local0 = RECB (0x30, 0x78) /* \_SB_.PCI0.LPCB.EC0_.BNAM */
}

External (\GCVA, MethodObj)
Method (GCVA, 1, Serialized)
{
    GCV2 = \_SB.PCI0.LPCB.EC0.BT1V
    // GCV2 = B1B2(\_SB.PCI0.LPCB.EC0.BTV0, \_SB.PCI0.LPCB.EC0.BTV1)
    BCVF = \_SB.PCI0.LPCB.EC0.BT1I
    // BCVF = B1B2(\_SB.PCI0.LPCB.EC0.BTI0, \_SB.PCI0.LPCB.EC0.BTI1)
}

Method (GPCI, 1, Serialized)
{
    VBAT = \_SB.PCI0.LPCB.EC0.BT1V
    // VBAT = B1B2(\_SB.PCI0.LPCB.EC0.BTV0, \_SB.PCI0.LPCB.EC0.BTV1)
}