TCPUID
by MARTINEAU Emeric
Version 1.0
Jan - 30, 2008
this component is public domain software

DESCRIPTION
-----------
Component to know type of processor and information.


NEW PROPERTIES:
---------------

* VendorString 
    Vendor string of processor
     "GenuineIntel" : Intel
     "AuthenticAMD" : AMD
     "AMD ISBETTER" : Devines
     "CyrixInstead" : Cyrix
     "NexGenDriven" : NexGen
     "CentaurHauls" : IDT/Centaur now via
     "RiseRiseRise" : Rise
     "GenuineTMx86" : Transmeta
     "UMC UMC UMC " : United Microelectronics Corp.
     "SiS SiS SiS " : SiS Processor

* SteppingNumber
    Stepping number of processor (1)

* ModelNumber
    Model number of processor (1)

* FamilyNumber
    Family number of processor (1)

* ProcessorType
    Type of processor (1)

* ExtendedModelNumber
    Extended model number of processor (1)

* ExtendedFamilyNumber
    Extended family number of processor (1)

* ExtendedSteppingAMD
    Extended stepping of processor (2)

* ExtendedModelAMD 
    Extended model of processor (2)

* ExtendedFamilyAMD
    Extended Family of processor (2)

* MMX
    True if MMX instruction supported (1)

* SSE
    True if SSE instruction supported (1)

* SSE2
    True if SSE2 instruction supported (1)

* SSE3
    True if SSE3 instruction supported (1)

* SSSE3
    True if SSSE3 instruction supported (1)

* SSE41
    True if SSE 4.1 instruction supported (1)

* SSE42
    True if SSE 4.2 instruction supported (1)

* HTT 
    True if Hyper Threading technologie is supported (1)

* ExecuteDisableBitCapability
    True if Execute Disable Capability (1)

* PROC64BIT
    True if processor is 64 bits (1)

* AMDMMXExtensions
    True if AMD MMX Extensions supported (2)

* AMD3DNow2 
    True if 3DNow!2 instructions supported (2)

* AMD3DNow
    True if 3DNow! instructions supported (2)

* NumberOfProcessor (1)

* NumberOfCore
    Number of core by processor (1)

* SerialNumber
    Serial number of processor (3)

* LabelName
    Label name of processor (e.g. Intel(R) Core(TM) 2 Duo E6300 @ 1.86Ghz  

* CpuidSupported
    True if CPUID instruction are supported

* CpuType
    Type of processor
     0 -> inconnu,
     1 -> 8086/8088,
     2 -> 80286,
     3 -> 80386,
     4 -> 80486,
     5 -> Type Pentium

(1) : only if cpuid instruction supported. Check CpuidSupported to know that 
(2) : only on AMD CPU. Check if VendorString = "AuthenticAMD"
(3) : Only on Pentium III