unit    class ZDLRA::Common::PhysicalDisk::Details::Actions:api<1>:auth<Mark Devine (mark@markdevine.com)>;

use     ZDLRA::Common::PhysicalDisk::Details::Record;

method TOP ($/) {
    make $<detail-record>».made;
}

method detail-record($/) {
    my DateTime $dt;
    $dt         = DateTime.new:
                    year    => $<physicalInsertTime-line><year>.Str,
                    month   => $<physicalInsertTime-line><month>.Str,
                    day     => $<physicalInsertTime-line><day>.Str,
                    hour    => $<physicalInsertTime-line><hour>.Str,
                    minute  => $<physicalInsertTime-line><minute>.Str,
                    second  => $<physicalInsertTime-line><second>.Str,
                with $<physicalInsertTime-line><year>;
    my $deviceName          = '';
    $deviceName             = $<diskType-line><diskType>.Str with $<diskType-line>;
    my $luns                = '';
    $luns                   = $<luns-line><luns>.Str with $<luns-line>;
    make ZDLRA::Common::PhysicalDisk::Details::Record.new(
        name                => $<name-line><name>.Str,
        deviceId            => $<deviceId-line><deviceId>.Str,
        deviceName          => $deviceName;
        diskType            => $<diskType-line><diskType>.Str,
        enclosureDeviceId   => $<enclosureDeviceId-line><enclosureDeviceId>.Str,
        errOtherCount       => $<errOtherCount-line><errOtherCount>.Str.Int,
        luns                => $luns,
        makeModel           => $<makeModel-line><makeModel>.Str,
        physicalFirmware    => $<physicalFirmware-line><physicalFirmware>.Str,
        physicalInsertTime  => $dt,
        physicalInterface   => $<physicalInterface-line><physicalInterface>.Str,
        physicalSerial      => $<physicalSerial-line><physicalSerial>.Str,
        physicalSize        => $<physicalSize-line><physicalSize>.Str,
        slotNumber          => $<slotNumber-line><slotNumber>.Str.Int,
        status              => $<status-line><status>.Str,
    );
}

=finish
