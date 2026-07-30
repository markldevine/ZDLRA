unit class ZDLRA::StorageCell::AlertHistory::List:api<1>:auth<Mark Devine (mark@markdevine.com)>;

use             JSON::Fast;
use             ZDLRA::Common::AlertHistory::List::Actions;
use             ZDLRA::Common::AlertHistory::List::Grammar;
use             ZDLRA::Common::AlertHistory::List::Record;
use             Async::Command::Multi;

has             @.cell-gateways     is required;
has DateTime    $.begin-datetime    is required;
has             %.List;

submethod TWEAK {
    my %command;
    for @!cell-gateways -> $cell-gateway {
        %command{$cell-gateway} =   'ssh',
                                    $cell-gateway,
                                    'sudo',
                                    '-n',
                                    '/usr/bin/dcli',
                                    '-l',
                                    'root',
                                    '-g',
                                    '/root/cell_group',
                                    'cellcli',
                                    '-e',
                                    'list',
                                    'alerthistory',
#                                   'WHERE',
#                                   'begintime',
#                                   '\\>',
#                                   "\\'" ~ $!begin-datetime ~ "\\'",
                                    ;
    }
    my %results                     = Async::Command::Multi.new(:%command).sow.reap;


#jgz1celadm02: /opt/oracle.cellos/HWFWCheckUtil/content/ActualFirmwareFiles/ILOM-5_1_5_22_b_r166343-ORAC
#jgz1celadm02: 3_2    2026-07-13T15:31:10-04:00    clear       File system / is 63% full, which is below 
#jgz1celadm01: 1_1    2025-07-16T22:08:51-04:00    warning     Diagnostic packages for Service Requests wi
#jgz1celadm01: 2_1    2026-07-13T15:01:23-04:00    critical    After initial accelerated space reclamation,
#jgz1celadm01: This alert will be cleared when file system / becomes less than 75% full.

    my %logs;
    for %results.keys.sort -> $storage-cell {
        my ($storage-cell, $text)   = split(':', 2);
        $logs{$storage-cell} ~= $text;
    }

    for %logs.keys.sort -> $storage-cell {
        my $actions                 = ZDLRA::Common::AlertHistory::List::Actions.new;
        %!List{$storage-cell}       = ZDLRA::Common::AlertHistory::List::Grammar.parse(%logs{$storage-cell}, :$actions).made;
put %!List{$storage-cell}.elems;
    }
}

=finish
