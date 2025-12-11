/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20200925 (64-bit version)
 * Copyright (c) 2000 - 2020 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of SSDT-EC.aml, Thu Dec 11 19:52:14 2025
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00000116 (278)
 *     Revision         0x02
 *     Checksum         0xEB
 *     OEM ID           "HACK"
 *     OEM Table ID     "FKEC"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20200528 (538969384)
 */
DefinitionBlock ("", "SSDT", 2, "HACK", "FKEC", 0x00000000)
{
    External (_SB_.PCI0.LPCB, DeviceObj)

    Scope (\_SB)
    {
        Device (USBX)
        {
            Name (_ADR, Zero)  // _ADR: Address
            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                If ((Arg2 == Zero))
                {
                    Return (Buffer (One)
                    {
                         0x03                                             // .
                    })
                }

                Return (Package (0x08)
                {
                    "kUSBSleepPowerSupply", 
                    0x13EC, 
                    "kUSBSleepPortCurrentLimit", 
                    0x0834, 
                    "kUSBWakePowerSupply", 
                    0x13EC, 
                    "kUSBWakePortCurrentLimit", 
                    0x0834
                })
            }
        }

        /*
         * Override existing EC0 _STA to ensure macOS sees the EC as present.
         * We prefer to override the real EC device (\_SB.PCI0.LPCB.EC0) instead
         * of creating a duplicate Device (EC) which could cause conflicts.
         */
        External (_SB_.PCI0.LPCB.EC0, DeviceObj)
        Scope (\_SB.PCI0.LPCB.EC0)
        {
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                /*
                 * Keep this minimal and safe: expose EC on Darwin only.
                 * Returning 0x0F indicates Present/Enabled/Functional.
                 */
                If (_OSI ("Darwin"))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (Zero)
                }
            }

            /*
             * Minimal Device-Specific Method (_DSM) for EC0 to expose
             * limited DSM behavior to macOS if requested. This method is
             * intentionally conservative: it only implements the function
             * 0 (Get DSM capabilities) so macOS may query the device.
             */
            Method (_DSM, 4, NotSerialized)
            {
                /* Function 0: return capability bits as Buffer
                 * If Arg2 == 0, we return a simple bitmask buffer.
                 */
                If ((Arg2 == Zero))
                {
                    Return (Buffer (One)
                    {
                         0x03 /* Basic capability flags */
                    })
                }

                /* Default: return an empty package / no-op to avoid breaking callers */
                Return (Package (0x01)
                {
                    Zero
                })
            }
        }
    }
}

