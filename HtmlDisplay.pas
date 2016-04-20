unit HtmlDisplay;

interface

{$IFDEF USER_DEFINES_INC}{$I user_defines.inc}{$ENDIF}

uses
  Windows,Classes;
const

  SetupApiModuleName = 'SetupApi.dll';
  User32ModuleName = 'user32.dll';


  GUID_CLASS_MONITOR: TGuid = (D1: $4D36E96E;
    D2: $E325;
    D3: $11CE;
    D4: ($BF, $C1, $08, $00, $2B, $E1, $03, $18)
    );
  DIGCF_PRESENT = $00000002;
  {$EXTERNALSYM DIGCF_PRESENT}
  // Values specifying the scope of a device property change
  DICS_FLAG_GLOBAL = $00000001;         // make change in all hardware profiles
  {$EXTERNALSYM DICS_FLAG_GLOBAL}
  DICS_FLAG_CONFIGSPECIFIC = $00000002; // make change in specified profile only
  {$EXTERNALSYM DICS_FLAG_CONFIGSPECIFIC}
  DICS_FLAG_CONFIGGENERAL = $00000004;  // 1 or more hardware profile-specific
  {$EXTERNALSYM DICS_FLAG_CONFIGGENERAL} // changes to follow.
  // KeyType values for SetupDiCreateDevRegKey, SetupDiOpenDevRegKey, and SetupDiDeleteDevRegKey.
  DIREG_DEV = $00000001;                // Open/Create/Delete device key
  {$EXTERNALSYM DIREG_DEV}
  DIREG_DRV = $00000002;                // Open/Create/Delete driver key
  {$EXTERNALSYM DIREG_DRV}
  DIREG_BOTH = $00000004;               // Delete both driver and Device key
  {$EXTERNALSYM DIREG_BOTH}

  {$EXTERNALSYM DISPLAY_DEVICE_ATTACHED_TO_DESKTOP}
  DISPLAY_DEVICE_ATTACHED_TO_DESKTOP = $00000001;
  {$EXTERNALSYM DISPLAY_DEVICE_MULTI_DRIVER}
  DISPLAY_DEVICE_MULTI_DRIVER = $00000002;
  {$EXTERNALSYM DISPLAY_DEVICE_PRIMARY_DEVICE}
  DISPLAY_DEVICE_PRIMARY_DEVICE = $00000004;
  {$EXTERNALSYM DISPLAY_DEVICE_MIRRORING_DRIVER}
  DISPLAY_DEVICE_MIRRORING_DRIVER = $00000008;
  {$EXTERNALSYM DISPLAY_DEVICE_VGA_COMPATIBLE}
  DISPLAY_DEVICE_VGA_COMPATIBLE = $00000010;

  EDD_GET_DEVICE_INTERFACE_NAME = $00000001;

  SPDRP_DEVICEDESC                  = $00000000; // DeviceDesc (R/W)
  {$EXTERNALSYM SPDRP_DEVICEDESC}
  SPDRP_HARDWAREID                  = $00000001; // HardwareID (R/W)
  {$EXTERNALSYM SPDRP_HARDWAREID}

  DISPLAY_DEVICE_ACTIVE = $00000001;
  DISPLAY_DEVICE_ATTACHED = $00000002;

type
   _DISPLAY_DEVICEEXTA = record
    cb: DWORD;
    DeviceName: array[0..31] of AnsiChar;
    DeviceString: array[0..127] of AnsiChar;
    StateFlags: DWORD;
    DeviceID: array[0..127] of AnsiChar;
    DeviceKey: array[0..127] of AnsiChar;
  end;
  _DISPLAY_DEVICEEXTW = record
    cb: DWORD;
    DeviceName: array[0..31] of WideChar;
    DeviceString: array[0..127] of WideChar;
    StateFlags: DWORD;
    DeviceID: array[0..127] of WideChar;
    DeviceKey: array[0..127] of WideChar;
  end;
  _DISPLAY_DEVICEEXT = _DISPLAY_DEVICEEXTA;

  TDisplayDeviceExtA = _DISPLAY_DEVICEEXTA;
  TDisplayDeviceExtW = _DISPLAY_DEVICEEXTW;

  PDisplayDeviceExtA = ^TDisplayDeviceExtA;
  PDisplayDeviceExtW = ^TDisplayDeviceExtW;
{$IFDEF UNICODE}
  TDisplayDeviceExt = TDisplayDeviceExtW;
  PDisplayDeviceExt = PDisplayDeviceExtW;
  PTSTR = PWideChar;
{$ELSE}
  TDisplayDeviceExt = TDisplayDeviceExtA;
  PDisplayDeviceExt = PDisplayDeviceExtA;
  PTSTR = PChar;
{$ENDIF}
  PSPDevInfoData = ^TSPDevInfoData;

  SP_DEVINFO_DATA = packed record
    cbSize: DWORD;
    ClassGuid: TGUID;
    DevInst: DWORD;                     // DEVINST handle
    Reserved: LongWord;
  end;
  {$EXTERNALSYM SP_DEVINFO_DATA}
  TSPDevInfoData = SP_DEVINFO_DATA;

  HDEVINFO = THANDLE;
  {$EXTERNALSYM HDEVINFO}

