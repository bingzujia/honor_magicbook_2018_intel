/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20200925 (64-bit version)
 * Copyright (c) 2000 - 2020 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of SSDT-_LID.aml, Thu Dec 11 19:52:14 2025
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x000000BA (186)
 *     Revision         0x02
 *     Checksum         0x2B
 *     OEM ID           "hack"
 *     OEM Table ID     "_LID"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20200528 (538969384)
 */
DefinitionBlock ("", "SSDT", 2, "hack", "_LID", 0x00000000)
{
    External (_SB_.LID0, DeviceObj)
    External (_SB_.LID0.LDRT, IntObj)
    External (_SB_.LID0.XLID, MethodObj)    // 0 Arguments
    External (ECOK, IntObj)
    External (LIDS, UnknownObj)
    External (UPDL, MethodObj)    // 0 Arguments

    Method (_SB.LID0._LID, 0, NotSerialized)  // _LID: Lid Status
    {
        If (_OSI ("Darwin"))
        {
            If (ECOK)
            {
                UPDL ()
                \_SB.LID0.LDRT = Zero
            }

            UPDL ()
            Return (LIDS) /* External reference */
        }

        Return (XLID ())
    }
}

