/*
 * SSDT-GPRW.dsl
 *
 * Patch to disable wake from specific GPEs (USB, LAN, PCIe) to prevent instant/random wake.
 * Requires renaming GPRW to XPRW in config.plist.
 *
 * Find:    47 50 52 57 02
 * Replace: 58 50 52 57 02
 * Comment: change GPRW to XPRW
 */
DefinitionBlock ("", "SSDT", 2, "hack", "GPRW", 0x00000000)
{
    External (XPRW, MethodObj)

    Method (GPRW, 2, NotSerialized)
    {
        If (_OSI ("Darwin"))
        {
            // 0x6D is used by XHC (USB) and GLAN (Ethernet)
            If ((Arg0 == 0x6D))
            {
                Return (Package (0x02)
                {
                    0x6D, 
                    Zero
                })
            }

            // 0x69 is used by PXSX (PCIe devices like Wi-Fi/NVMe)
            If ((Arg0 == 0x69))
            {
                Return (Package (0x02)
                {
                    0x69, 
                    Zero
                })
            }
        }

        Return (XPRW (Arg0, Arg1))
    }
}
