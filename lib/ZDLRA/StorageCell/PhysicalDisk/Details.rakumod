unit        class ZDLRA::StorageCell::PhysicalDisk::Details:api<1>:auth<Mark Devine (mark@markdevine.com)>;

use         ZDLRA::Common::PhysicalDisk::Details::Actions;
use         ZDLRA::Common::PhysicalDisk::Details::Grammar;
use         ZDLRA::Common::PhysicalDisk::Details::Record;
use         Async::Command::Multi;

use Data::Dump::Tree;

has @.cellcli-gateways              is required;
has %.Details;

submethod TWEAK {
    my %command;
    my %results;
    for @!cellcli-gateways -> $cellcli-gateway {
        %command{$cellcli-gateway}  = 'ssh', $cellcli-gateway, 'sudo', 'dcli', '-l', 'root', '-g', '/root/cell_group', "\'cellcli -e list physicaldisk detail\'";
    }
    %results                        = Async::Command::Multi.new(:%command).sow.reap;
    for %results.keys.sort -> $cellcli-gateway {
        my %storagecell-details;
        for %results{$cellcli-gateway}.stdout-results.lines -> $record {
            my @fields              = $record.trim.split(/\s+/);
            my $storage-cell        = @fields[0].ends-with(':') ?? @fields[0].chop(1) !! @fields[0];
            if @fields[1] {
                %storagecell-details{$storage-cell} ~= (' ' ~ @fields[1..*] ~ "\n");
            }
            else {
                %storagecell-details{$storage-cell} ~= "\n";
            }
        }
        for %storagecell-details.keys.sort -> $storage-cell {
            my $actions             = ZDLRA::Common::PhysicalDisk::Details::Actions.new;
put %storagecell-details{$storage-cell};
            die $storage-cell ~ ' parse failed!'
                unless %!Details{$storage-cell} = ZDLRA::Common::PhysicalDisk::Details::Grammar.parse(%storagecell-details{$storage-cell}, :$actions).made;
        }
    }
ddt %!Details;
}

=finish
