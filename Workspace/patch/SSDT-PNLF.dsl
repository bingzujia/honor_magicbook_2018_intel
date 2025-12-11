/*
 * Simplified SSDT-PNLF for Kaby Lake R / Coffee Lake / Whiskey Lake
 * Recommended for use with WhateverGreen.kext
 */
DefinitionBlock ("", "SSDT", 2, "ACDT", "PNLF", 0x00000000)
{
    External (_SB_.PCI0.GFX0, DeviceObj)

    Device (_SB.PCI0.GFX0.PNLF)
    {
        Name (_HID, EisaId ("APP0002"))  // _HID: Hardware ID
        Name (_CID, "backlight")  // _CID: Compatible ID
        // _UID 0x13 (19) is the correct value for 8th Gen (Kaby Lake R) and newer
        // If backlight does not work, try changing this to 0x10 (16)
        Name (_UID, 0x13) 
        Name (_STA, 0x0B)  // _STA: Status
    }
}