// на сладкое...  
  TEDIDHeader = record
    Padding: array[1..8] of Byte;
    VendorID: Word;  // bits 14 - 10 first letter (01h='A', 02h='B', etc.)
                     // bits 9 - 5 second letter
                     // bits 4 - 0 third letter
    ProductID: Word;
    SerialNo: DWord; // serial number or FFFFFFFFh
                     // for "MAG", subtract 7000000 to get actual serial number
                     // for "OQI", subtract 456150000
                     // for "PHL", subtract ???
                     // for "VSC", subtract 640000000
    ManufactureWeek: Byte;
    ManufactureYear: Byte; // manufacture year - 1990
    EDIDversion: Byte;
    EDIDrevision: Byte;
    VideoInputType: Byte;
    SizeHorizontal: Byte;  // in cm
    SizeVertical: Byte;    // in cm
    GammaFactor: Byte;     // gamma factor (gamma = 1.0 + factor/100, so max = 3.55)
    DPMSflags: Byte;
    ChromaXYgreenred: Byte;
    ChromaXYwhiteblue: Byte;
    ChromaXred: Byte;
    ChromaYred: Byte;
    ChromaXgreen: Byte;
    ChromaYgreen: Byte;
    ChromaXblue: Byte;
    ChromaYblue: Byte;
    ChromaXwhite: Byte;
    ChromaYwhite: Byte;
    EstablishedTimings1: Byte;
    EstablishedTimings2: Byte;
    ManufacturersReservedTiming: Byte;
    StandardTimingIdentification: array[1..8] of Word;
    DetailedTimingDescription1: array[1..18] of Byte;
    DetailedTimingDescription2: array[1..18] of Byte;
    DetailedTimingDescription3: array[1..18] of Byte;
    DetailedTimingDescription4: array[1..18] of Byte;
    Unused: Byte;
    Checksum: Byte;
  end;
  PEDIDHeader = ^TEDIDHeader;

function SetupDiDestroyDeviceInfoList(DeviceInfoSet: HDEVINFO): DWORD; stdcall;
{$EXTERNALSYM SetupDiDestroyDeviceInfoList}
function SetupDiGetClassDevsEx(ClassGuid: PGUID; const Enumerator: PTSTR; hwndParent: HWND;
  Flags: DWORD; DeviceInfoSet: HDEVINFO; const MachineName: PTSTR;  Reserved: Pointer): HDEVINFO; stdcall;
{$EXTERNALSYM SetupDiGetClassDevsEx}
function SetupDiEnumDeviceInfo(DeviceInfoSet: HDEVINFO; MemberIndex: DWORD; var DeviceInfoData: TSPDevInfoData): BOOL; stdcall;
{$EXTERNALSYM SetupDiEnumDeviceInfo}
function SetupDiOpenDevRegKey(DeviceInfoSet: HDEVINFO;
  var DeviceInfoData: TSPDevInfoData; Scope, HwProfile, KeyType: DWORD; samDesired: REGSAM): HKEY; stdcall;
{$EXTERNALSYM SetupDiOpenDevRegKey}

function SetupDiGetDeviceRegistryPropertyA(DeviceInfoSet: HDEVINFO; const DeviceInfoData: TSPDevInfoData; Property_: DWORD;
  var PropertyRegDataType: DWORD; PropertyBuffer: PByte; PropertyBufferSize: DWORD; var RequiredSize: DWORD): BOOL; stdcall;
{$EXTERNALSYM SetupDiGetDeviceRegistryPropertyA}
function SetupDiGetDeviceRegistryPropertyW(DeviceInfoSet: HDEVINFO; const DeviceInfoData: TSPDevInfoData; Property_: DWORD;
  var PropertyRegDataType: DWORD; PropertyBuffer: PByte; PropertyBufferSize: DWORD; var RequiredSize: DWORD): BOOL; stdcall;
{$EXTERNALSYM SetupDiGetDeviceRegistryPropertyW}
function SetupDiGetDeviceRegistryProperty(DeviceInfoSet: HDEVINFO; const DeviceInfoData: TSPDevInfoData; Property_: DWORD;
  var PropertyRegDataType: DWORD; PropertyBuffer: PByte; PropertyBufferSize: DWORD; var RequiredSize: DWORD): BOOL; stdcall;
{$EXTERNALSYM SetupDiGetDeviceRegistryProperty}


