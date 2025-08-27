#!/usr/bin/env raku

use Async::Command::Multi;
use Data::Dump::Tree;

my %command;
%command<ctz1celadm01>  =   (
                                'ssh',
                                'ctz1dbadm01',
                                'sudo',
                                'ssh',
                                'ctz1celadm01',
                                Q/"cellcli -e list alerthistory WHERE begintime \\\\\> \\\\\'/ ~ '2025-01-01T00:00:01-04:00' ~ Q/\\\\\'"/,
                            );

die %command<ctz1celadm01>;

#   ssh ctz1dbadm01 sudo -- ssh ctz1celadm01 "cellcli -e list alerthistory WHERE begintime \\\\\> \\\\\'2025-01-01T00:00:01-04:00\\\\\'"

my %alerthistory        = Async::Command::Multi.new(:%command).sow.reap;

ddt %alerthistory;

=finish

#   A028441@jgz1dbadm01.wmata.com:~> sudo dcli -l root -g /root/cell_group 'cellcli -e "list alerthistory WHERE begintime > \"2019-01-01T15:46:30-04:00\""'

for @ZDLRA-Admins -> $adm {
    %command{$adm}  = 'ssh', $adm, 'sudo', 'dcli', '-l', 'root', '-g', '/root/cell_group', '"cellcli -e list alerthistory"';
}
my %lastdt;
my %alerthistory    = Async::Command::Multi.new(:%command).sow.reap;                                                            # ddt %alerthistory; exit;

for %alerthistory.keys.sort -> $adm {
    for %alerthistory{$adm}.stdout-results.lines -> $record {
        my @fields  = $record.trim.split(/\s+/);
        my $datetime    = DateTime.new(@fields[2]);
        my $node        = @fields[0].ends-with(':') ?? @fields[0].chop(1) !! @fields[0];

die '|' ~ $node ~ '|';

        %lastdt{$adm}   = $datetime if %lastdt{$adm}:exists && $datetime > %lastdt{$adm};
        %status{$adm}<ALERTHISTORY>.push: ALERTHISTORY_RECORD.new:
            :name(@fields[1]),
            :$datetime,
            :precedence(@fields[3]),
            :message(@fields[4..*].join(' '));
    }
}

for @ZDLRA-Admins -> $adm {
    my $cache       = Our::Cache.new(:identifier($id-prefix ~ '_' ~ $adm));
    $cache.store(:data(%lastdt{$adm}.Str)) or note;
}

ddt %status;

=finish
