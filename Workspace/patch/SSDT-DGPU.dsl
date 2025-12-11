/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20200925 (64-bit version)
 * Copyright (c) 2000 - 2020 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of SSDT-DGPU.aml, Thu Dec 11 19:52:14 2025
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x000000AE (174)
 *     Revision         0x02
 *     Checksum         0xC0
 *     OEM ID           "HACK"
 *     OEM Table ID     "DGPU"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20200528 (538969384)
 */
DefinitionBlock ("", "SSDT", 2, "HACK", "DGPU", 0x00000000)
{
    External (_SB_.PCI0.RP01.PXSX._OFF, MethodObj)    // 0 Arguments

    Device (RMD1)
    {
        Name (_HID, "RMD10000")  // _HID: Hardware ID
        Method (_INI, 0, NotSerialized)  // _INI: Initialize
        {
            If (CondRefOf (\_SB.PCI0.RP01.PXSX._OFF))
            {
                \_SB.PCI0.RP01.PXSX._OFF ()
                /* trigger a bus check to force the OS to re-enumerate the root port */
                If (CondRefOf (\_SB.PCI0.RP01))
                {
                    Notify (\_SB.PCI0.RP01, Zero) // Bus Check
                }
            }
        }

        Method (_STA, 0, NotSerialized)  // _STA: Status
        {
            /*
             * On macOS (Darwin) we want the DGPU to be hidden so the OS does not enumerate
             * the device and load a driver for it. Returning Zero marks the device as not present.
             * If you prefer the device to be visible but powered off (e.g., for debugging),
             * set this to Return (0x0F) for Darwin instead.
             */
            If (_OSI ("Darwin"))
            {
                Return (Zero) /* Hide the device from macOS */
            }
            Else
            {
                /* keep behavior for other OS (host OSes) */
                Return (0x0F)
            }
        }
    }
}

