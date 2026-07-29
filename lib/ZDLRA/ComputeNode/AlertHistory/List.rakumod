unit        class ZDLRA::ComputeNode::AlertHistory::List:api<1>:auth<Mark Devine (mark@markdevine.com)>;

#   dbmcli -n -m -e list alerthistory

use         JSON::Fast;

use Data::Dump::Tree;

use         ZDLRA::Common::AlertHistory::List::Actions;
use         ZDLRA::Common::AlertHistory::List::Grammar;
use         ZDLRA::Common::AlertHistory::List::Record;
use         Async::Command::Multi;
use         Our::Cache;

constant ALERTHISTORY-DATETIMES-CI  = 'COMPUTENODE_ALERTHISTORY_LIST';

has @.compute-nodes is required;
has $.log-days      = 1; #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
has %.List;

submethod TWEAK {
    my %ah-dt-cache;
    my $ah-dt-cache = Our::Cache.new(:identifier(ALERTHISTORY-DATETIMES-CI), :subdirs($*PROGRAM-NAME.IO.basename, ALERTHISTORY-DATETIMES-CI));

    if ! $!log-days && $ah-dt-cache.cache-hit {
        %ah-dt-cache        = from-json($ah-dt-cache.fetch) or note $?LINE;
        for %ah-dt-cache.keys.sort -> $compute-node {
            %ah-dt-cache{$compute-node} = DateTime.new: %ah-dt-cache{$compute-node};
        }
    }
    else {
        my $first-log       = now - (365 * 24 * 60 * 60);
        $first-log          = now - ($!log-days * 24 * 60 * 60) if $!log-days;
        my $first-dt        = DateTime.new(:timezone($*TZ), $first-log).truncated-to('second');
        for @!compute-nodes -> $compute-node {
            %ah-dt-cache{$compute-node} = $first-dt.clone;
        }
        $ah-dt-cache.store(:data(to-json(%ah-dt-cache)));
    }

    my %command;
    for @!compute-nodes -> $compute-node {
        %command{$compute-node} =   'ssh',
                                    $compute-node,
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
                                    "\\'" ~ %ah-dt-cache{$compute-node}.Str ~ "\\'",
                                    ;
put %command{$compute-node};
    }

    my %results                     = Async::Command::Multi.new(:%command).sow.reap;
    for %results.keys.sort -> $compute-node {
        my $actions                 = ZDLRA::Common::AlertHistory::List::Actions.new;
        %!List{$compute-node}       = ZDLRA::Common::AlertHistory::List::Grammar.parse(%results{$compute-node}.stdout-results, :$actions).made;
put %!List{$compute-node}.elems;
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
