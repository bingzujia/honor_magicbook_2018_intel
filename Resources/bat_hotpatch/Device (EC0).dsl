        Device (EC0)
        {
            Name (_HID, EisaId ("PNP0C09"))  // _HID: Hardware ID
            Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
            {
                IO (Decode16,
                    0x0062,             // Range Minimum
                    0x0062,             // Range Maximum
                    0x00,               // Alignment
                    0x01,               // Length
                    )
                IO (Decode16,
                    0x0066,             // Range Minimum
                    0x0066,             // Range Maximum
                    0x00,               // Alignment
                    0x01,               // Length
                    )
            })
            Method (_GPE, 0, NotSerialized)  // _GPE: General Purpose Events
            {
                Store (GGPE (0x02040010), Local0)
                Return (Local0)
            }

            OperationRegion (ERAM, SystemMemory, 0xFE708300, 0x0100)
            Field (ERAM, ByteAcc, Lock, Preserve)
            {
                Offset (0x7E), 
                BATL,   8, 
                BATH,   8
            }

            Field (ERAM, ByteAcc, Lock, Preserve)
            {
                Offset (0x7E), 
                BATD,   16, 
                Offset (0x8E), 
                B1IH,   8, 
                B1IL,   8, 
                B1VH,   8, 
                B1VL,   8
            }

            Field (ERAM, ByteAcc, Lock, Preserve)
            {
                Offset (0x11), 
                BDID,   3, 
                    ,   1, 
                SKID,   1, 
                TPID,   1, 
                    ,   1, 
                MEFW,   1, 
                ACDC,   1, 
                RTCP,   1, 
                WOLP,   1, 
                WWLP,   1, 
                    ,   1, 
                CRBT,   1, 
                    ,   1, 
                LPSW,   1, 
                Offset (0x15), 
                FNIS,   1, 
                FNKL,   1, 
                    ,   2, 
                WKYS,   1, 
                Offset (0x16), 
                RGC6,   1, 
                IGC6,   1, 
                ENSG,   1, 
                    ,   1, 
                MIMT,   1, 
                LSTE,   1, 
                Offset (0x1A), 
                    ,   2, 
                NMIT,   1, 
                    ,   1, 
                S5FG,   1, 
                Offset (0x1B), 
                D3BL,   1, 
                D3IK,   1, 
                D3LO,   1, 
                Offset (0x1C), 
                    ,   1, 
                SPMD,   1, 
                    ,   1, 
                    ,   1, 
                WDTE,   1, 
                WDBE,   1, 
                Offset (0x1E), 
                OEM1,   8, 
                OEM2,   8, 
                CTMP,   8, 
                VGAT,   8, 
                PCHT,   8, 
                SYST,   8, 
                DDRT,   8, 
                CNTC,   8, 
                VGET,   8, 
                TNTC,   8, 
                Offset (0x29), 
                STM0,   8, 
                Offset (0x2B), 
                BTTL,   8, 
                Offset (0x30), 
                BNAM,   120, 
                BNBC,   8, 
                Offset (0x49), 
                TPLT,   8, 
                Offset (0x4C), 
                UTPC,   8, 
                DTPC,   8, 
                UCHG,   8, 
                DCHG,   8, 
                Offset (0x54), 
                EPBT,   8, 
                EPBP,   8, 
                Offset (0x58), 
                ACWT,   8, 
                PSSP,   8, 
                CCPS,   8, 
                CMPS,   8, 
                BCCL,   8, 
                BCCH,   8, 
                Offset (0x60), 
                BMFN,   152, 
                BMFC,   8, 
                Offset (0x7A), 
                BTCC,   16, 
                Offset (0x81), 
                BTML,   8, 
                BTSN,   16, 
                BTAP,   16, 
                BTDV,   16, 
                Offset (0x8C), 
                BSTI,   1, 
                BSTV,   1, 
                BSTC,   1, 
                BSTF,   1, 
                BSTD,   1, 
                BSDD,   1, 
                BSAN,   1, 
                CHEM,   1, 
                Offset (0x8E), 
                BT1I,   16, 
                BT1V,   16, 
                BT1C,   16, 
                BTFC,   16, 
                Offset (0x9E), 
                RSOC,   16, 
                Offset (0xCA), 
                ENGD,   8, 
                BRGD,   8, 
                FRHI,   8, 
                FRLO,   8, 
                Offset (0xD0), 
                UCPU,   8, 
                DCPU,   8, 
                UBAT,   8, 
                DBAT,   8, 
                USYS,   8, 
                DSYS,   8, 
                UDDR,   8, 
                DDDR,   8, 
                UPCH,   8, 
                DPCH,   8, 
                UGPE,   8, 
                DGPE,   8, 
                CPUF,   1, 
                BAUF,   1, 
                SYUF,   1, 
                DRUF,   1, 
                PHUF,   1, 
                GPUF,   1, 
                TPUF,   1, 
                CGUF,   1, 
                CPDF,   1, 
                BADF,   1, 
                SYDF,   1, 
                DRDF,   1, 
                PHDF,   1, 
                GPDF,   1, 
                TPDF,   1, 
                CGDF,   1, 
                TFUC,   1, 
                TFUB,   1, 
                TFUL,   1, 
                TFUD,   1, 
                TFUR,   1, 
                TFUG,   1, 
                TFUT,   1, 
                TFUH,   1, 
                TFDC,   1, 
                TFDB,   1, 
                TFDL,   1, 
                TFDD,   1, 
                TFDR,   1, 
                TFDG,   1, 
                TFDT,   1, 
                TFDH,   1, 
                Offset (0xE1), 
                PXTF,   8, 
                PG1U,   8, 
                PG1D,   8, 
                PG2U,   8, 
                PG2D,   8, 
                PG3U,   8, 
                PG3D,   8, 
                PADH,   8, 
                PADL,   8, 
                PBTH,   8, 
                PBTL,   8, 
                EWTH,   8, 
                EWTL,   8, 
                Offset (0xF0), 
                Offset (0xF1), 
                WUSR,   8, 
                Offset (0xFB), 
                TOTP,   1, 
                AOCP,   1, 
                BOCP,   1, 
                BTP1,   1, 
                BTP2,   1, 
                BTP3,   1, 
                BOPP,   1, 
                VOTP,   1, 
                KCMS,   8
            }

            OperationRegion (IO, SystemIO, 0x68, 0x05)
            Field (IO, ByteAcc, Lock, Preserve)
            {
                DAT1,   8, 
                Offset (0x04), 
                CMD1,   8
            }

            Field (IO, ByteAcc, Lock, Preserve)
            {
                Offset (0x04), 
                OUTS,   1, 
                INPS,   1
            }

            Method (ECMD, 3, Serialized)
            {
                Store (0x03E8, Local0)
                While (LAnd (INPS, Local0))
                {
                    Decrement (Local0)
                    Sleep (One)
                }

                If (Local0)
                {
                    Store (Arg0, CMD1)
                }
                Else
                {
                    Return (Zero)
                }

                If (Arg1)
                {
                    Store (0x03E8, Local0)
                    While (LAnd (INPS, Local0))
                    {
                        Decrement (Local0)
                        Sleep (One)
                    }

                    If (Local0)
                    {
                        Store (Arg2, DAT1)
                    }
                    Else
                    {
                        Return (Zero)
                    }
                }
            }

            Method (_REG, 2, NotSerialized)  // _REG: Region Availability
            {
                If (LEqual (Arg0, 0x03))
                {
                    Store (Arg1, ECOK)
                    Store (Arg1, ECRD)
                    If (ECOK)
                    {
                        Store (One, PWRS)
                        Store (One, LIDS)
                        UPDL ()
                        SELE ()
                    }
                }
            }

            Method (_PS0, 0, NotSerialized)  // _PS0: Power State 0
            {
                If (ECRD)
                {
                    Store (One, ECOK)
                }
            }

            Method (_PS3, 0, NotSerialized)  // _PS3: Power State 3
            {
                Store (Zero, ECOK)
            }

            Method (_Q3F, 0, NotSerialized)  // _Qxx: EC Query
            {
                If (ECOK)
                {
                    SELE ()
                }

                If (LEqual (S3FG, 0x03))
                {
                    Store (Zero, S3FG)
                    If (LEqual (^^^XHC.WAKF, One))
                    {
                        Store (Zero, ^^^XHC.WAKF)
                        ADBG ("URST")
                        ^^^XHC.URST (Zero)
                        ^^^XHC.URST (One)
                        ^^^XHC.URST (0x02)
                    }
                }
            }

            Method (_QA6, 0, NotSerialized)  // _Qxx: EC Query
            {
                If (LGreater (CCPS, Zero))
                {
                    If (LLess (CCPS, PSSP))
                    {
                        Store (Zero, CCPS)
                    }
                    Else
                    {
                        Subtract (CCPS, PSSP, CCPS)
                    }

                    Store (CCPS, \_PR.CPPC)
                    PNOT ()
                }
            }

            Method (_QA7, 0, NotSerialized)  // _Qxx: EC Query
            {
                If (LLess (CCPS, CMPS))
                {
                    Add (CCPS, PSSP, CCPS)
                    If (LGreater (CCPS, CMPS))
                    {
                        Store (CMPS, CCPS)
                    }

                    Store (CCPS, \_PR.CPPC)
                    PNOT ()
                }
            }

            Method (_QA9, 0, NotSerialized)  // _Qxx: EC Query
            {
                Sleep (0x14)
                Store (Zero, Local1)
                Store (ENGD, Local1)
                Notify (^^^RP01.PXSX, Local1)
                Sleep (0x32)
                Store (Local1, BRGD)
            }

            Name (WMEN, Zero)
            Method (_Q01, 0, NotSerialized)  // _Qxx: EC Query
            {
                Notify (^^^GFX0.DD1F, 0x87)
                Store (0x0281, WMEN)
                Notify (WMI1, 0xA0)
            }

            Method (_Q02, 0, NotSerialized)  // _Qxx: EC Query
            {
                Notify (^^^GFX0.DD1F, 0x86)
                Store (0x0282, WMEN)
                Notify (WMI1, 0xA0)
            }

            Method (_Q03, 0, NotSerialized)  // _Qxx: EC Query
            {
            }

            Method (_Q04, 0, NotSerialized)  // _Qxx: EC Query
            {
            }

            Method (_Q05, 0, NotSerialized)  // _Qxx: EC Query
            {
            }

            Method (_Q06, 0, NotSerialized)  // _Qxx: EC Query
            {
            }

            Method (_Q07, 0, NotSerialized)  // _Qxx: EC Query
            {
                Store (0x0287, WMEN)
                Notify (WMI1, 0xA0)
            }

            Method (_Q08, 0, NotSerialized)  // _Qxx: EC Query
            {
            }

            Method (_Q09, 0, NotSerialized)  // _Qxx: EC Query
            {
                Store (0x0289, WMEN)
                Notify (WMI1, 0xA0)
            }

            Method (_Q0A, 0, NotSerialized)  // _Qxx: EC Query
            {
                Store (0x028A, WMEN)
                Notify (WMI1, 0xA0)
            }

            Method (_Q0B, 0, NotSerialized)  // _Qxx: EC Query
            {
            }

            Method (_Q0C, 0, NotSerialized)  // _Qxx: EC Query
            {
            }

            Name (BATO, 0xC0)
            Name (BATN, Zero)
            Method (SELE, 0, Serialized)
            {
                Store (BATD, BATN)
                Store (PWRS, Local0)
                Store (ACDC, PWRS)
                If (And (BATN, One))
                {
                    Store (0x1F, ^^^^BAT1.BATP)
                }
                Else
                {
                    Store (0x0F, ^^^^BAT1.BATP)
                }

                If (LNotEqual (And (BATN, 0x0FFF), And (BATO, 0x0FFF)))
                {
                    Notify (BAT1, 0x81)
                    If (LAnd (LEqual (And (BATO, One), One), LEqual (And (BATN, One), Zero)))
                    {
                        Sleep (0x14)
                    }
                }

                If (LNotEqual (PWRS, Local0))
                {
                    PNOT ()
                }

                Store (BATN, BATO)
            }

            Method (_Q19, 0, NotSerialized)  // _Qxx: EC Query
            {
                If (LEqual (GGIV (0x02020016), One))
                {
                    If (LEqual (TPLT, Zero))
                    {
                        SGOV (0x02020009, Zero)
                    }
                }

                If (ECOK)
                {
                    UPDL ()
                }

                If (IGDS)
                {
                    If (LGreaterEqual (OSYS, 0x07D6))
                    {
                        ^^^GFX0.GLID (LIDS)
                    }
                }

                Notify (LID0, 0x80)
            }

            Method (_Q1A, 0, NotSerialized)  // _Qxx: EC Query
            {
                If (LEqual (GGIV (0x02020016), One))
                {
                    SGOV (0x02020009, One)
                }

                If (ECOK)
                {
                    UPDL ()
                }

                If (IGDS)
                {
                    If (LGreaterEqual (OSYS, 0x07D6))
                    {
                        ^^^GFX0.GLID (LIDS)
                    }
                }

                Notify (LID0, 0x80)
            }

            Method (_Q2C, 0, NotSerialized)  // _Qxx: EC Query
            {
                If (LEqual (GGIV (0x02020016), One))
                {
                    If (LEqual (TPLT, Zero))
                    {
                        SGOV (0x02020009, Zero)
                    }
                }
            }

            Method (_Q2D, 0, NotSerialized)  // _Qxx: EC Query
            {
                If (LEqual (GGIV (0x02020016), One))
                {
                    SGOV (0x02020009, One)
                }
            }

            Method (_Q79, 0, NotSerialized)  // _Qxx: EC Query
            {
            }

            Method (_QDC, 0, NotSerialized)  // _Qxx: EC Query
            {
                O80P (0xDC, Zero)
                Store (One, TPUF)
                Store (0x0107, WMEN)
                Notify (WMI1, 0xA0)
            }

            Method (_QDD, 0, NotSerialized)  // _Qxx: EC Query
            {
                O80P (0xDD, Zero)
                Store (One, TPDF)
                Store (0x0107, WMEN)
                Notify (WMI1, 0xA0)
            }

            Method (_QDE, 0, NotSerialized)  // _Qxx: EC Query
            {
                O80P (0xDE, Zero)
                Store (One, CGUF)
                Store (0x0108, WMEN)
                Notify (WMI1, 0xA0)
            }

            Method (_QDF, 0, NotSerialized)  // _Qxx: EC Query
            {
                O80P (0xDF, Zero)
                Store (One, CGDF)
                Store (0x0108, WMEN)
                Notify (WMI1, 0xA0)
            }

            Method (_QE0, 0, NotSerialized)  // _Qxx: EC Query
            {
                O80P (0xE0, Zero)
                Store (One, CPUF)
                Store (0x0100, WMEN)
                Notify (WMI1, 0xA0)
            }

            Method (_QE1, 0, NotSerialized)  // _Qxx: EC Query
            {
                O80P (0xE1, Zero)
                Store (One, CPDF)
                Store (0x0100, WMEN)
                Notify (WMI1, 0xA0)
            }

            Method (_QE2, 0, NotSerialized)  // _Qxx: EC Query
            {
                O80P (0xE2, Zero)
                Store (One, BAUF)
                Store (0x010E, WMEN)
                Notify (WMI1, 0xA0)
            }

            Method (_QE3, 0, NotSerialized)  // _Qxx: EC Query
            {
                O80P (0xE3, Zero)
                Store (One, BADF)
                Store (0x010E, WMEN)
                Notify (WMI1, 0xA0)
            }

            Method (_QE4, 0, NotSerialized)  // _Qxx: EC Query
            {
                O80P (0xE4, Zero)
                Store (One, SYUF)
                Store (0x0105, WMEN)
                Notify (WMI1, 0xA0)
            }

            Method (_QE5, 0, NotSerialized)  // _Qxx: EC Query
            {
                O80P (0xE5, Zero)
                Store (One, SYDF)
                Store (0x0105, WMEN)
                Notify (WMI1, 0xA0)
            }

            Method (_QE6, 0, NotSerialized)  // _Qxx: EC Query
            {
                O80P (0xE6, Zero)
                Store (One, DRUF)
                Store (0x010B, WMEN)
                Notify (WMI1, 0xA0)
            }

            Method (_QE7, 0, NotSerialized)  // _Qxx: EC Query
            {
                O80P (0xE7, Zero)
                Store (One, DRDF)
                Store (0x010B, WMEN)
                Notify (WMI1, 0xA0)
            }

            Method (_QE8, 0, NotSerialized)  // _Qxx: EC Query
            {
                O80P (0xE8, Zero)
                Store (One, PHUF)
                Store (0x0106, WMEN)
                Notify (WMI1, 0xA0)
            }

            Method (_QE9, 0, NotSerialized)  // _Qxx: EC Query
            {
                O80P (0xE9, Zero)
                Store (One, PHDF)
                Store (0x0106, WMEN)
                Notify (WMI1, 0xA0)
            }

            Method (_QEA, 0, NotSerialized)  // _Qxx: EC Query
            {
                O80P (0xEA, Zero)
                Store (One, GPUF)
                Store (0x0101, WMEN)
                Notify (WMI1, 0xA0)
            }

            Method (_QEB, 0, NotSerialized)  // _Qxx: EC Query
            {
                O80P (0xEB, Zero)
                Store (One, GPDF)
                Store (0x0101, WMEN)
                Notify (WMI1, 0xA0)
            }

            Method (_QEC, 0, NotSerialized)  // _Qxx: EC Query
            {
                O80P (0xEC, Zero)
                Store (0x02, ODV2)
                Notify (IETM, 0x88)
                Sleep (0x07D0)
                Notify (B0D4, 0x83)
            }

            Method (_QED, 0, NotSerialized)  // _Qxx: EC Query
            {
                O80P (0xED, Zero)
                Store (One, ODV2)
                Notify (IETM, 0x88)
                Sleep (0x07D0)
                Notify (B0D4, 0x83)
            }

            Method (_QF1, 0, NotSerialized)  // _Qxx: EC Query
            {
                Store (PXTF, Local0)
                While (Local0)
                {
                    Store (Zero, PXTF)
                    If (And (Local0, 0x08))
                    {
                        Notify (GEN3, 0x90)
                    }

                    If (And (Local0, 0x04))
                    {
                        Notify (GEN2, 0x90)
                    }

                    If (And (Local0, 0x02))
                    {
                        Notify (GEN1, 0x90)
                    }

                    Store (PXTF, Local0)
                }
            }

            Method (_Q34, 0, NotSerialized)  // _Qxx: EC Query
            {
                Notify (BAT1, 0x81)
            }

            Method (_Q3E, 0, NotSerialized)  // _Qxx: EC Query
            {
                If (LEqual (SKID, Zero))
                {
                    Store (One, ODV1)
                }
                Else
                {
                    Store (0x02, ODV1)
                }

                Store (One, ODV2)
                Notify (IETM, 0x88)
                Sleep (0x10)
                Notify (B0D4, 0x83)
            }

            Method (_QF2, 0, NotSerialized)  // _Qxx: EC Query
            {
                Store (One, ^^^^GEN1.RCEO)
                Notify (GEN1, 0x80)
            }

            Method (_QF4, 0, NotSerialized)  // _Qxx: EC Query
            {
                Store (One, ^^^^GEN2.RCEO)
                Notify (GEN2, 0x80)
            }

            Method (_QF6, 0, NotSerialized)  // _Qxx: EC Query
            {
                Store (One, ^^^^GEN3.RCEO)
                Notify (GEN3, 0x80)
            }
        }