DefinitionBlock ("", "SSDT", 2, "ACDT", "BATT", 0x00000000)
{
    External (PNOT, MethodObj)
    External (PWRS, FieldUnitObj)
    External (_SB.BAT1, DeviceObj)
    External (_SB.BAT1.PBFE, MethodObj)
    External (_SB.BAT1.BATP, IntObj)
    External (_SB.BAT1.PBIF, PkgObj)
    External (_SB.BAT1.PBST, PkgObj)
    External (_SB.BAT1.ITOS, MethodObj)
    External (_SB.BAT1.PBIX, PkgObj)
    External (_SB.PCI0.LPCB.EC0, DeviceObj)
    External (_SB.PCI0.LPCB.EC0.BATN, IntObj)
    External (_SB.PCI0.LPCB.EC0.BATO, IntObj)
    External (_SB.PCI0.LPCB.EC0.ACDC, FieldUnitObj)
    External (_SB.PCI0.LPCB.EC0.PADH, FieldUnitObj)
    External (_SB.PCI0.LPCB.EC0.PADL, FieldUnitObj)
    External (_SB.PCI0.LPCB.EC0.PBTH, FieldUnitObj)
    External (_SB.PCI0.LPCB.EC0.PBTL, FieldUnitObj)
    External (_SB.PCI0.LPCB.EC0.BTTL, FieldUnitObj)
    External (_SB.PCI0.LPCB.EC0.BATL, FieldUnitObj)
    External (_SB.PCI0.LPCB.EC0.BNBC, FieldUnitObj)
    External (_SB.PCI0.LPCB.EC0.CHEM, FieldUnitObj)
    External (_SB.PCI0.LPCB.EC0.BMFC, FieldUnitObj)
    External (_SB.PCI0.LPCB.EC0.BATH, FieldUnitObj)
        
    Method (B1B2, 2, NotSerialized)
    {
        Return ((Arg0 | (Arg1 << 0x08)))
    }
    
    Method (W16B, 3, NotSerialized)
    {
        Arg0 = Arg2
        Arg1 = (Arg2 >> 0x08)
    }
    
    Method (RE1B, 1, NotSerialized)
    {
        Local0 = (0xFE708300 + Arg0)
        OperationRegion (ERM2, SystemMemory, Local0, One)
        Field (ERM2, ByteAcc, NoLock, Preserve)
        {
            BYTE,   8
        }

        Return (BYTE)
    }

    Method (RECB, 2, Serialized)
    {
        Arg1 = ((Arg1 + 0x07) >> 0x03)
        Name (TEMP, Buffer (Arg1){})
        Arg1 += Arg0 
        Local0 = Zero
        While ((Arg0 < Arg1))
        {
            TEMP [Local0] = RE1B (Arg0)
            Arg0++
            Local0++
        }

        Return (TEMP)
    }

Scope (_SB.PCI0.LPCB.EC0)
    {
        OperationRegion (ERAX, SystemMemory, 0xFE708300, 0x0100)
        Field (ERAX, ByteAcc, Lock, Preserve)
        {
            Offset (0x7E), 
            BTD0, 8,
            BTD1, 8,
            Offset (0x8E),
        }
        Field (ERAX, ByteAcc, Lock, Preserve)
        {
            Offset (0x7A), 
            BCC0, 8,
            BCC1, 8,
            Offset (0x81),
                , 8,
            BTN0, 8,
            BTN1, 8,
            BAP0, 8,
            BAP1, 8,
            BDV0, 8,
            BDV1, 8,
            Offset (0x8C), 
                , 1, 
                , 1, 
                , 1, 
                , 1, 
                , 1, 
                , 1, 
                , 1, 
                , 1, 
            Offset (0x8E), 
            BTI0, 8,
            BTI1, 8,
            BTV0, 8,
            BTV1, 8,
            BTC0, 8,
            BTC1, 8,
            BTF0, 8,
            BTF1, 8,
            Offset (0x9E), 
            ROC0, 8,
            ROC1, 8,
            Offset (0xCA)
        }
        
                Method (SELE, 0, Serialized)
        {
            W16B (BTD0, BTD1, BATN)
            Local0 = PWRS /* \PWRS */
            PWRS = ACDC /* \_SB_.PCI0.LPCB.EC0_.ACDC */
            If ((BATN & One))
            {
                ^^^^BAT1.BATP = 0x1F
            }
            Else
            {
                ^^^^BAT1.BATP = 0x0F
            }

            If (((BATN & 0x0FFF) != (BATO & 0x0FFF)))
            {
                Notify (BAT1, 0x81) // Information Change
                If ((((BATO & One) == One) && ((BATN & One
                    ) == Zero)))
                {
                    Sleep (0x14)
                }
            }

            If ((PWRS != Local0))
            {
                PNOT ()
            }

            BATO = BATN /* \_SB_.PCI0.LPCB.EC0_.BATN */
        }
    }

    Method (GCVA, 1, Serialized)
    {
        Name (BUFF, Buffer (0x0100){})
        Name (BCVF, Zero)
        Name (BCVT, Zero)
        Local0 = Arg0
        CreateByteField (BUFF, Zero, STAT)
        CreateByteField (BUFF, One, GCV1)
        CreateWordField (BUFF, 0x02, GCV2)
        CreateByteField (Arg0, 0x02, GCIN)
        STAT = Zero
        Switch (ToInteger (GCIN))
        {
            Case (0x20)
            {
                GCV1 = Zero
                GCV2 = B1B2(\_SB.PCI0.LPCB.EC0.BTV0, \_SB.PCI0.LPCB.EC0.BTV1)
            }
            Case (0x30)
            {
                Local1 = Zero
                BCVF = B1B2(\_SB.PCI0.LPCB.EC0.BTI0, \_SB.PCI0.LPCB.EC0.BTI1)
                If ((BCVF >= 0x8000))
                {
                    GCV1 = One
                    BCVT = ~BCVF /* \GCVA.BCVF */
                    GCV2 = (BCVT + One)
                }
                Else
                {
                    GCV1 = Zero
                    GCV2 = BCVF /* \GCVA.BCVF */
                }
            }
            Default
            {
                GCV1 = Zero
                GCV2 = Zero
                STAT = One
            }

        }

        Return (BUFF) /* \GCVA.BUFF */
    }

    Method (GPCI, 1, Serialized)
    {
        Name (BUFF, Buffer (0x0100){})
        Name (IADP, Zero)
        Name (IBAT, Zero)
        Name (VBAT, Zero)
        CreateByteField (BUFF, Zero, STAT)
        CreateByteField (BUFF, One, POVA)
        CreateByteField (Arg0, 0x02, GTST)
        STAT = Zero
        Switch (ToInteger (GTST))
        {
            Case (Zero)
            {
                Local1 = Zero
                IADP = \_SB.PCI0.LPCB.EC0.PADH
                IADP <<= 0x08
                IADP |= \_SB.PCI0.LPCB.EC0.PADL /* \GPCI.IADP */
                Local1 = (IADP * 0x023A)
                Local1 /= 0x07D0
                POVA = Local1
            }
            Case (0x08)
            {
                Local1 = Zero
                IBAT = \_SB.PCI0.LPCB.EC0.PBTH
                IBAT <<= 0x08
                IBAT |= \_SB.PCI0.LPCB.EC0.PBTL /* \GPCI.IBAT */
                VBAT = B1B2(\_SB.PCI0.LPCB.EC0.BTV0, \_SB.PCI0.LPCB.EC0.BTV1)
                IBAT *= 0x0F
                Local1 = (IBAT * VBAT) /* \GPCI.VBAT */
                Local1 /= 0x000F4240
                POVA = Local1
            }
            Default
            {
                POVA = Zero
                STAT = One
            }

        }

        If ((POVA == Zero))
        {
            STAT = One
        }

        Return (BUFF) /* \GPCI.BUFF */
    }

    Scope(\)
    {
        Method (CHKB, 0, NotSerialized)
        {
            If ((\_SB.BAT1.BATP == 0x1F))
            {
                If ((DerefOf (\_SB.BAT1.PBIF [One]) != B1B2(\_SB.PCI0.LPCB.EC0.BAP0, \_SB.PCI0.LPCB.EC0.BAP1)))
                {
                    Notify (\_SB.BAT1, 0x81) // Information Change
                }
            }
        }
    }
    Scope (_SB.BAT1)
    {
        Method (UPBX, 0, NotSerialized)
        {
            If (((^^PCI0.LPCB.EC0.BATL & One) == Zero))
            {
                Return (0xFF)
            }

            PBIX [0x02] = B1B2(^^PCI0.LPCB.EC0.BAP0, ^^PCI0.LPCB.EC0.BAP1) /* \_SB_.PCI0.LPCB.EC0_.BTAP */
            Name (FDDC, Zero)
            FDDC = ((B1B2(^^PCI0.LPCB.EC0.BAP0, ^^PCI0.LPCB.EC0.BAP1) / 0x0A) * 0x0B)
            If ((B1B2(^^PCI0.LPCB.EC0.BTF0, ^^PCI0.LPCB.EC0.BTF1) >= FDDC))
            {
                PBIX [0x03] = FDDC /* \_SB_.BAT1.UPBX.FDDC */
            }
            Else
            {
                PBIX [0x03] = B1B2(^^PCI0.LPCB.EC0.BTF0, ^^PCI0.LPCB.EC0.BTF1) /* \_SB_.PCI0.LPCB.EC0_.BTFC */
            }

            PBIX [0x05] = B1B2(^^PCI0.LPCB.EC0.BDV0, ^^PCI0.LPCB.EC0.BDV1) /* \_SB_.PCI0.LPCB.EC0_.BTDV */
            PBIX [0x08] = B1B2(^^PCI0.LPCB.EC0.BCC0, ^^PCI0.LPCB.EC0.BCC1) /* \_SB_.PCI0.LPCB.EC0_.BTCC */
            Local0 = RECB (0x30, 0x78) /* \_SB_.PCI0.LPCB.EC0_.BNAM */
            PBFE (Local0, ^^PCI0.LPCB.EC0.BNBC, Zero)
            PBIX [0x10] = Local0
            PBIX [0x11] = ITOS (ToBCD (B1B2(^^PCI0.LPCB.EC0.BTN0, ^^PCI0.LPCB.EC0.BTN1)))
            If (^^PCI0.LPCB.EC0.CHEM)
            {
                PBIX [0x12] = "NiMH"
            }
            Else
            {
                PBIX [0x12] = "LIon"
            }

            Local0 = RECB (0x60, 0x98) /* \_SB_.PCI0.LPCB.EC0_.BMFN */
            PBFE (Local0, ^^PCI0.LPCB.EC0.BMFC, Zero)
            PBIX [0x13] = Local0
            Return (Zero)
        }
        Method (UPBI, 0, NotSerialized)
        {
            If (((^^PCI0.LPCB.EC0.BATL & One) == Zero))
            {
                Return (0xFF)
            }

            PBIF [One] = B1B2(^^PCI0.LPCB.EC0.BAP0, ^^PCI0.LPCB.EC0.BAP1) /* \_SB_.PCI0.LPCB.EC0_.BTAP */
            PBIF [0x02] = B1B2(^^PCI0.LPCB.EC0.BTF0, ^^PCI0.LPCB.EC0.BTF1) /* \_SB_.PCI0.LPCB.EC0_.BTFC */
            PBIF [0x04] = B1B2(^^PCI0.LPCB.EC0.BDV0, ^^PCI0.LPCB.EC0.BDV1) /* \_SB_.PCI0.LPCB.EC0_.BTDV */
            Local0 = RECB (0x30, 0x78) /* \_SB_.PCI0.LPCB.EC0_.BNAM */
            PBFE (Local0, ^^PCI0.LPCB.EC0.BNBC, Zero)
            PBIF [0x09] = Local0
            PBIF [0x0A] = ITOS (ToBCD (B1B2 (^^PCI0.LPCB.EC0.BTN0, ^^PCI0.LPCB.EC0.BTN1)))
            If (^^PCI0.LPCB.EC0.CHEM)
            {
                PBIF [0x0B] = "NiMH"
            }
            Else
            {
                PBIF [0x0B] = "LIon"
            }

            Local0 = RECB (0x60, 0x98) /* \_SB_.PCI0.LPCB.EC0_.BMFN */
            PBFE (Local0, ^^PCI0.LPCB.EC0.BMFC, Zero)
            PBIF [0x0C] = Local0
            Return (Zero)
        }
        Method (UPBS, 0, NotSerialized)
        {
            If (((^^PCI0.LPCB.EC0.BATL & One) == Zero))
            {
                Return (0xFF)
            }

            Local0 = Zero
            If (((^^PCI0.LPCB.EC0.BATH & 0x0F) == One))
            {
                Local0 |= One
            }
            ElseIf ((^^PCI0.LPCB.EC0.BATH & 0x0C))
            {
                Local0 |= 0x02
            }

            PBST [Zero] = Local0
            Local1 = B1B2(^^PCI0.LPCB.EC0.BTI0, ^^PCI0.LPCB.EC0.BTI1) /* \_SB_.PCI0.LPCB.EC0_.BT1I */
            If ((Local1 & 0x8000))
            {
                Local1 |= 0xFFFF0000
                Local1 = ((0xFFFFFFFF - Local1) + One)
            }

            PBST [One] = Local1
            PBST [0x02] = B1B2(^^PCI0.LPCB.EC0.BTC0, ^^PCI0.LPCB.EC0.BTC1) /* \_SB_.PCI0.LPCB.EC0_.BT1C */
            PBST [0x03] = B1B2(^^PCI0.LPCB.EC0.BTV0, ^^PCI0.LPCB.EC0.BTV1) /* \_SB_.PCI0.LPCB.EC0_.BT1V */
            Return (Zero)
        }
    }
}