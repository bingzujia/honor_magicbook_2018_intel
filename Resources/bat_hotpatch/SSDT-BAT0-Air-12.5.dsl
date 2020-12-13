/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20200925 (32-bit version)
 * Copyright (c) 2000 - 2020 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of ./battery_sample/SSDT-BAT0-Air 12.5Ò»´ú.aml, Tue Dec  8 16:59:51 2020
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00000314 (788)
 *     Revision         0x02
 *     Checksum         0xB5
 *     OEM ID           "ACDT"
 *     OEM Table ID     "BATT"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20190509 (538510601)
 */
DefinitionBlock ("", "SSDT", 2, "ACDT", "BATT", 0x00000000)
{
    External (_SB_.PCI0.LPCB, DeviceObj)
    External (_SB_.PCI0.LPCB.BAT0, DeviceObj)
    External (_SB_.PCI0.LPCB.BAT0.BIF1, PkgObj)
    External (_SB_.PCI0.LPCB.BAT0.ITOS, MethodObj)    // 1 Arguments
    External (_SB_.PCI0.LPCB.BAT0.XBIF, MethodObj)    // 0 Arguments
    External (_SB_.PCI0.LPCB.EC94, FieldUnitObj)
    External (_SB_.PCI0.LPCB.EC95, FieldUnitObj)
    External (_SB_.PCI0.LPCB.ECAA, FieldUnitObj)
    External (_SB_.PCI0.LPCB.ECAB, FieldUnitObj)
    External (_SB_.PCI0.LPCB.ECAC, FieldUnitObj)
    External (_SB_.PCI0.LPCB.ECAD, FieldUnitObj)
    External (_SB_.PCI0.LPCB.ECAE, FieldUnitObj)
    External (_SB_.PCI0.LPCB.ECAF, FieldUnitObj)
    External (_SB_.PCI0.LPCB.ECB9, FieldUnitObj)
    External (_SB_.PCI0.LPCB.ECBA, FieldUnitObj)
    External (_SB_.PCI0.LPCB.ECOK, IntObj)
    External (BIF1, IntObj)
    External (ECAA, IntObj)
    External (ECAB, IntObj)
    External (ECAC, IntObj)
    External (ECAD, IntObj)
    External (ECAE, IntObj)
    External (ECAF, IntObj)
    External (ECB9, IntObj)
    External (ECBA, IntObj)
    External (ECOK, IntObj)

    Scope (_SB.PCI0.LPCB)
    {
        Method (RE1B, 1, NotSerialized)
        {
            Local0 = (0xFE800100 + Arg0)
            OperationRegion (ERM2, SystemMemory, Local0, One)
            Field (ERM2, ByteAcc, NoLock, Preserve)
            {
                BYTE,   8
            }

            Return (BYTE) /* \_SB_.PCI0.LPCB.RE1B.BYTE */
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

            Return (TEMP) /* \_SB_.PCI0.LPCB.RECB.TEMP */
        }

        Scope (BAT0)
        {
            Method (_BIF, 0, NotSerialized)  // _BIF: Battery Information
            {
                If (_OSI ("Darwin"))
                {
                    If (ECOK)
                    {
                        Local0 = ECAE /* External reference */
                        Local5 = ECAF /* External reference */
                        Local5 <<= 0x08
                        Local0 += Local5
                        BIF1 [0x04] = Local0
                        Local2 = Local0
                        Local0 = ECAA /* External reference */
                        Local5 = ECAB /* External reference */
                        Local5 <<= 0x08
                        Local0 += Local5
                        Local0 *= Local2
                        Divide (Local0, 0x03E8, Local3, Local0)
                        BIF1 [0x02] = Local0
                        Local1 = ECAC /* External reference */
                        Local5 = ECAD /* External reference */
                        Local5 <<= 0x08
                        Local1 += Local5
                        Local1 *= Local2
                        Divide (Local1, 0x03E8, Local3, Local1)
                        BIF1 [One] = Local1
                        BIF1 [0x08] = Local0
                        Concatenate (RECB (0x11, 0x28), RECB (0x76, 0x40), Local0)
                        BIF1 [0x09] = Local0
                        Local0 = ECB9 /* External reference */
                        Local5 = ECBA /* External reference */
                        Local5 <<= 0x08
                        Local0 += Local5
                        Local1 = ITOS (Local0)
                        BIF1 [0x0A] = Local1
                    }
                    Else
                    {
                        BIF1 [One] = 0xFFFFFFFF
                        BIF1 [0x04] = 0xFFFFFFFF
                    }

                    Return (BIF1) /* External reference */
                }
                Else
                {
                    Return (XBIF ())
                }
            }
        }
    }
}