function EnumDisplayDevicesExt(Unused: Pointer; iDevNum: DWORD; var lpDisplayDevice: TDisplayDeviceExt; dwFlags: DWORD): BOOL; stdcall;
function EnumDisplayDevicesExtA(Unused: Pointer; iDevNum: DWORD; var lpDisplayDevice: TDisplayDeviceExtA; dwFlags: DWORD): BOOL; stdcall;
function EnumDisplayDevicesExtW(Unused: Pointer; iDevNum: DWORD; var lpDisplayDevice: TDisplayDeviceExtW; dwFlags: DWORD): BOOL; stdcall;




function EnumDisplayDevicesExt; external User32ModuleName name 'EnumDisplayDevicesW';
function EnumDisplayDevicesExtA; external User32ModuleName name 'EnumDisplayDevicesA';
function EnumDisplayDevicesExtW; external User32ModuleName name 'EnumDisplayDevicesW';


function SetupDiDestroyDeviceInfoList; external SetupApiModuleName name 'SetupDiDestroyDeviceInfoList';
function SetupDiGetClassDevsEx; external SetupApiModuleName name 'SetupDiGetClassDevsExW';
function SetupDiEnumDeviceInfo; external SetupApiModuleName name 'SetupDiEnumDeviceInfo';
function SetupDiOpenDevRegKey; external SetupApiModuleName name 'SetupDiOpenDevRegKey';

function SetupDiGetDeviceRegistryPropertyA; external SetupApiModuleName name 'SetupDiGetDeviceRegistryPropertyA';
function SetupDiGetDeviceRegistryPropertyW; external SetupApiModuleName name 'SetupDiGetDeviceRegistryPropertyW';
{$IFDEF UNICODE}
function SetupDiGetDeviceRegistryProperty; external SetupApiModuleName name 'SetupDiGetDeviceRegistryPropertyW';
{$ELSE}
function SetupDiGetDeviceRegistryProperty; external SetupApiModuleName name 'SetupDiGetDeviceRegistryPropertyA';
{$ENDIF}


//#@ abstract Определяет физические размеры текущено основного дисплея
function GetPrimaryMonitorTrueSize(var MmWidth, MmHeight: Integer): Boolean;
//#@ abstract Определяет размеры физические всех подключенных мониторов
// AList.Names - наименование устройства, AList.Values - строка с размерами, разделитель - ADimensionsSeparator
// Result - количество мониторов 
function GetMonitorsTrueSizes(AList: TStrings; ADimensionsSeparator: Char): Integer;

implementation

uses StrUtils, SysUtils, RTLConsts;

function GetMonitorSizeFromEDID(hDevRegKey: HKEY; var mmWidth, mmHeight: integer): Boolean;
var
  dwType, ActualValueNameLength: dword;
  buffer: array[0..511] of Char;
  ValueName: PChar;
  EDIDdata: array[0..2047] of byte;
  EDIDsize: dword;
  RetValue: integer;
  ValueIndex: integer;
begin
  Result:= False;
  EDIDsize:= SizeOf(EDIDdata);
  ValueIndex:= 0;
  ValueName:= @buffer[0];
  ActualValueNameLength:= SizeOf(buffer);
  RetValue:= ERROR_SUCCESS;
  while (RetValue = ERROR_SUCCESS) or (RetValue <> ERROR_NO_MORE_ITEMS) do
  begin
    // перебираем узлы
    RetValue:= RegEnumValue(hDevRegKey,ValueIndex,ValueName,
      ActualValueNameLength,nil,@dwType,@EDIDdata, @EDIDsize);

    Inc(ValueIndex);

    if (RetValue <> ERROR_SUCCESS) or (ValueName <> 'EDID') then
      Continue;
    // https://ru.wikipedia.org/wiki/Extended_display_identification_data
    mmWidth:= ((EDIDdata[68] and $F0) shl 4) + EDIDdata[66];
    mmHeight:= ((EDIDdata[68] and $0F) shl 8) + EDIDdata[67];

    Result:= True;
    Exit;
  end;
end;

