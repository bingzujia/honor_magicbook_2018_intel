/*
 * SSDT: LID Assist
 * Improved _LID handling for macOS (Darwin)
 * - Keeps original behavior (calls UPDL/XLID fallback)
 * - Ensures GPU receives GLID/Notify so framebuffer/backlight reinitialises
 * - Uses CondRefOf to avoid runtime errors when objects are absent
 *
 * WARNING: Test this in a safe environment and make a backup of existing DSDT/SSDT
 */
DefinitionBlock ("", "SSDT", 2, "hack", "LIDASS", 0x00000000)
{
    External (_SB_.LID0, DeviceObj)
    External (_SB_.LID0.LDRT, IntObj)
    External (_SB_.LID0.XLID, MethodObj)    // 0 Arguments (original)
    External (ECOK, IntObj)                 // EC OK flag
    External (LIDS, UnknownObj)             // Lid status variable
    External (UPDL, MethodObj)              // EC update method
    External (_SB_.PCI0.GFX0, DeviceObj)    // GPU device object
    External (_SB_.PCI0.GFX0.GLID, MethodObj)    // GPU GLID method (1 arg)
    External (_SB_.PCI0.GFX0.DD1F, DeviceObj)    // GPU vendor device (if present)

    Method (_SB.LID0._LID, 0, NotSerialized)  // _LID: Lid Status
    {
        /* Only run enhanced behavior on macOS */
        If (_OSI ("Darwin"))
        {
            /* Keep existing behavior: update EC and reset LDRT */
            If (ECOK)
            {
                UPDL ()
                \_SB.LID0.LDRT = Zero
            }

            /* Single UPDL call: update EC read only when ECOK is true */
            /* (Double call removed per request to avoid redundant operations) */

            /* If GPU object exists, try to call GLID and notify it so the driver can refresh */
            If (CondRefOf (\_SB.PCI0.GFX0))
            {
                /* Try safe GLID call */
                If (CondRefOf (\_SB.PCI0.GFX0.GLID))
                {
                    \_SB.PCI0.GFX0.GLID (LIDS)
                }

                /* Notify GPU status change (fallback if GLID not present or to trigger HW paths) */
                Notify (\_SB.PCI0.GFX0, 0x80) /* Status Change */

                /* If vendor-specific device exists (DD1F), notify it as well.
                   Use 0x86/0x87 depending on LIDS to match BIOS behavior (open/close notifications).
                   NOTE: If you see opposite behavior (open/close reversed), swap 0x86/0x87 here. */
                If (CondRefOf (\_SB.PCI0.GFX0.DD1F))
                {
                    If (LIDS)
                    {
                        /* LIDS == 1 -> hypothesised: lid closed -> send 0x87 (close event) */
                        Notify (\_SB.PCI0.GFX0.DD1F, 0x87)
                    }
                    Else
                    {
                        /* LIDS == 0 -> hypothesised: lid open -> send 0x86 (open event) */
                        Notify (\_SB.PCI0.GFX0.DD1F, 0x86)
                    }
                }
            }

            /*
             * Also trigger a bus check on the DGPU root port to force OS re-enumeration.
             * This helps when macOS does not reinitialize GPU resources or the panel after lid events.
             */
            If (CondRefOf (\_SB.PCI0.RP01))
            {
                Notify (\_SB.PCI0.RP01, Zero) /* Bus Check - force re-enumeration */
            }

            /* Return the lid status to OS as before */
            Return (LIDS)
        }

        /* Non-Darwin platforms: fallback to original XLID() call */
        Return (XLID ())
    }
}
