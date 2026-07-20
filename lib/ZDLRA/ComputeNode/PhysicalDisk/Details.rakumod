unit        class ZDLRA::ComputeNode::PhysicalDisk::Details:api<1>:auth<Mark Devine (mark@markdevine.com)>;

use         ZDLRA::ComputeNode::PhysicalDisk::Details::Actions;
use         ZDLRA::ComputeNode::PhysicalDisk::Details::Grammar;
use         Async::Command::Multi;

use         Data::Dump::Tree;
use         Grammar::Debugger;
#use        Grammar::Tracer;

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
        my $actions                 = ZDLRA::ComputeNode::PhysicalDisk::Details::Actions.new;
        %!Details{$compute-node}    = ZDLRA::ComputeNode::PhysicalDisk::Details::Grammar.parse(%results{$compute-node}.stdout-results, :$actions).made;
    }
}

=finish