function GetDevInfo(const DevGUID: TGUID; out hDevInfo: HDEVINFO): Boolean;
begin
  hDevInfo:= SetupDiGetClassDevsEx(@DevGUID, nil, 0, DIGCF_PRESENT, 0, nil, nil);
  Result:= hDevInfo <> INVALID_HANDLE_VALUE;
end;

function FreeDevInfo(const hDevInfo: HDEVINFO): Boolean;
begin
  Result:= hDevInfo <> INVALID_HANDLE_VALUE;

  if Result then
    Result:= Boolean(SetupDiDestroyDeviceInfoList(hDevInfo));
end;

function GetMonitorHardwareID(ADevInfo: HDEVINFO; ADevInfoData: SP_DEVINFO_DATA; var VResult: string): Boolean;
var
  RequiredSize: DWORD;
begin
  VResult:= '';
  // сначала определяем размеры
  Result:= SetupDiGetDeviceRegistryProperty(ADevInfo,ADevInfoData,SPDRP_HARDWAREID,PDWORD(nil)^,nil,0,RequiredSize);
  if not Result and (GetLastError() = ERROR_INSUFFICIENT_BUFFER) then
  begin
    // задаем размеры с учетом того что нам могут вернуть и юникод...
    SetLength(VResult,(RequiredSize) div SizeOf(Char));
    Result:=
      SetupDiGetDeviceRegistryProperty(ADevInfo,ADevInfoData,SPDRP_HARDWAREID,PDWORD(nil)^,
        PByte(@VResult[1]),RequiredSize,RequiredSize);
    // избавляемся от лишних 00    
     if Result then
      VResult:= PChar(VResult);
  end;
end;

function GetPrimaryMonitorTrueSize(var MmWidth, MmHeight: Integer): Boolean;
var
  SizesList: TStrings;
  I, DelimCharIndex,SizeStringLen: Integer;
  SizeString: string;
  SizeStringDelimeter: Char;
begin
  MmWidth:= 0;
  MmHeight:=0;
  SizeStringDelimeter:= 'x';

  SizesList:= TStringList.Create();
  try
    Result:= GetMonitorsTrueSizes(SizesList,SizeStringDelimeter) > 0;

    if Result then
    begin
      for I:= 0 to SizesList.Count -1 do
      begin
        Result:= Boolean(Integer(SizesList.Objects[I]));
        if Result then
        begin
          SizeString:= SizesList.ValueFromIndex[I];
          DelimCharIndex:= PosEx(SizeStringDelimeter,SizeString);
          SizeStringLen:= Length(SizeString);

          MmHeight:= StrToIntDef(MidStr(SizeString,1+ DelimCharIndex,SizeStringLen),-1);
          Delete(SizeString,DelimCharIndex,1+SizeStringLen - DelimCharIndex);
          MmWidth:= StrToIntDef(SizeString,-1);
          Break;
        end;
      end;

      if Result then
        Result:= (MmHeight > 0) and (MmWidth > 0);
    end;

  finally
    FreeAndNil(SizesList);
  end;

end;

{*******************************************************************************
* InternalGetMonitorsSizes
*******************************************************************************}
function InternalGetMonitorsSizes( aList : TStrings; aDimensionsSeparator : char ) : integer;
var
    hDevInfo : THandle;
    hDevRegKey : HKEY;
    hardvareId : string;
    devInfoData : SP_DEVINFO_DATA;
    monitorIndex : integer;
    mmWidth, mmHeight : integer;

begin
    Result := -1;

    hDevInfo := 0;
    hDevInfo := 0;

    aList.Clear();
    // получаем все устройства класса «монитор» из реестра оборудования
    if ( not GetDevInfo( GUID_CLASS_MONITOR, hDevInfo ) ) then
        exit;

    try
        monitorIndex := 0;
        // перебираем устройства
        while ( GetLastError() <> ERROR_NO_MORE_ITEMS ) do
        begin
            devInfoData.cbSize := SizeOf( devInfoData );
            if SetupDiEnumDeviceInfo( hDevInfo, monitorIndex, devInfoData ) then
            begin
                // получаем идентификатор устройства...
                if not GetMonitorHardwareID( hDevInfo, DevInfoData, HardvareId ) then
                    hardvareId := 'UnknownHardwareID';

                // получаем параметры устройства
                hDevRegKey := SetupDiOpenDevRegKey( hDevInfo, devInfoData, DICS_FLAG_GLOBAL, 0, DIREG_DEV, KEY_READ );
                if ( hDevRegKey = INVALID_HANDLE_VALUE ) then
                    continue;

                try
                    // получаем размеры
                    if GetMonitorSizeFromEDID( hDevRegKey, mmWidth, mmHeight ) then
                        aList.Add( hardvareId + aList.NameValueSeparator + IntToStr( mmWidth ) + aDimensionsSeparator + IntToStr( mmHeight ) )
                    else // если не получилось, например у устройства плохой EDID, складываем INF
                        aList.Add( hardvareId + aList.NameValueSeparator + 'INF' + aDimensionsSeparator + 'INF' );
                finally
                    RegCloseKey(hDevRegKey);
                end;
            end;

            // идем дальше
            inc( monitorIndex );
        end;

        Result := aList.Count;
    finally
        FreeDevInfo( hDevInfo );
    end;
