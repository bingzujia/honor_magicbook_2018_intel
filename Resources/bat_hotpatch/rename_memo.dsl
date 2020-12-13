DefinitionBlock ("", "SSDT", 2, "ACDT", "BATT", 0x00000000)
{
    Method (SELE, 0, Serialized)
    {}
    Method (XELE, 0, Serialized)
    {}
    Method (UPBI, 0, NotSerialized)
    {}
    Method (XPBI, 0, NotSerialized)
    {}
    Method (UPBX, 0, NotSerialized)
    {}
    Method (XPBX, 0, NotSerialized)
    {}
    Method (CHKB, 0, NotSerialized)
    {}
    Method (XHKB, 0, NotSerialized)
    {}
    Method (UPBS, 0, NotSerialized)
    {}
    Method (XPBS, 0, NotSerialized)
    {}
    Method (GCVA, 1, Serialized)
    {
        Return (Arg0)
    }
    Method (XCVA, 1, Serialized)
    {
        Return (Arg0)
    }
    Method (GPCI, 1, Serialized)
    {
        Return (Arg0)
    }
    Method (XPCI, 1, Serialized)
    {
        Return (Arg0)
    }
}