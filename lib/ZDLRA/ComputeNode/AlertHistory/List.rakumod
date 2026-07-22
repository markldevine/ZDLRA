unit        class ZDLRA::ComputeNode::AlertHistory::List:api<1>:auth<Mark Devine (mark@markdevine.com)>;

use         ZDLRA::Common::AlertHistory::List::Actions;
use         ZDLRA::Common::AlertHistory::List::Grammar;
use         ZDLRA::Common::AlertHistory::List::Record;
use         Async::Command::Multi;

has @.compute-nodes             is required;
has %.List;

submethod TWEAK {
    my %command;
    my %results;

#-------------------------------------------------------------------------------
    my $identifier          = 'alerthistory_datetimes';
    my $ah-dt-cache         = Our::Cache.new(:$identifier);

    if ! $log-days && $ah-dt-cache.cache-hit {
        %ah-dt-cache        = from-json($ah-dt-cache.fetch) or note $?LINE;
        for %ah-dt-cache.keys.sort -> $dbm {
            for %ah-dt-cache{$dbm}.keys.sort -> $cell {
                %ah-dt-cache{$dbm}{$cell} = DateTime.new: %ah-dt-cache{$dbm}{$cell};
            }
        }
    }
    else {
        my $first-log       = now - (365 * 24 * 60 * 60);
        $first-log          = now - ($log-days * 24 * 60 * 60) if $log-days;
        my $first-dt        = DateTime.new(:timezone($*TZ), $first-log).truncated-to('second');
        for %inventory.keys.sort -> $dbm {
            for %inventory{$dbm}<CELLS>.keys.sort -> $cell {
                %ah-dt-cache{$dbm}{$cell} = $first-dt.clone;
            }
        }
        $ah-dt-cache.store(:data(to-json(%ah-dt-cache)));
    }
#-------------------------------------------------------------------------------

    for @!compute-nodes -> $compute-node {
        %command{$compute-node} =   'ssh',
                                    $compute-node,
                                    'sudo',

#%%%    Must pre-calculate the %ah-dt-cache...

                                    Q/"cellcli -e list alerthistory WHERE begintime \\> \\'/ ~ %ah-dt-cache{$compute-node}.Str ~ Q/\\'"/,
                                    ;





    }
    %results                        = Async::Command::Multi.new(:%command).sow.reap;
    for %results.keys.sort -> $compute-node {
        my $actions                 = ZDLRA::Common::AlertHistory::List::Actions.new;
        %!List{$compute-node}       = ZDLRA::Common::AlertHistory::List::Grammar.parse(%results{$compute-node}.stdout-results, :$actions).made;
    }

#-------------------------------------------------------------------------------
    for %inventory.keys -> $dbm {
        for %inventory{$dbm}<CELLS>.keys.sort -> $cell {
            ALERTHISTORY-GRAMMAR.parse(%alerthistory{$cell}.stdout-results, :actions(ALERTHISTORY-ACTIONS.new(:$dbm, :$cell)));
        }
    }
    $ah-dt-cache.store(:data(to-json(%ah-dt-cache)));

#-------------------------------------------------------------------------------

}

=finish


