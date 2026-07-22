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
        %!List{$compute-node}    = ZDLRA::Common::AlertHistory::List::Grammar.parse(%results{$compute-node}.stdout-results, :$actions).made;
    }
}

=finish
