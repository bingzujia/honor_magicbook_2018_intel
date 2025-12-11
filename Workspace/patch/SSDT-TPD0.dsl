/*
 * Disable Touchscreen (TPL1 on I2C1)
 * 
 * This SSDT disables the I2C1 controller, which hosts the Wacom Touchscreen (TPL1).
 * This is useful if the touchscreen is causing issues or to save power if not used.
 */
DefinitionBlock ("", "SSDT", 2, "HACK", "NoTouch", 0x00000000)
{
    External (_SB_.PCI0.I2C1, DeviceObj)

    Scope (_SB.PCI0.I2C1)
    {
        Method (_STA, 0, NotSerialized)  // _STA: Status
        {
            If (_OSI ("Darwin"))
            {
                Return (Zero) // Disable Device in macOS
            }
            Else
            {
                Return (0x0F) // Enable Device in other OS
            }
        }
    }
}

