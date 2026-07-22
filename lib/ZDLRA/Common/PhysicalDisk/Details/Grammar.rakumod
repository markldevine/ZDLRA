unit    grammar ZDLRA::Common::PhysicalDisk::Details::Grammar:api<1>:auth<Mark Devine (mark@markdevine.com)>;

token TOP                       {   <detail-record>+                                        }
token detail-record             {
                                    <name-line>                 # 252:0
                                    <deviceId-line>             # 19
                                    <deviceName-line>*          # /dev/sda
                                    <diskType-line>             # HardDisk
                                    <enclosureDeviceId-line>    # 252
                                    <errOtherCount-line>        # 0
                                    <luns-line>*                # 0_3
                                    <makeModel-line>            # "HGST    H101860SFSUN600G"
                                    <physicalFirmware-line>     # A990
                                    <physicalInsertTime-line>*  # 2026-04-09T04:00:58-04:00
                                    <physicalInterface-line>    # sas
                                    <physicalSerial-line>       # FAGANF
                                    <physicalSize-line>         # 558.91207122802734375G
                                    <slotNumber-line>           # 0
                                    <status-line>               # failed
                                    \n*
                                }
token name-line                 { ^^ \s+ 'name:' \s+ <name>           { put $/.Str; }    \n }
token name                      { \d+ ':' \d+                                               }
token deviceId-line             { ^^ \s+ 'deviceId:' \s+ <deviceId>   { put $/.Str; }    \n }
token deviceId                  { \d+                                                       }
token deviceName-line           { ^^ \s+ 'deviceName:' \s+ <deviceName>   { put $/.Str; } \n }
token deviceName                { '/dev/' \w+                                               }
token diskType-line             { ^^ \s+ 'diskType:' \s+ <diskType>   { put $/.Str; }    \n }
token diskType                  { \w+                                                       }
token enclosureDeviceId-line    { ^^ \s+ 'enclosureDeviceId:' \s+ <enclosureDeviceId> { put $/.Str; }   \n }
token enclosureDeviceId         { \d+                                                       }
token errOtherCount-line        { ^^ \s+ 'errOtherCount:' \s+ <errOtherCount>         { put $/.Str; }   \n }
token errOtherCount             { \d+                                                       }

token luns-line                 { ^^ \s+ 'luns:' \s+ <luns>            { put $/.Str; }   \n }
token luns                      { \d+ '_' \d+                                               }

token makeModel-line            { ^^ \s+ 'makeModel:' \s+ '"' <makeModel> '"'         { put $/.Str; }   \n }
token makeModel                 { <[\w\s]>+                                                 }
token physicalFirmware-line     { ^^ \s+ 'physicalFirmware:' \s+ <physicalFirmware>   { put $/.Str; }   \n }
token physicalFirmware          { \w+                                                       }
token physicalInsertTime-line   {
                                    ^^ \s+ 'physicalInsertTime:' \s+
                                    <year>
                                    '-'
                                    <month>
                                    '-'
                                    <day>
                                    'T'
                                    <hour>
                                    ':'
                                    <minute>
                                    ':'
                                    <second>
                                    '-'
                                    <offset>
                                    \n                                                { put $/.Str; }
                                }
token year                      { \d\d\d\d                                                  }
token month                     { \d\d                                                      }
token day                       { \d\d                                                      }
token hour                      { \d\d                                                      }
token minute                    { \d\d                                                      }
token second                    { \d\d                                                      }
token offset                    { \d\d ':' \d\d                                             }
token physicalInterface-line    { ^^ \s+ 'physicalInterface:' \s+ <physicalInterface> { put $/.Str; }   \n }
token physicalInterface         { \w+                                                       }
token physicalSerial-line       { ^^ \s+ 'physicalSerial:' \s+ <physicalSerial>       { put $/.Str; }   \n }
token physicalSerial            { \w+                                                       }
token physicalSize-line         { ^^ \s+ 'physicalSize:' \s+ <physicalSize>           { put $/.Str; }   \n }
token physicalSize              { <[\w.]>+                                                  }
token slotNumber-line           { ^^ \s+ 'slotNumber:' \s+ <slotNumber>               { put $/.Str; }   \n }
token slotNumber                { \d+                                                       }
token status-line               { ^^ \s+ 'status:' \s+ <status>                       { put $/.Str; }   \n }
token status                    { \w+                                                       }

