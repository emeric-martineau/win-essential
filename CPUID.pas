{
 Copyright MARTINEAU Emeric 2007 - Public domain
 
 29/01/2007 - Initial release

 Documentation
   Intel
   - http://www.intel.com/software/products/documentation/vlin/mergedprojects/analyzer_ec/mergedprojects/reference_olh/mergedprojects/instructions/instruct32_hh/vc46.htm
   - http://developer.intel.com/products/processor/manuals/index.htm -> 2A manual
   - http://www.flounder.com/cpuid_explorer2.htm

   AMD
   - http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/25481.pdf

 VendorString
 ------------
   "GenuineIntel"; // Intel
   "AuthenticAMD"; // AMD
   "AMD ISBETTER"; // Devines
   "CyrixInstead"; // Cyrix
   "NexGenDriven"; // NexGen
   "CentaurHauls"; // IDT/Centaur now via
   "RiseRiseRise"; // Rise
   "GenuineTMx86"; // Transmeta
   "UMC UMC UMC "; // United Microelectronics Corp.
   "SiS SiS SiS "; // SiS Processor

 CPUType
 -------
     0 -> inconnu,
     1 -> 8086/8088,
     2 -> 80286,
     3 -> 80386,
     4 -> 80486,
     5 -> Type Pentium
}
unit CPUID;

interface

uses Classes, SysUtils, Math ;

{$I DelphiVersion.inc}

type
  TCPUID = class(TComponent)
  private
    { Déclarations privées }
  protected
    { Déclarations protégées }
    FVendorString : String ;
    FSteppingNumber : SmallInt ;
    FModelNumber : SmallInt ;
    FFamilyNumber : SmallInt ;
    FProcessorType : SmallInt ;
    FExtendedModelNumber : SmallInt ;
    FExtendedFamilyNumber : SmallInt ;
    FExtendedSteppingAMD : SmallInt ;
    FExtendedModelAMD : SmallInt ;
    FExtendedFamilyAMD : SmallInt ;
    FMMX : boolean ;
    FSSE : boolean ;
    FSSE2 : boolean ;
    FSSE3 : boolean ;
    FSSSE3 : boolean ;
    FSSE41 : boolean ;
    FSSE42 : boolean ;
    FHTT : boolean ;
    FPROC64BIT : Boolean ;
    FExecuteDisableBitCapability : Boolean ;
    FAMDMMXExtensions : boolean ;
    FAMD3DNow2 : boolean ;
    FAMD3DNow : boolean ;
    FNumberOfProcessor : Integer ;
    FNumberOfCore : Integer ;
    FSerialNumber : String ;
    FLabelName : String ;
    FCpuidSupported : Boolean ;
    FCpuType : SmallInt ;
	procedure SetString(text : string) ;
    procedure SetBoolean(value : boolean) ;
    procedure SetInteger(value : Integer) ;
    procedure SetSmallInt(value : SmallInt) ;
  public
    { Déclarations publiques }
    constructor Create(Owner:TComponent); override;
  published
    { Déclarations publiées }
    property VendorString : String read FVendorString write SetString  ;
    property SteppingNumber : SmallInt read FSteppingNumber write SetSmallInt default -1  ;
    property ModelNumber : SmallInt read FModelNumber write SetSmallInt default -1  ;
    property FamilyNumber : SmallInt read FFamilyNumber write SetSmallInt default -1  ;
    property ProcessorType : SmallInt read FProcessorType write SetSmallInt default -1  ;
    property ExtendedModelNumber : SmallInt read FExtendedModelNumber write SetSmallInt default -1   ;
    property ExtendedFamilyNumber : SmallInt read FExtendedFamilyNumber write SetSmallInt default -1  ;
    property ExtendedSteppingAMD : SmallInt read FExtendedSteppingAMD write SetSmallInt default -1  ;
    property ExtendedModelAMD : SmallInt read FExtendedModelAMD write SetSmallInt default -1  ;
    property ExtendedFamilyAMD : SmallInt read FExtendedFamilyAMD write SetSmallInt default -1  ;
    property MMX : boolean read FMMX write SetBoolean default false  ;
    property SSE : boolean read FSSE write SetBoolean default false  ;
    property SSE2 : boolean read FSSE2 write SetBoolean default false  ;
    property SSE3 : boolean read FSSE3 write SetBoolean default false ;
    property SSSE3 : boolean read FSSSE3 write SetBoolean default false ;
    property SSE41 : boolean read FSSE41 write SetBoolean default false ;
    property SSE42 : boolean read FSSE42 write SetBoolean default false ;
    property HTT : boolean read FHTT write SetBoolean default false ;
    property ExecuteDisableBitCapability : Boolean read FExecuteDisableBitCapability write SetBoolean default false ;
    property PROC64BIT : Boolean read FPROC64BIT write SetBoolean default false ;
    property AMDMMXExtensions : boolean read FAMDMMXExtensions write SetBoolean default false  ;
    property AMD3DNow2 : boolean read FAMD3DNow2 write SetBoolean default false  ;
    property AMD3DNow : boolean read FAMD3DNow write SetBoolean default false  ;
    property NumberOfProcessor : Integer read FNumberOfProcessor write SetInteger default -1 ;
    property NumberOfCore : Integer read FNumberOfCore write SetInteger default -1 ;
    property SerialNumber : String read FSerialNumber write SetString ;
    property LabelName : string read FLabelName write SetString ;
    property CpuidSupported : Boolean read FCpuidSupported write SetBoolean ;
    property CpuType : SmallInt read FCpuType write SetSmallInt ;
  end;