end;


function GetMonitorsTrueSizes(AList: TStrings; ADimensionsSeparator: Char): Integer;
var
  DisplayDev,MonitorDev: TDisplayDeviceExt;
  MonitorNumber, DeviceIndex: Integer;
  DevName,DispName,ModelName,DevID,Caption{,DevKey,DevString}: string;
  IsPrimary: Boolean;
  SizesList: TStringList;
  SizesString: string;
begin
  Result:= -1;
  if (AList = nil) then
    Exit;

  AList.Clear();
  SizesList:= TStringList.Create();

  // не удалось считать монаторы из профиля оборудования - выходим
  if (InternalGetMonitorsSizes(SizesList,ADimensionsSeparator) < 1) then
    Exit;

  try
    DeviceIndex:= 0;
    DisplayDev.cb:= SizeOf(TDisplayDeviceExt);
    // перебираем все подключенные устройства отображения
    while EnumDisplayDevicesExtA(nil,DeviceIndex,DisplayDev,0) do
    begin
      DevName:= PChar(@DisplayDev.DeviceName[0]);
{ //-adt отдадка
      DevString:= PChar(@DisplayDev.DeviceString[0]);
      DevID:= PChar(@DisplayDev.DeviceID[0]);
      DevKey:= PChar(@DisplayDev.DeviceKey[0]);
}
      // если устройство - часть рабочего стола...
      if (DisplayDev.StateFlags and DISPLAY_DEVICE_ATTACHED_TO_DESKTOP) = DISPLAY_DEVICE_ATTACHED_TO_DESKTOP then
      begin
        MonitorDev.cb:=  SizeOf(TDisplayDeviceExt);
        MonitorNumber:= 0;

        // перебираем все подключенные к нему мониторы...
        while EnumDisplayDevicesExtA(PChar(DevName),MonitorNumber,MonitorDev,0) do
        begin
          // если монитор подключен и не виртуальный
          if  ( MonitorDev.StateFlags and DISPLAY_DEVICE_ACTIVE = DISPLAY_DEVICE_ACTIVE)  and
              ( MonitorDev.StateFlags and DISPLAY_DEVICE_MIRRORING_DRIVER = 0) then
          begin
            // преобразуем имена устройства и монитора в удобочитаемый вид
            DispName:= PChar(@MonitorDev.DeviceName[0]);
            Delete(DispName,PosEx('\\.\',DispName),4);
            DispName:=
              MidStr(DispName,1+PosEx('\\',DispName),Length(DispName)-(1 + Length(DispName)-PosEx('\',DispName,2)));
            DevID:= PChar(@MonitorDev.DeviceID[0]);
{ //-adt отдадка
            DevKey:= PChar(@MonitorDev.DeviceKey[0]);
            DevString:= PChar(@MonitorDev.DeviceString[0]);
}
            DevID:= MidStr(DevID,0,PosEx('{',DevID)-2 );
            ModelName:= MidStr(DevID,1+PosEx('\',DevID),Length(DevID) - PosEx('\',DevID));

            Caption:= DispName + ' - ' + ModelName;

            // если этого монитора у нас ещё небыло - добавляем его с параметрами
            if (AList.IndexOfName(Caption) < 0) then
            begin
              // находим параметры устройства по его id
              SizesString:= SizesList.Values[DevID];
              if SizesString = '' then
                SizesString:= 'INF'+ADimensionsSeparator+'INF';

              // главный рабочий стол на этом устройстве?
              IsPrimary:= DisplayDev.StateFlags and DISPLAY_DEVICE_PRIMARY_DEVICE = DISPLAY_DEVICE_PRIMARY_DEVICE;
              
              AList.AddObject(Caption + AList.NameValueSeparator + SizesString,TObject(Integer(IsPrimary)));
            end;
          end;
          Inc(MonitorNumber);
        end;
      end;
      Inc(DeviceIndex);
    end;
  finally
    FreeAndNil(SizesList);
  end;
  
  Result:= AList.Count;
end;

end.

