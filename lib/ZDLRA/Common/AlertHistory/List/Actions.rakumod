unit    class ZDLRA::Common::AlertHistory::List::Actions:api<1>:auth<Mark Devine (mark@markdevine.com)>;

use     ZDLRA::Common::AlertHistory::List::Record;

method TOP ($/) {
    make $<detail-record>».made;
}

method detail-record($/) {
    my $dt      = DateTime.new:
                    year    => $<physicalInsertTime-line><year>.Str,
                    month   => $<physicalInsertTime-line><month>.Str,
                    day     => $<physicalInsertTime-line><day>.Str,
                    hour    => $<physicalInsertTime-line><hour>.Str,
                    minute  => $<physicalInsertTime-line><minute>.Str,
                    second  => $<physicalInsertTime-line><second>.Str,
                ;
    make ZDLRA::Common::AlertHistory::List::Record.new(
        name                 => $<name-line><name>.Str,
        deviceId             => $<deviceId-line><deviceId>.Str,
        diskType             => $<diskType-line><diskType>.Str,
        enclosureDeviceId    => $<enclosureDeviceId-line><enclosureDeviceId>.Str,
        errOtherCount        => $<errOtherCount-line><errOtherCount>.Str.Int,
        makeModel            => $<makeModel-line><makeModel>.Str,
        physicalFirmware     => $<physicalFirmware-line><physicalFirmware>.Str,
        physicalInsertTime   => $dt,
        physicalInterface    => $<physicalInterface-line><physicalInterface>.Str,
        physicalSerial       => $<physicalSerial-line><physicalSerial>.Str,
        physicalSize         => $<physicalSize-line><physicalSize>.Str,
        slotNumber           => $<slotNumber-line><slotNumber>.Str.Int,
        status               => $<status-line><status>.Str,
    );
}

=finish

class ALERTHISTORY-ACTIONS {
    has Str $.dbm           is required;
    has Str $.cell          is required;

    method log-record-herald ($/) {
        my $datetime        = DateTime.new(~$/<datetime>);
        %inventory{$!dbm}<CELLS>{$!cell}<ALERTHISTORY>.push: ALERTHISTORY-RECORD.new(
            :name(~$/<name>),
            :$datetime,
            :severity(~$/<severity>),
        );
        %ah-dt-cache{$!dbm}{$!cell} = $datetime if $datetime > %ah-dt-cache{$!dbm}{$!cell};
    }

    method log-text ($/) {
        %inventory{$!dbm}<CELLS>{$!cell}<ALERTHISTORY>[* - 1].message.push: ~$/.chomp;
    }
}

