/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20200925 (32-bit version)
 * Copyright (c) 2000 - 2020 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of ./battery_sample/SSDT-HWBT-MagicBook X Pro 2019.aml, Tue Dec  8 16:56:08 2020
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00000CB8 (3256)
 *     Revision         0x02
 *     Checksum         0xF0
 *     OEM ID           "OCLT"
 *     OEM Table ID     "BAT0"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20190509 (538510601)
 */
DefinitionBlock ("", "SSDT", 2, "OCLT", "BAT0", 0x00000000)
{
    External (_SB_.PCI0.LPCB.HWEC, DeviceObj)
    External (_SB_.PCI0.LPCB.HWEC.ALSD, DeviceObj)
    External (_SB_.PCI0.LPCB.HWEC.ALSD.ALRC, MethodObj)    // 1 Arguments
    External (_SB_.PCI0.LPCB.HWEC.ALSD.ALSC, MethodObj)    // 1 Arguments
    External (_SB_.PCI0.LPCB.HWEC.ALSD.ALSI, IntObj)
    External (_SB_.PCI0.LPCB.HWEC.ALSD.GLOV, MethodObj)    // 1 Arguments
    External (_SB_.PCI0.LPCB.HWEC.ALSD.GUPV, MethodObj)    // 1 Arguments
    External (_SB_.PCI0.LPCB.HWEC.ALSD.SLLV, IntObj)
    External (_SB_.PCI0.LPCB.HWEC.ALSD.SULV, IntObj)
    External (_SB_.PCI0.LPCB.HWEC.ALSD.X3PT, MethodObj)    // 0 Arguments
    External (_SB_.PCI0.LPCB.HWEC.ALSD.X3WK, MethodObj)    // 0 Arguments
    External (_SB_.PCI0.LPCB.HWEC.ALSD.XINI, MethodObj)    // 0 Arguments
    External (_SB_.PCI0.LPCB.HWEC.BALS, FieldUnitObj)
    External (_SB_.PCI0.LPCB.HWEC.BAT0, DeviceObj)
    External (_SB_.PCI0.LPCB.HWEC.BAT0.DVOT, IntObj)
    External (_SB_.PCI0.LPCB.HWEC.BAT0.XATW, MethodObj)    // 1 Arguments
    External (_SB_.PCI0.LPCB.HWEC.BAT0.XBIX, MethodObj)    // 0 Arguments
    External (_SB_.PCI0.LPCB.HWEC.BAT0.XBST, MethodObj)    // 0 Arguments
    External (_SB_.PCI0.LPCB.HWEC.EB0S, FieldUnitObj)
    External (_SB_.PCI0.LPCB.HWEC.ECAV, IntObj)
    External (_SB_.PCI0.LPCB.HWEC.ECCD, MethodObj)    // 3 Arguments
    External (_SB_.PCI0.LPCB.HWEC.ECMT, MutexObj)
    External (_SB_.PCI0.LPCB.HWEC.ECTK, IntObj)
    External (_SB_.PCI0.LPCB.HWEC.EPWS, FieldUnitObj)
    External (_SB_.PCI0.LPCB.HWEC.XCBM, MethodObj)    // 1 Arguments
    External (_SB_.PCI0.LPCB.HWEC.XCRD, MethodObj)    // 1 Arguments
    External (_SB_.PCI0.LPCB.HWEC.XCWT, MethodObj)    // 2 Arguments
    External (_SB_.PCI0.LPCB.HWEC.XQA8, MethodObj)    // 0 Arguments
    External (_SB_.PCI0.LPCB.HWEC.XQA9, MethodObj)    // 0 Arguments
    External (ADBG, MethodObj)    // 1 Arguments
    External (ASKV, FieldUnitObj)
    External (DVOT, IntObj)
    External (ECAV, IntObj)
    External (ECTK, IntObj)
    External (NTOC, MethodObj)    // 1 Arguments

    Method (B1B2, 2, NotSerialized)
    {
        Return ((Arg0 | (Arg1 << 0x08)))
    }

    Scope (_SB.PCI0.LPCB.HWEC)
    {
        OperationRegion (ECW2, EmbeddedControl, Zero, 0xFF)
        Field (ECW2, ByteAcc, NoLock, Preserve)
        {
            Offset (0x81), 
            EPWS,   8, 
            EB0S,   8, 
            Offset (0x92), 
            BVL0,   8, 
            BVL1,   8, 
            BRC0,   8, 
            BRC1,   8, 
            BFC0,   8, 
            BFC1,   8, 
            BST0,   8, 
            BST1,   8, 
            BCC0,   8, 
            BCC1,   8, 
            Offset (0xA2), 
            BDC0,   8, 
            BDC1,   8, 
            BDV0,   8, 
            BDV1,   8, 
            BSN0,   8, 
            BSN1,   8, 
            Offset (0xAA), 
            BCT0,   8, 
            BCT1,   8, 
            Offset (0xE7), 
            EKV1,   8, 
            EKV2,   8, 
            EALS,   1, 
                ,   1, 
                ,   1, 
                ,   1, 
                ,   1, 
                ,   1, 
                ,   1, 
            BALS,   1, 
            EUL1,   8, 
            EUL2,   8, 
            ELL1,   8, 
            ELL2,   8, 
            CLS1,   8, 
            CLS2,   8, 
            ELU1,   8, 
            ELU2,   8
        }

        Method (ECBM, 1, Serialized)
        {
            If (_OSI ("Darwin"))
            {
                Name (BMB1, Buffer (0x40){})
                If (((Arg0 == Zero) || (Arg0 == One)))
                {
                    If ((Arg0 == Zero))
                    {
                        Local0 = 0x8A
                    }

                    If ((Arg0 == One))
                    {
                        Local0 = 0x89
                    }

                    BMB1 = ECCD (Local0, 0x08, Buffer (0x08){})
                    Local0 = DerefOf (BMB1 [One])
                    If ((Local0 != Zero))
                    {
                        Name (BMB2, Buffer ((Local0 + One)){})
                        Local2 = Zero
                        While ((Local2 < Local0))
                        {
                            BMB2 [Local2] = DerefOf (BMB1 [(Local2 + 0x03)]
                                )
                            Local2++
                        }

                        Return (BMB2) /* \_SB_.PCI0.LPCB.HWEC.ECBM.BMB2 */
                    }
                }

                If ((Arg0 == 0x02))
                {
                    Local0 = B1B2 (ECRD (RefOf (BSN0)), ECRD (RefOf (BSN1)))
                    BMB1 [0x03] = NTOC (Local0)
                    BMB1 [0x02] = NTOC ((Local0 >> 0x04))
                    BMB1 [One] = NTOC ((Local0 >> 0x08))
                    BMB1 [Zero] = NTOC ((Local0 >> 0x0C))
                    Return (BMB1) /* \_SB_.PCI0.LPCB.HWEC.ECBM.BMB1 */
                }

                Return (Package (0x08)
                {
                    0x55, 
                    0x6E, 
                    0x6B, 
                    0x6E, 
                    0x6F, 
                    0x77, 
                    0x6E, 
                    Zero
                })
            }
            Else
            {
                Return (XCBM (Arg0))
            }
        }

        Method (ECRD, 1, Serialized)
        {
            If (_OSI ("Darwin"))
            {
                If (ECTK)
                {
                    ECTK = Zero
                }

                Local0 = Acquire (ECMT, 0x03E8)
                If ((Local0 == Zero))
                {
                    If (ECAV)
                    {
                        Local1 = DerefOf (Arg0)
                        Release (ECMT)
                        Return (Local1)
                    }
                    Else
                    {
                        Release (ECMT)
                    }
                }

                Return (Zero)
            }
            Else
            {
                Return (XCRD (Arg0))
            }
        }

        Method (ECWT, 2, Serialized)
        {
            If (_OSI ("Darwin"))
            {
                If (ECTK)
                {
                    ECTK = Zero
                }

                Local0 = Acquire (ECMT, 0x03E8)
                If ((Local0 == Zero))
                {
                    If (ECAV)
                    {
                        Arg1 = Arg0
                    }

                    Release (ECMT)
                }
            }
            Else
            {
                XCWT (Arg0, Arg1)
            }
        }

        Scope (BAT0)
        {
            Method (CATW, 1, Serialized)
            {
                If (_OSI ("Darwin"))
                {
                    Local0 = (Arg0 * B1B2 (ECRD (RefOf (BDV0)), ECRD (RefOf (BDV1))))
                    Local1 = (Local0 / 0x03E8)
                    Return (Local1)
                }
                Else
                {
                    Return (XATW (Arg0))
                }
            }

            Method (_BIX, 0, Serialized)  // _BIX: Battery Information Extended
            {
                If (_OSI ("Darwin"))
                {
                    Name (BPK1, Package (0x15)
                    {
                        One, 
                        Zero, 
                        0xFFFFFFFF, 
                        0xFFFFFFFF, 
                        One, 
                        0xFFFFFFFF, 
                        Zero, 
                        Zero, 
                        0x64, 
                        0x00017318, 
                        Zero, 
                        Zero, 
                        Zero, 
                        Zero, 
                        0x0100, 
                        0x40, 
                        "BASE-BAT", 
                        "123456789", 
                        "LION", 
                        "Simplo", 
                        Zero
                    })
                    If ((ECAV && (B1B2 (ECRD (RefOf (BDV0)), ECRD (RefOf (BDV1))) && (
                        B1B2 (ECRD (RefOf (BDC0)), ECRD (RefOf (BDC1))) && B1B2 (ECRD (RefOf (BFC0)), ECRD (RefOf (
                        BFC1)))))))
                    {
                        DVOT = B1B2 (ECRD (RefOf (BDV0)), ECRD (RefOf (BDV1)))
                        BPK1 [0x02] = CATW (B1B2 (ECRD (RefOf (BDC0)), ECRD (RefOf (
                            BDC1))))
                        BPK1 [0x03] = CATW (B1B2 (ECRD (RefOf (BFC0)), ECRD (RefOf (
                            BFC1))))
                        BPK1 [0x05] = DVOT /* External reference */
                        BPK1 [0x06] = ((DerefOf (BPK1 [0x03]) * 0x05
                            ) / 0x64)
                        BPK1 [0x07] = ((DerefOf (BPK1 [0x03]) * One
                            ) / 0x64)
                        BPK1 [0x08] = B1B2 (ECRD (RefOf (BCT0)), ECRD (RefOf (BCT1)))
                        BPK1 [0x0B] = 0x0320
                        BPK1 [0x0A] = 0x251C
                        BPK1 [0x10] = ToString (ECBM (Zero), Ones)
                        BPK1 [0x11] = ToString (ECBM (0x02), Ones)
                        BPK1 [0x13] = ToString (ECBM (One), Ones)
                    }

                    Return (BPK1) /* \_SB_.PCI0.LPCB.HWEC.BAT0._BIX.BPK1 */
                }
                Else
                {
                    Return (XBIX ())
                }
            }

            Method (_BST, 0, Serialized)  // _BST: Battery Status
            {
                If (_OSI ("Darwin"))
                {
                    Name (PKG1, Package (0x04)
                    {
                        0xFFFFFFFF, 
                        0xFFFFFFFF, 
                        0xFFFFFFFF, 
                        0xFFFFFFFF
                    })
                    If (ECAV)
                    {
                        Local0 = B1B2 (ECRD (RefOf (BST0)), ECRD (RefOf (BST1)))
                        Local1 = B1B2 (ECRD (RefOf (BCC0)), ECRD (RefOf (BCC1)))
                        Local2 = B1B2 (ECRD (RefOf (BRC0)), ECRD (RefOf (BRC1)))
                        Local3 = B1B2 (ECRD (RefOf (BVL0)), ECRD (RefOf (BVL1)))
                        Local4 = ECRD (RefOf (EB0S))
                        Local5 = Zero
                        If ((ECRD (RefOf (EPWS)) & One))
                        {
                            If (((Local4 & 0x02) && ((0x40 & Local0) == Zero)))
                            {
                                Local5 |= 0x02
                            }
                            ElseIf (((0x40 & Local0) && (0x8000 & Local1)))
                            {
                                Local5 |= One
                            }
                        }
                        Else
                        {
                            Local5 |= One
                        }

                        If ((0x0300 & Local0))
                        {
                            Local5 |= 0x04
                        }

                        If ((Local1 >= 0x8000))
                        {
                            Local1 = (0xFFFF - Local1)
                            Local1 += One
                        }

                        PKG1 [Zero] = Local5
                        PKG1 [One] = CATW (Local1)
                        PKG1 [0x02] = CATW (Local2)
                        PKG1 [0x03] = Local3
                    }

                    Return (PKG1) /* \_SB_.PCI0.LPCB.HWEC.BAT0._BST.PKG1 */
                }
                Else
                {
                    Return (XBST ())
                }
            }
        }

        Method (_QA8, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            If (_OSI ("Darwin"))
            {
                Local0 = B1B2 (ECRD (RefOf (ELU1)), ECRD (RefOf (ELU2)))
                Local0 = ^ALSD.ALSC (Local0)
                ^ALSD.ALSI = Local0
                ECWT (Local0, RefOf (CLS1))
                ECWT ((Local0 >> 0x08), RefOf (CLS2))
                Local1 = ^ALSD.GUPV (Local0)
                Local2 = ^ALSD.GLOV (Local0)
                Local1 = ^ALSD.ALRC (Local1)
                Local2 = ^ALSD.ALRC (Local2)
                ECWT (Local1, RefOf (EUL1))
                ECWT ((Local1 >> 0x08), RefOf (EUL2))
                ECWT (Local2, RefOf (ELL1))
                ECWT ((Local2 >> 0x08), RefOf (ELL2))
                ECWT (One, RefOf (BALS))
                Notify (ALSD, 0x80) // Status Change
            }
            Else
            {
                XQA8 ()
            }
        }

        Method (_QA9, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            If (_OSI ("Darwin"))
            {
                Local3 = B1B2 (ECRD (RefOf (EKV1)), ECRD (RefOf (EKV2)))
                ASKV = Local3
                Local0 = B1B2 (ECRD (RefOf (ELU1)), ECRD (RefOf (ELU2)))
                Local0 = ^ALSD.ALSC (Local0)
                ^ALSD.ALSI = Local0
                ECWT (Local0, RefOf (CLS1))
                ECWT ((Local0 >> 0x08), RefOf (CLS2))
                Local1 = ^ALSD.GUPV (Local0)
                Local2 = ^ALSD.GLOV (Local0)
                Local1 = ^ALSD.ALRC (Local1)
                Local2 = ^ALSD.ALRC (Local2)
                ECWT (Local1, RefOf (EUL1))
                ECWT ((Local1 >> 0x08), RefOf (EUL2))
                ECWT (Local2, RefOf (ELL1))
                ECWT ((Local2 >> 0x08), RefOf (ELL2))
                ECWT (One, RefOf (BALS))
                Notify (ALSD, 0x80) // Status Change
                ADBG ("Update-ALS-K")
            }
            Else
            {
                XQA9 ()
            }
        }

        Scope (ALSD)
        {
            Method (_INI, 0, NotSerialized)  // _INI: Initialize
            {
                If (_OSI ("Darwin"))
                {
                    Local0 = B1B2 (ECRD (RefOf (ELU1)), ECRD (RefOf (ELU2)))
                    Local0 = ALSC (Local0)
                    ECWT (Local0, RefOf (CLS1))
                    ECWT ((Local0 >> 0x08), RefOf (CLS2))
                    ALSI = Local0
                    Local1 = GUPV (Local0)
                    Local2 = GLOV (Local0)
                    Local1 = ALRC (Local1)
                    Local2 = ALRC (Local2)
                    ECWT (Local1, RefOf (EUL1))
                    ECWT ((Local1 >> 0x08), RefOf (EUL2))
                    ECWT (Local2, RefOf (ELL1))
                    ECWT ((Local2 >> 0x08), RefOf (ELL2))
                    ECWT (One, RefOf (BALS))
                }
                Else
                {
                    XINI ()
                }
            }

            Method (S3WK, 0, NotSerialized)
            {
                If (_OSI ("Darwin"))
                {
                    ECWT (SULV, RefOf (EUL1))
                    ECWT ((SULV >> 0x08), RefOf (EUL2))
                    ECWT (SLLV, RefOf (ELL1))
                    ECWT ((SLLV >> 0x08), RefOf (ELL2))
                    ECWT (One, RefOf (BALS))
                }
                Else
                {
                    X3WK ()
                }
            }

            Method (S3PT, 0, NotSerialized)
            {
                If (_OSI ("Darwin"))
                {
                    SULV = B1B2 (ECRD (RefOf (EUL1)), ECRD (RefOf (EUL2)))
                    SLLV = B1B2 (ECRD (RefOf (ELL1)), ECRD (RefOf (ELL2)))
                }
                Else
                {
                    X3PT ()
                }
            }
        }
    }
}