procedure Register;

implementation

{*******************************************************************************
 * Constructeur
 ******************************************************************************}
constructor TCPUID.Create(Owner:TComponent);
var RegistreEax : Longword ;
    RegistreEbx : Longword ;
    RegistreEdx : Longword ;
    RegistreEcx : Longword ;
    tmp : Char ;
    Cpu_Type : SmallInt ;
    LogicalProcessorCount : SmallInt ;
    CmpLegacy : boolean ;
    NC : Integer ;
    ApicIdCoreIdSize : SmallInt ;
begin
    inherited ;

    FCpuidSupported := False ;

    asm
        // Sauvegarde les flag
        pushf

        // Récupère les flags dans ax
        pop ax

        // Met les flags dans cx
        mov cx, ax

        // Efface les bits 12-15
        and ax, 0fffh

        // Met sur la pile les flags modifié
        push ax

        // Récupère les flags
        popf

        // remet sur la pile les flags
        pushf

        // Remet les flags dans ax
        pop ax

        // Si les bits 12-15 sont à 1 on a un 8086/8088 comme processeur
        and ax, 0f000h
        cmp ax, 0f000h

        // C'est un 8086/8088
        mov Cpu_Type, 1

        // Vérifie que c'est un 80286
        jne @@check_80286

        // Vérifie qu'il s'agit bien d'un 8086/8088
        push sp
        // Si les valeur sont différente il s'agit bien d'un 8086
        pop dx
        cmp dx, sp

        jne @@end_cpu_type

        // Processeur inconnu
        mov Cpu_Type, 0
        jmp @@end_cpu_type

        // Vérifie qu'il s'agisse bien d'un 80286
        // Si les bits 12-15 des flags reste à 0 alors c'est bon
        @@check_80286:

        // Sauvegarde le status de la machine
        smsw ax
        // Isole le bit PE
        and ax, 1

        // Sauve garde le bit PE pour indiquer le mode V86
        //mov _v86_flag, al

        // Active les bits 12-15
        or cx, 0f000h

        // Remet les flags sur la pile
        push cx

        // Récupère les flags
        popf

        // Remet les flags sur la pile
        pushf

        // Récupère les flags et regarde sur les bits 12-15 sont à 0
        pop ax
        and ax, 0f000h

        // C'est un 80286
        mov Cpu_Type, 2

        // C'est les flags 12-15 sont à 0 c'est un 80286 sinon c'est un 80386 et plus
        jz @@end_cpu_type

        @@check_80386:
        // Le 80386 à le bit AC (bit 18) dans EFlags. C'est bit ne peut est mit
        // à 1 sur un 80386.
        // Sauvegarde les flags
        pushfd

        // Récupère les flags
        pop eax

        // Sauvegarde les flags dans ecx
        mov ecx, eax

        // Met à 1 le bit AC
        xor eax, 40000h

        // Met les nouveau flag sur la pile
        push eax

        // Récupère les flags
        popfd

        // Remet les flags sur la pile et on va regader le bit AC
        pushfd
        pop eax

        // Indique qu'il s'agit d'un 80386
        mov Cpu_Type, 3

        // Est-ce que le flag AC à pu être modifié ?
        xor eax, ecx

        // Non, alros c'est bien un 80386
        jz @@end_cpu_type

        push ecx

        // Restore les flags d'origine
        popfd

        @@check_80486:
        // Puisque le flags AC à pu être modifié, il s'agit d'au moins un 80486
        mov Cpu_Type, 4

        // On remet les flags qu'il y a toujours dans ecx, dans eax
        mov eax, ecx

        // Met à 1 le flag ID si à 0 et inversement
        xor eax, 200000h

        // Sauvegarde les nouveaus flags
        push eax

        // Récupère le nouveau flags
        popfd

        // Met les flags dans eax
        pushfd
        pop eax

        // Est-ce que le bit à pu être modifié ?
        xor eax, ecx

        // Non ? alors il s'agit d'un 80486
        je @@end_cpu_type

        mov Cpu_Type, 5

        @@end_cpu_type :
    end ;

    FCpuType := Cpu_Type ;

    if Cpu_Type <> 5
    then
        // Il ne s'agit pas d'un Pentium donc on ne supporte pas l'instruction CPUID
        exit ;

    FCpuidSupported := True ;

    {-------------------------------- VENDOR ----------------------------------}
    asm
        mov eax, 0
        {$IFNDEF Delphi5}
        // Hardcod for CPUID
        db $0F
        db $A2
        {$ELSE}
        cpuid
        {$ENDIF}
        mov RegistreEbx, ebx
        mov RegistreEdx, edx
        mov RegistreEcx, ecx
    end ;

    { EBX }
    tmp := Chr((RegistreEbx and $FF));

    FVendorString := tmp ;

    tmp := Chr((RegistreEbx and $FF00) shr 8) ;

    FVendorString := FVendorString + tmp ;

    tmp := Chr((RegistreEbx and $FF0000) shr 16) ;

    FVendorString := FVendorString + tmp ;

    tmp := Chr((RegistreEbx and $FF000000) shr 24) ;

    FVendorString := FVendorString + tmp ;

    { EDX }
    tmp := Chr((RegistreEdx and $FF));

    FVendorString := FVendorString + tmp ;

    tmp := Chr((RegistreEdx and $FF00) shr 8) ;

    FVendorString := FVendorString + tmp ;

    tmp := Chr((RegistreEdx and $FF0000) shr 16) ;

    FVendorString := FVendorString + tmp ;

    tmp := Chr((RegistreEdx and $FF000000) shr 24) ;

    FVendorString := FVendorString + tmp ;

    { ECX }
    tmp := Chr((RegistreEcx and $FF));

    FVendorString := FVendorString + tmp ;

    tmp := Chr((RegistreEcx and $FF00) shr 8) ;

    FVendorString := FVendorString + tmp ;

    tmp := Chr((RegistreEcx and $FF0000) shr 16) ;

    FVendorString := FVendorString + tmp ;

    tmp := Chr((RegistreEcx and $FF000000) shr 24) ;

    FVendorString := FVendorString + tmp ;

    {-------------------------- PROCESSOR FAMILLY -----------------------------}
    asm
        mov eax, 1
        {$IFNDEF Delphi5}
        // Hardcod for CPUID
        db $0F
        db $A2
        {$ELSE}
        cpuid
        {$ENDIF}
        mov RegistreEax, eax
        mov RegistreEdx, edx
        mov RegistreEcx, ecx
    end ;

    FSteppingNumber := RegistreEax and $7 ;
    FModelNumber := (RegistreEax shr 4) and $F ;
    FFamilyNumber := (RegistreEax shr 8) and $F ;
    FProcessorType := (RegistreEax shr 13) and 3 ;
    FExtendedModelNumber := (RegistreEax shr 16) and $F ;
    FExtendedFamilyNumber := (RegistreEax shr 20) and $F ;

    {------------------------- INSTRUCTION SUPPORT ----------------------------}
    FMMX := (RegistreEdx and (1 shl 23)) <> 0 ;
    FSSE := (RegistreEdx and (1 shl 25)) <> 0 ;
    FSSE2 := (RegistreEdx and (1 shl 26)) <> 0 ;
    FHTT := (RegistreEdx and (1 shl 28)) <> 0 ;
    FSSE3 := (RegistreEcx and 1) <> 0 ;
    FSSE41 := (RegistreEcx and (1 shl 19)) <> 0 ;
    FSSE42 := (RegistreEcx and (1 shl 20)) <> 0 ;
    FSSSE3 := (RegistreEcx and (1 shl 9)) <> 0 ;

    {---------------------------- SERIAL NUMBER -------------------------------}
    if FVendorString = 'GenuineIntel'
    then begin
        if ((RegistreEdx shr 18) and 1) <> 0
        then begin
            asm
                mov eax, 1
				
           	{$IFNDEF Delphi5}
		// Hardcod for CPUID
		db $0F
		db $A2
		{$ELSE}
                cpuid
                {$ENDIF}
                mov RegistreEax, eax

                mov eax, 3
           	{$IFNDEF Delphi5}
		// Hardcod for CPUID
		db $0F
		db $A2
		{$ELSE}
                cpuid
                {$ENDIF}
                mov RegistreEdx, edx
                mov RegistreEcx, ecx
            end ;

            FSerialNumber := Format('%X%X%X', [RegistreEcx, RegistreEdx, RegistreEax]) ;
        end ;
    end
    else begin
        FSerialNumber := '' ;
    end ;

    {---------------------------- EXTEND CONFIG -------------------------------}
    asm
        mov eax, $80000001
        {$IFNDEF Delphi5}
        // Hardcod for CPUID
        db $0F
        db $A2
        {$ELSE}
        cpuid
        {$ENDIF}
        mov RegistreEdx, edx
        mov RegistreEax, eax
    end ;

    if RegistreEax <> $80000001
    then begin
        if FVendorString = 'AuthenticAMD'
        then begin
            FAMDMMXExtensions := (RegistreEdx and (1 shl 22)) <> 0 ;
            FAMD3DNow2 := (RegistreEdx and (1 shl 30)) <> 0 ;
            FAMD3DNow := (RegistreEdx and (1 shl 31)) <> 0 ;

            FExtendedSteppingAMD := RegistreEax and $7 ;
            FExtendedModelAMD := (RegistreEax shr 4) and $F ;
            FExtendedFamilyAMD := (RegistreEax shr 8) and $F ;

        end
        else begin
            FAMDMMXExtensions := False ;
            FAMD3DNow2 := False ;
            FAMD3DNow := False ;

            FExtendedSteppingAMD := 0 ;
            FExtendedModelAMD := 0 ;
            FExtendedFamilyAMD := 0 ;
        end ;

        FExecuteDisableBitCapability := (RegistreEdx and (1 shl 20)) <> 0 ;
        FPROC64BIT := (RegistreEdx and (1 shl 29)) <> 0 ;
    end
    else begin
        FAMDMMXExtensions := False ;
        FAMD3DNow2 := False ;
        FAMD3DNow := False ;

        FExtendedSteppingAMD := 0 ;
        FExtendedModelAMD := 0 ;
        FExtendedFamilyAMD := 0 ;

        FExecuteDisableBitCapability := false ;
        FPROC64BIT := false ;
    end ;

    {------------------------ NB PROCESSOR AND CORE ---------------------------}
    if FVendorString <> 'AuthenticAMD'
    then begin
        { NB CORE }
        asm
            xor eax, eax
            {$IFNDEF Delphi5}
			// Hardcod for CPUID
			db $0F
			db $A2
			{$ELSE}
			cpuid
	        {$ENDIF}
            cmp eax, 4
            jl @@singleCore
            mov eax, 4
            mov ecx, 0
            {$IFNDEF Delphi5}
			// Hardcod for CPUID
			db $0F
			db $A2
			{$ELSE}
			cpuid
	        {$ENDIF}
            mov RegistreEax, eax
            jmp @@multiCore

            @@singleCore :
            mov RegistreEax, 0

            @@multiCore:
        end ;

        FNumberOfCore := ((RegistreEax and $FC000000) shr 26) + 1 ;

        { NB PROC }
        asm
            mov eax, 1
            {$IFNDEF Delphi5}
            // Hardcod for CPUID
            db $0F
	        db $A2
		    {$ELSE}
		    cpuid
	        {$ENDIF}
            mov RegistreEbx, ebx
        end ;

        FNumberOfProcessor := (RegistreEbx and $FF0000) shr 16 ;
        FNumberOfProcessor := FNumberOfProcessor div FNumberOfCore ;
    end
    else begin
        asm
            mov eax, 1
            {$IFNDEF Delphi5}
			// Hardcod for CPUID
			db $0F
			db $A2
			{$ELSE}
			cpuid
	        {$ENDIF}
            mov RegistreEbx, ebx
            mov RegistreEcx, ecx
        end ;

        LogicalProcessorCount := (RegistreEbx shr 16) and $FF ;

        (*
        asm
            mov eax, $80000001
            {$IFNDEF Delphi5}
			// Hardcod for CPUID
			db $0F
			db $A2
			{$ELSE}
			cpuid
	        {$ENDIF}
            mov RegistreEcx, ecx
            mov RegistreEax, eax
        end ;

        if RegistreEax <> $80000001
        then
            CmpLegacy := (RegistreEcx and 2) <> 0
        else
            CmpLegacy := false ;
        *)
        
        asm
            mov eax, $80000008
            {$IFNDEF Delphi5}
			// Hardcod for CPUID
			db $0F
			db $A2
			{$ELSE}
			cpuid
	        {$ENDIF}
            mov RegistreEcx, ecx
            mov RegistreEax, eax
        end ;

        if RegistreEax <> $80000008
        then begin
            NC := (RegistreEcx and $FF) ;
            ApicIdCoreIdSize := (RegistreEcx shr 12) and $F ;
        end
        else begin
            NC := 0 ;
            ApicIdCoreIdSize := 0 ;
        end ;

        if not FHTT
        then begin
            FNumberOfProcessor := 1 ;
            FNumberOfCore := 1 ;
        end
        else begin
            if ApicIdCoreIdSize = 0
            then
                NC := NC + 1
            else
                NC := trunc(Power(2, ApicIdCoreIdSize)) ;

            FNumberOfProcessor := LogicalProcessorCount div NC ;
            FNumberOfCore := NC ;
        end ;
    end ;

    {------------------------- Label du processeur ----------------------------}
    FLabelName := '' ;

    asm
        mov eax, $80000000
        {$IFNDEF Delphi5}
        // Hardcod for CPUID
        db $0F
        db $A2
        {$ELSE}
        cpuid
	{$ENDIF}        
        mov RegistreEax, eax
    end ;

    if (RegistreEax and $80000000) <> 0
    then begin
        asm
            mov eax, $80000002
            {$IFNDEF Delphi5}
            // Hardcod for CPUID
            db $0F
            db $A2
            {$ELSE}
            cpuid
            {$ENDIF}            
            mov RegistreEax, eax
            mov RegistreEbx, ebx
            mov RegistreEcx, ecx
            mov RegistreEdx, edx
        end ;

        { EAX }
        tmp := Chr((RegistreEax and $FF));

        FLabelName := FLabelName + tmp ;

        tmp := Chr((RegistreEax and $FF00) shr 8) ;

        FLabelName := FLabelName + tmp ;

        tmp := Chr((RegistreEax and $FF0000) shr 16) ;

        FLabelName := FLabelName + tmp ;

        tmp := Chr((RegistreEax and $FF000000) shr 24) ;

        FLabelName := FLabelName + tmp ;

        { EBX }
        tmp := Chr((RegistreEbx and $FF));

        FLabelName := FLabelName + tmp ;

        tmp := Chr((RegistreEbx and $FF00) shr 8) ;

        FLabelName := FLabelName + tmp ;

        tmp := Chr((RegistreEbx and $FF0000) shr 16) ;

        FLabelName := FLabelName + tmp ;

        tmp := Chr((RegistreEbx and $FF000000) shr 24) ;

        FLabelName := FLabelName + tmp ;

        { ECX }
        tmp := Chr((RegistreEcx and $FF));

        FLabelName := FLabelName + tmp ;

        tmp := Chr((RegistreEcx and $FF00) shr 8) ;

        FLabelName := FLabelName + tmp ;

        tmp := Chr((RegistreEcx and $FF0000) shr 16) ;

        FLabelName := FLabelName + tmp ;

        tmp := Chr((RegistreEcx and $FF000000) shr 24) ;

        FLabelName := FLabelName + tmp ;

        { EDX }
        tmp := Chr((RegistreEdx and $FF));

        FLabelName := FLabelName + tmp ;

        tmp := Chr((RegistreEdx and $FF00) shr 8) ;

        FLabelName := FLabelName + tmp ;

        tmp := Chr((RegistreEdx and $FF0000) shr 16) ;

        FLabelName := FLabelName + tmp ;

        tmp := Chr((RegistreEdx and $FF000000) shr 24) ;

        FLabelName := FLabelName + tmp ;

        asm
            mov eax, $80000003
            {$IFNDEF Delphi5}
            // Hardcod for CPUID
            db $0F
            db $A2
            {$ELSE}
            cpuid
            {$ENDIF}            
            mov RegistreEax, eax
            mov RegistreEbx, ebx
            mov RegistreEcx, ecx
            mov RegistreEdx, edx
        end ;

        { EAX }
        tmp := Chr((RegistreEax and $FF));

        FLabelName := FLabelName + tmp ;
                
        tmp := Chr((RegistreEax and $FF00) shr 8) ;

        FLabelName := FLabelName + tmp ;

        tmp := Chr((RegistreEax and $FF0000) shr 16) ;

        FLabelName := FLabelName + tmp ;

        tmp := Chr((RegistreEax and $FF000000) shr 24) ;

        FLabelName := FLabelName + tmp ;

        { EBX }
        tmp := Chr((RegistreEbx and $FF));

        FLabelName := FLabelName + tmp ;

        tmp := Chr((RegistreEbx and $FF00) shr 8) ;

        FLabelName := FLabelName + tmp ;

        tmp := Chr((RegistreEbx and $FF0000) shr 16) ;

        FLabelName := FLabelName + tmp ;

        tmp := Chr((RegistreEbx and $FF000000) shr 24) ;

        FLabelName := FLabelName + tmp ;

        { ECX }
        tmp := Chr((RegistreEcx and $FF));

        FLabelName := FLabelName + tmp ;

        tmp := Chr((RegistreEcx and $FF00) shr 8) ;

        FLabelName := FLabelName + tmp ;

        tmp := Chr((RegistreEcx and $FF0000) shr 16) ;

        FLabelName := FLabelName + tmp ;

        tmp := Chr((RegistreEcx and $FF000000) shr 24) ;

        FLabelName := FLabelName + tmp ;

        { EDX }
        tmp := Chr((RegistreEdx and $FF));

        FLabelName := FLabelName + tmp ;

        tmp := Chr((RegistreEdx and $FF00) shr 8) ;

        FLabelName := FLabelName + tmp ;

        tmp := Chr((RegistreEdx and $FF0000) shr 16) ;

        FLabelName := FLabelName + tmp ;

        tmp := Chr((RegistreEdx and $FF000000) shr 24) ;

        FLabelName := FLabelName + tmp ;

        asm
            mov eax, $80000004
            {$IFNDEF Delphi5}
            // Hardcod for CPUID
            db $0F
            db $A2
            {$ELSE}
            cpuid
            {$ENDIF}            
            mov RegistreEax, eax
            mov RegistreEbx, ebx
            mov RegistreEcx, ecx
            mov RegistreEdx, edx
        end ;

        { EAX }
        tmp := Chr((RegistreEax and $FF));

        FLabelName := FLabelName + tmp ;
                
        tmp := Chr((RegistreEax and $FF00) shr 8) ;

        FLabelName := FLabelName + tmp ;

        tmp := Chr((RegistreEax and $FF0000) shr 16) ;

        FLabelName := FLabelName + tmp ;

        tmp := Chr((RegistreEax and $FF000000) shr 24) ;

        FLabelName := FLabelName + tmp ;

        { EBX }
        tmp := Chr((RegistreEbx and $FF));

        FLabelName := FLabelName + tmp ;

        tmp := Chr((RegistreEbx and $FF00) shr 8) ;

        FLabelName := FLabelName + tmp ;

        tmp := Chr((RegistreEbx and $FF0000) shr 16) ;

        FLabelName := FLabelName + tmp ;

        tmp := Chr((RegistreEbx and $FF000000) shr 24) ;

        FLabelName := FLabelName + tmp ;

        { ECX }
        tmp := Chr((RegistreEcx and $FF));

        FLabelName := FLabelName + tmp ;

        tmp := Chr((RegistreEcx and $FF00) shr 8) ;

        FLabelName := FLabelName + tmp ;

        tmp := Chr((RegistreEcx and $FF0000) shr 16) ;

        FLabelName := FLabelName + tmp ;

        tmp := Chr((RegistreEcx and $FF000000) shr 24) ;

        FLabelName := FLabelName + tmp ;

        { EDX }
        tmp := Chr((RegistreEdx and $FF));

        FLabelName := FLabelName + tmp ;

        tmp := Chr((RegistreEdx and $FF00) shr 8) ;

        FLabelName := FLabelName + tmp ;

        tmp := Chr((RegistreEdx and $FF0000) shr 16) ;

        FLabelName := FLabelName + tmp ;

        tmp := Chr((RegistreEdx and $FF000000) shr 24) ;

        FLabelName := FLabelName + tmp ;
    end
    else begin
        FLabelName := '' ;
    end ;
end ;

procedure TCPUID.SetString(text : string) ;
begin
end ;

procedure TCPUID.SetBoolean(value : boolean) ;
begin
end ;

procedure TCPUID.SetInteger(value : Integer) ;
begin
end ;

procedure TCPUID.SetSmallInt(value : SmallInt) ;
begin
end ;


procedure Register;
begin
  RegisterComponents('WinEssential', [TCPUID]);
end;

end.
