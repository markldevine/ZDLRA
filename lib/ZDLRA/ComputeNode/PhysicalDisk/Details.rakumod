unit        class ZDLRA::ComputeNode::PhysicalDisk::Details:api<1>:auth<Mark Devine (mark@markdevine.com)>;

use         ZDLRA::Common::PhysicalDisk::Details::Actions;
use         ZDLRA::Common::PhysicalDisk::Details::Grammar;
use         ZDLRA::Common::PhysicalDisk::Details::Record;
use         Async::Command::Multi;

constant    NUMBER-OF-DISKS-IN-COMPUTE-NODE = 4;

has @.compute-nodes             is required;
has %.Details;

submethod TWEAK {
    my %command;
    my %results;
    for @!compute-nodes -> $compute-node {
        %command{$compute-node}     = 'ssh', $compute-node, 'sudo', 'dbmcli', '-e', 'list', 'physicaldisk', 'detail';
    }
    %results                        = Async::Command::Multi.new(:%command).sow.reap;
    for %results.keys.sort -> $compute-node {
        my $actions                 = ZDLRA::Common::PhysicalDisk::Details::Actions.new;
        %!Details{$compute-node}    = ZDLRA::Common::PhysicalDisk::Details::Grammar.parse(%results{$compute-node}.stdout-results, :$actions).made;
        note $compute-node ~ ' parse returned ' ~ %!Details{$compute-node}.elems ~ ' elements, not ' ~ NUMBER-OF-DISKS-IN-COMPUTE-NODE ~ '!'
            unless %!Details{$compute-node}.elems == NUMBER-OF-DISKS-IN-COMPUTE-NODE;
    }
}

=finish
