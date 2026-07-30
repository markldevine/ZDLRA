unit class ZDLRA::ComputeNode::AlertHistory::List:api<1>:auth<Mark Devine (mark@markdevine.com)>;

use             ZDLRA::Common::AlertHistory::List::Actions;
use             ZDLRA::Common::AlertHistory::List::Grammar;
use             ZDLRA::Common::AlertHistory::List::Record;
use             Async::Command::Multi;
use             Our::Cache;

constant        ALERTHISTORY-DATETIMES-CI  = 'COMPUTENODE_ALERTHISTORY_LIST';

has             @.compute-nodes is required;
has DateTime    $.begin-datetime    is required;
has             %.List;

submethod TWEAK {
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
                                    "\\'" ~ $!begin-datetime.Str ~ "\\'",
                                    ;
    }
    my %results                     = Async::Command::Multi.new(:%command).sow.reap;
    for %results.keys.sort -> $compute-node {
        my $actions                 = ZDLRA::Common::AlertHistory::List::Actions.new;
        %!List{$compute-node}       = ZDLRA::Common::AlertHistory::List::Grammar.parse(%results{$compute-node}.stdout-results, :$actions).made;
    }
}

=finish
