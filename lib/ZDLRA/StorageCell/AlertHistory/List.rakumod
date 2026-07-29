unit        class ZDLRA::StorageCell::AlertHistory::List:api<1>:auth<Mark Devine (mark@markdevine.com)>;

use         JSON::Fast;
use         ZDLRA::Common::AlertHistory::List::Actions;
use         ZDLRA::Common::AlertHistory::List::Grammar;
use         ZDLRA::Common::AlertHistory::List::Record;
use         Async::Command::Multi;
use         Our::Cache;

constant ALERTHISTORY-DATETIMES-CI  = 'STORAGECELL_ALERTHISTORY_LIST';

#   for @!storage-cells -> $storage-cell {
#       %command{$storage-cell} =   'ssh',
#                                   $storage-cell,
#                                   'sudo',
#                                   Q/"cellcli -e list alerthistory WHERE begintime \\> \\'/ ~ %ah-dt-cache{$storage-cell}.Str ~ Q/\\'"/,
#                                   ;
#   for %results.keys.sort -> $storage-cell {
#       my $actions                 = ZDLRA::Common::AlertHistory::List::Actions.new;
#       %!List{$storage-cell}       = ZDLRA::Common::AlertHistory::List::Grammar.parse(%results{$storage-cell}.stdout-results, :$actions).made;
#   }

#-------------------------------------------------------------------------------
#   for %inventory.keys -> $dbm {
#       for %inventory{$dbm}<CELLS>.keys.sort -> $cell {
#           ALERTHISTORY-GRAMMAR.parse(%alerthistory{$cell}.stdout-results, :actions(ALERTHISTORY-ACTIONS.new(:$dbm, :$cell)));
#       }
#   }
#   $ah-dt-cache.store(:data(to-json(%ah-dt-cache)));

#-------------------------------------------------------------------------------

has $.cell-gateway  is required;
has @.storage-cells is required;
has $.log-days      = 1; #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
has %.List;

submethod TWEAK {
    my %ah-dt-cache;
    my $ah-dt-cache = Our::Cache.new(:identifier(ALERTHISTORY-DATETIMES-CI), :subdirs($*PROGRAM-NAME.IO.basename, ALERTHISTORY-DATETIMES-CI));

    if ! $!log-days && $ah-dt-cache.cache-hit {
        %ah-dt-cache        = from-json($ah-dt-cache.fetch) or note $?LINE;
        for %ah-dt-cache.keys.sort -> $storage-cell {
            %ah-dt-cache{$storage-cell} = DateTime.new: %ah-dt-cache{$storage-cell};
        }
    }
    else {
        my $first-log       = now - (365 * 24 * 60 * 60);
        $first-log          = now - ($!log-days * 24 * 60 * 60) if $!log-days;
        my $first-dt        = DateTime.new(:timezone($*TZ), $first-log).truncated-to('second');
        for @!storage-cells -> $storage-cell {
            %ah-dt-cache{$storage-cell} = $first-dt.clone;
        }
        $ah-dt-cache.store(:data(to-json(%ah-dt-cache)));
    }

    my %command;
    for @!storage-cells -> $storage-cell {
        %command{$storage-cell} =   'ssh',
                                    $storage-cell,
                                    'sudo',
                                    '-n',
                                    '/usr/bin/dbmcli',
                                    '-n',
                                    '-m',
                                    '-e',
                                    'list',
                                    'alerthistory',
                                    'WHERE',
                                    'begintime',
                                    '\\>',
                                    "\\'" ~ %ah-dt-cache{$storage-cell}.Str ~ "\\'",
                                    ;
put %command{$storage-cell};
    }

    my %results                     = Async::Command::Multi.new(:%command).sow.reap;
    for %results.keys.sort -> $storage-cell {
        my $actions                 = ZDLRA::Common::AlertHistory::List::Actions.new;
        %!List{$storage-cell}       = ZDLRA::Common::AlertHistory::List::Grammar.parse(%results{$storage-cell}.stdout-results, :$actions).made;
put %!List{$storage-cell}.elems;
note '$ah-dt-cache.store(:data(to-json(%ah-dt-cache)));';
    }
}

#-------------------------------------------------------------------------------
#   for %inventory.keys -> $dbm {
#       for %inventory{$dbm}<CELLS>.keys.sort -> $cell {
#           ALERTHISTORY-GRAMMAR.parse(%alerthistory{$cell}.stdout-results, :actions(ALERTHISTORY-ACTIONS.new(:$dbm, :$cell)));
#       }
#   }
#   $ah-dt-cache.store(:data(to-json(%ah-dt-cache)));

#-------------------------------------------------------------------------------