=finish

 name: 252:0
 deviceId: 22
 deviceName: /dev/sda
 diskType: HardDisk
 enclosureDeviceId: 252
 errOtherCount: 0
 luns: 0_0
 makeModel: "HGST H7210A520SUN010T"
 physicalFirmware: A680
 physicalInsertTime: 2018-10-02T12:53:03-04:00
 physicalInterface: sas
 physicalSerial: R8U3EN
 physicalSize: 8.91015625T
 slotNumber: 0
 status: normal

 name: 252:1
 deviceId: 23
 deviceName: /dev/sdb
 diskType: HardDisk
 enclosureDeviceId: 252
 errOtherCount: 0
 luns: 0_1
 makeModel: "HGST H7210A520SUN010T"
 physicalFirmware: A680
 physicalInsertTime: 2018-10-02T12:53:03-04:00
 physicalInterface: sas
 physicalSerial: R8XNJN
 physicalSize: 8.91015625T
 slotNumber: 1
 status: normal

 name: 252:2
 deviceId: 21
 deviceName: /dev/sdc
 diskType: HardDisk
 enclosureDeviceId: 252
 errOtherCount: 0
 luns: 0_2
 makeModel: "HGST H7210A520SUN010T"
 physicalFirmware: A680
 physicalInsertTime: 2018-10-02T12:53:03-04:00
 physicalInterface: sas
 physicalSerial: R8XN6N
 physicalSize: 8.91015625T
 slotNumber: 2
 status: normal

 name: 252:3
 deviceId: 20
 deviceName: /dev/sdd
 diskType: HardDisk
 enclosureDeviceId: 252
 errOtherCount: 0
 luns: 0_3
 makeModel: "HGST H7210A520SUN010T"
 physicalFirmware: A680
 physicalInsertTime: 2018-10-02T12:53:03-04:00
 physicalInterface: sas
 physicalSerial: R8NZXN
 physicalSize: 8.91015625T
 slotNumber: 3
 status: normal

 name: 252:4
 deviceId: 26
 deviceName: /dev/sde
 diskType: HardDisk
 enclosureDeviceId: 252
 errOtherCount: 0
 luns: 0_4
 makeModel: "HGST H7210A520SUN010T"
 physicalFirmware: A680
 physicalInsertTime: 2018-10-02T12:53:03-04:00
 physicalInterface: sas
 physicalSerial: R8XYKN
 physicalSize: 8.91015625T
 slotNumber: 4
 status: normal

 name: 252:5
 deviceId: 27
 deviceName: /dev/sdf
 diskType: HardDisk
 enclosureDeviceId: 252
 errOtherCount: 0
 luns: 0_5
 makeModel: "HGST H7210A520SUN010T"
 physicalFirmware: A680
 physicalInsertTime: 2018-10-02T12:53:03-04:00
 physicalInterface: sas
 physicalSerial: R8XNGN
 physicalSize: 8.91015625T
 slotNumber: 5
 status: normal

 name: 252:6
 deviceId: 25
 deviceName: /dev/sdg
 diskType: HardDisk
 enclosureDeviceId: 252
 errOtherCount: 0
 luns: 0_6
 makeModel: "HGST H7210A520SUN010T"
 physicalFirmware: A680
 physicalInsertTime: 2018-10-02T12:53:03-04:00
 physicalInterface: sas
 physicalSerial: R8N7XN
 physicalSize: 8.91015625T
 slotNumber: 6
 status: normal

 name: 252:7
 deviceId: 24
 deviceName: /dev/sdi
 diskType: HardDisk
 enclosureDeviceId: 252
 errOtherCount: 0
 luns: 0_7
 makeModel: "HGST H7210A520SUN010T"
 physicalFirmware: A680
 physicalInsertTime: 2018-10-02T12:53:03-04:00
 physicalInterface: sas
 physicalSerial: R8V21N
 physicalSize: 8.91015625T
 slotNumber: 7
 status: normal

 name: 252:8
 deviceId: 17
 deviceName: /dev/sdh
 diskType: HardDisk
 enclosureDeviceId: 252
 errOtherCount: 0
 luns: 0_8
 makeModel: "HGST H7210A520SUN010T"
 physicalFirmware: A680
 physicalInsertTime: 2018-10-02T12:53:03-04:00
 physicalInterface: sas
 physicalSerial: R8WU4N
 physicalSize: 8.91015625T
 slotNumber: 8
 status: normal

 name: 252:9
 deviceId: 18
 deviceName: /dev/sdj
 diskType: HardDisk
 enclosureDeviceId: 252
 errOtherCount: 0
 luns: 0_9
 makeModel: "HGST H7210A520SUN010T"
 physicalFirmware: A680
 physicalInsertTime: 2018-10-02T12:53:03-04:00
 physicalInterface: sas
 physicalSerial: R8YX1N
 physicalSize: 8.91015625T
 slotNumber: 9
 status: normal

 name: 252:10
 deviceId: 19
 deviceName: /dev/sdk
 diskType: HardDisk
 enclosureDeviceId: 252
 errOtherCount: 1
 luns: 0_10
 makeModel: "HGST H7210A520SUN010T"
 physicalFirmware: A680
 physicalInsertTime: 2018-10-02T12:53:03-04:00
 physicalInterface: sas
 physicalSerial: R8ZDPN
 physicalSize: 8.91015625T
 slotNumber: 10
 status: normal

 name: 252:11
 deviceId: 28
 deviceName: /dev/sdl
 diskType: HardDisk
 enclosureDeviceId: 252
 errOtherCount: 0
 luns: 0_11
 makeModel: "HGST H7210A520SUN010T"
 physicalFirmware: A680
 physicalInsertTime: 2025-08-12T10:55:17-04:00
 physicalInterface: sas
 physicalSerial: R85WNN
 physicalSize: 8.91015625T
 slotNumber: 11
 status: normal

 name: FLASH_10_1
 deviceName: /dev/nvme0n1
 diskType: FlashDisk
 luns: 10_0
 makeModel: "Oracle Flash Accelerator F640 PCIe Card"
 physicalFirmware: QDV1RF35
 physicalInsertTime: 2018-10-02T12:53:23-04:00
 physicalSerial: PHLE811000WB6P4BGN-1
 physicalSize: 2.910957656800746917724609375T
 slotNumber: "PCI Slot: 10; FDOM: 1"
 status: normal

 name: FLASH_10_2
 deviceName: /dev/nvme1n1
 diskType: FlashDisk
 luns: 10_0
 makeModel: "Oracle Flash Accelerator F640 PCIe Card"
 physicalFirmware: QDV1RF35
 physicalInsertTime: 2018-10-02T12:53:23-04:00
 physicalSerial: PHLE811000WB6P4BGN-2
 physicalSize: 2.910957656800746917724609375T
 slotNumber: "PCI Slot: 10; FDOM: 2"
 status: normal

 name: FLASH_5_1
 deviceName: /dev/nvme2n1
 diskType: FlashDisk
 luns: 5_0
 makeModel: "Oracle Flash Accelerator F640 PCIe Card"
 physicalFirmware: QDV1RF35
 physicalInsertTime: 2018-10-02T12:53:23-04:00
 physicalSerial: PHLE809301Z36P4BGN-1
 physicalSize: 2.910957656800746917724609375T
 slotNumber: "PCI Slot: 5; FDOM: 1"
 status: normal

 name: FLASH_5_2
 deviceName: /dev/nvme3n1
 diskType: FlashDisk
 luns: 5_0
 makeModel: "Oracle Flash Accelerator F640 PCIe Card"
 physicalFirmware: QDV1RF35
 physicalInsertTime: 2018-10-02T12:53:23-04:00
 physicalSerial: PHLE809301Z36P4BGN-2
 physicalSize: 2.910957656800746917724609375T
 slotNumber: "PCI Slot: 5; FDOM: 2"
 status: normal

 name: M2_SYS_0
 deviceName: /dev/sdm
 diskType: M2Disk
 makeModel: "INTEL SSDSCKJB150G7"
 physicalFirmware: N2010121
 physicalInsertTime: 2018-10-02T12:53:30-04:00
 physicalSerial: PHDW808401KH150A
 physicalSize: 139.73558807373046875G
 slotNumber: "M.2 Slot: 0"
 status: normal

 name: M2_SYS_1
 deviceName: /dev/sdn
 diskType: M2Disk
 makeModel: "INTEL SSDSCKJB150G7"
 physicalFirmware: N2010121
 physicalInsertTime: 2018-10-02T12:53:30-04:00
 physicalSerial: PHDW808401EN150A
 physicalSize: 139.73558807373046875G
 slotNumber: "M.2 Slot: 1"
 status: normal

