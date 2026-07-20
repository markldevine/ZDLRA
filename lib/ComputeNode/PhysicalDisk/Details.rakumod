unit        class ZDLRA::ComputeNode::PhysicalDiskere:api<1>:auth<Mark Devine (mark@markdevine.com)>;

#use Grammar::Debugger; 
#use Grammar::Tracer;

my %command;
my %results;
my %Physical-Disk-Details;

my class COMPUTE-PHYSICALDISK-DETAIL {

    has $.input                 is required;

    my class PHYSICALDISK-DETAIL {
        has $.name;
        has $.deviceId;
        has $.diskType;
        has $.enclosureDeviceId;
        has $.errOtherCount;
        has $.makeModel;
        has $.physicalFirmware;
        has $.physicalInsertTime;
        has $.physicalInterface;
        has $.physicalSerial;
        has $.physicalSize;
        has $.slotNumber;
        has $.status;
    }

    my grammar COMPUTE-PHYSICALDISK-DETAIL-GRAMMAR {
        token TOP                   {   <detail-record>+        }
        token detail-record         {
                                        <name>                   # 252:0
                                        <deviceId>               # 19
                                        <diskType>               # HardDisk
                                        <enclosureDeviceId>      # 252
                                        <errOtherCount>          # 0
                                        <makeModel>              # "HGST    H101860SFSUN600G"
                                        <physicalFirmware>       # A990
                                        <physicalInsertTime>     # 2026-04-09T04:00:58-04:00
                                        <physicalInterface>      # sas
                                        <physicalSerial>         # FAGANF
                                        <physicalSize>           # 558.91207122802734375G
                                        <slotNumber>             # 0
                                        <status>                 # failed
                                    }
        token name                  { ^  \s+ 'name:' \s+ \d+ ':'        \d+  \n }
        token deviceId              { ^ \s+ 'deviceId:' \s+            \d+   \n }
        token diskType              { ^ \s+ 'diskType:' \s+            .+?   \n }
        token enclosureDeviceId     { ^ \s+ 'enclosureDeviceId:' \s+   \d+   \n }
        token errOtherCount         { ^ \s+ 'errOtherCount:' \s+       \d+   \n }
        token makeModel             { ^ \s+ 'makeModel:' \s+           .+?   \n }
        token physicalFirmware      { ^ \s+ 'physicalFirmware:' \s+    .+?   \n }
        token physicalInsertTime    {
                                        ^ \s+ 'physicalInsertTime:' \s+
                                        $<year>=\d\d\d\d '-'
                                        $<month>=\d\d '-'
                                        $<day>=\d\d '-'
                                        'T'
                                        $<hour>=\d\d ':'
                                        $<minute>=\d\d ':'
                                        $<second>=\d\d
                                        '-'
                                        $<offset>=.+?
                                        \n
                                    }
        token physicalInterface     { ^ \s+ 'physicalInterface:' \s+   .+?   \n }
        token physicalSerial        { ^ \s+ 'physicalSerial:' \s+      .+?   \n }
        token physicalSize          { ^ \s+ 'physicalSize:' \s+        .+?   \n }
        token slotNumber            { ^ \s+ 'slotNumber:' \s+          \d+   \n }
        token status                { ^ \s+ 'status:' \s+              .+?   \n }
    }

#   my class COMPUTE-PHYSICALDISK-DETAIL-ACTION {
#       ;
#   }

    submethod TWEAK {
        $                   = COMPUTE-PHYSICALDISK-DETAIL-GRAMMAR.parse($!input);
    }
}




my $CTF-ZDLRA-admin     = 'ctz1dbadm01';

for @CTF-ZDLRA-cells -> $cell {
    %command{$cell}     =   'ssh', $CTF-ZDLRA-admin, 'sudo', 'su', '-', 'root', '-c', '"ssh ' ~ $cell ~ ' cellcli -e list physicaldisk"';
}

my $EQX-ZDLRA-admin     = 'jgz1dbadm01';
my @EQX-ZDLRA-cells     = <jgz1celadm01 jgz1celadm02 jgz1celadm03 jgz1celadm04 jgz1celadm05 jgz1celadm06 jgz1celadm07 jgz1celadm08 jgz1celadm09 jgz1celadm10 jgz1celadm11 jgz1celadm12 jgz1celadm13 jgz1celadm14>;

# Cells
for @EQX-ZDLRA-cells -> $cell {
    %command{$cell}     =   'ssh', $EQX-ZDLRA-admin, 'sudo', 'su', '-', 'root', '-c', '"ssh ' ~ $cell ~ ' cellcli -e list physicaldisk"';
}
%results                = Async::Command::Multi.new(:%command).sow.reap;
for %results.keys.sort -> $cell {
    put $cell;
    for %results{$cell}.stdout-results.lines -> $record {
        my @fields      = $record.trim.split(/\s+/);
        put "\t" ~ @fields[0..1].join("\t") ~ "\t" ~ @fields[2..*].join(' ') if @fields[2] ne 'normal';
    }
}

=finish

mdevine@W-608863:~> ssh ctz1dbadm02 sudo dbmcli -e list physicaldisk detail | cat
         name:                   252:0
         deviceId:               19
         diskType:               HardDisk
         enclosureDeviceId:      252
         errOtherCount:          0
         makeModel:              "HGST    H101860SFSUN600G"
         physicalFirmware:       A990
         physicalInsertTime:     2026-04-09T04:00:58-04:00
         physicalInterface:      sas
         physicalSerial:         FAGANF
         physicalSize:           558.91207122802734375G
         slotNumber:             0
         status:                 failed

         name:                   252:1
         deviceId:               20
         diskType:               HardDisk
         enclosureDeviceId:      252
         errOtherCount:          0
         makeModel:              "SEAGATE ST0600IN9SUN600G"
         physicalFirmware:       ORSB
         physicalInsertTime:     2026-04-09T04:00:58-04:00
         physicalInterface:      sas
         physicalSerial:         JEFMXD
         physicalSize:           558.91207122802734375G
         slotNumber:             1
         status:                 normal

