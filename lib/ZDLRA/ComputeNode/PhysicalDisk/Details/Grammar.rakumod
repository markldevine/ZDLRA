unit    grammar ZDLRA::ComputeNode::PhysicalDisk::Details::Grammar:api<1>:auth<Mark Devine (mark@markdevine.com)>;

token TOP                       {   <detail-record>+                                        }
token detail-record             {
                                    <name-line>                 # 252:0
                                    <deviceId-line>             # 19
                                    <diskType-line>             # HardDisk
                                    <enclosureDeviceId-line>    # 252
                                    <errOtherCount-line>        # 0
                                    <makeModel-line>            # "HGST    H101860SFSUN600G"
                                    <physicalFirmware-line>     # A990
                                    <physicalInsertTime-line>   # 2026-04-09T04:00:58-04:00
                                    <physicalInterface-line>    # sas
                                    <physicalSerial-line>       # FAGANF
                                    <physicalSize-line>         # 558.91207122802734375G
                                    <slotNumber-line>           # 0
                                    <status-line>               # failed
                                    \n*
                                }
token name-line                 { ^^ \s+ 'name:' \s+ <name>                              \n }
token name                      { \d+ ':' \d+                                               }
token deviceId-line             { ^^ \s+ 'deviceId:' \s+ <deviceId>                      \n }
token deviceId                  { \d+                                                       }
token diskType-line             { ^^ \s+ 'diskType:' \s+ <diskType>                      \n }
token diskType                  { \w+                                                       }
token enclosureDeviceId-line    { ^^ \s+ 'enclosureDeviceId:' \s+ <enclosureDeviceId>    \n }
token enclosureDeviceId         { \d+                                                       }
token errOtherCount-line        { ^^ \s+ 'errOtherCount:' \s+ <errOtherCount>            \n }
token errOtherCount             { \d+                                                       }
token makeModel-line            { ^^ \s+ 'makeModel:' \s+ '"' <makeModel> '"'            \n }
token makeModel                 { <[\w\s]>+                                                 }
token physicalFirmware-line     { ^^ \s+ 'physicalFirmware:' \s+ <physicalFirmware>      \n }
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
                                    \n
                                }
token year                      { \d\d\d\d                                                  }
token month                     { \d\d                                                      }
token day                       { \d\d                                                      }
token hour                      { \d\d                                                      }
token minute                    { \d\d                                                      }
token second                    { \d\d                                                      }
token offset                    { \d\d ':' \d\d                                             }
token physicalInterface-line    { ^^ \s+ 'physicalInterface:' \s+ <physicalInterface>    \n }
token physicalInterface         { \w+                                                       }
token physicalSerial-line       { ^^ \s+ 'physicalSerial:' \s+ <physicalSerial>          \n }
token physicalSerial            { \w+                                                       }
token physicalSize-line         { ^^ \s+ 'physicalSize:' \s+ <physicalSize>              \n }
token physicalSize              { <[\w.]>+                                                  }
token slotNumber-line           { ^^ \s+ 'slotNumber:' \s+ <slotNumber>                  \n }
token slotNumber                { \d+                                                       }
token status-line               { ^^ \s+ 'status:' \s+ <status>                          \n }
token status                    { \w+                                                       }

=finish
