#!/usr/bin/env raku

use Async::Command::Multi;
use Data::Dump::Tree;
use Our::Cache;
use JSON::Fast;
use Data::Dump::Tree;

use lib '/home/mdevine/github.com/raku-Our-KV/lib';
use Our::KV;

use lib $*HOME ~ '/github.com/ZDLRA/lib';
use ZDLRA::ComputeNode::PhysicalDisk::Details;
use ZDLRA::StorageCell::PhysicalDisk::Details;

my @cellcli-gateways;
my %inventory;
my %ah-dt-cache;
my %status;
my %command;
my $id-prefix               = 'DateTime-Last-alerthistory-Record';

my $kv-server               = Our::KV.new(:kv-cli('/usr/bin/redis-cli'), :local-port-forward);
my @parent-keys             = $kv-server.KEYS(:key('eb:zdlra:dbm:*'));
die "No ZDLRA dbm keys!" unless @parent-keys;

my @compute-nodes;
for @parent-keys -> $key {
    my @vs                  = $kv-server.LRANGE(:$key, :0begin, :100end).sort;
    @cellcli-gateways.push: @vs[0];
    @compute-nodes.append:  @vs;
}
@compute-nodes             .= sort;
my %ZDLRA;

for @cellcli-gateways.sort -> $cellcli-gateway {
    %ZDLRA{$cellcli-gateway}.push: $kv-server.SMEMBERS(:key("eb:zdlra:{$cellcli-gateway}:storagecells"));
}

sub MAIN (
    Int   :$log-days        = 0,               #= log days to display (bypass "only unseen logs" mechanism)
) {
    %command                = ();

################################################################################
### ComputeNode PhysicalDisk Detail Check                                    ###
################################################################################

    $                       = ZDLRA::StorageCell::PhysicalDisk::Details.new(:@cellcli-gateways);

}

=finish

################################################################################
### StorageCell PhysicalDisk Detail Check                                    ###
################################################################################

    for @cellcli-hosts -> $dbm {
        %command{$dbm}      = 'ssh', $dbm, 'sudo', 'dcli', '-l', 'root', '-g', '/root/cell_group', '"cellcli -e list physicaldisk"';
    }

    my %physicaldisk        = Async::Command::Multi.new(:%command).sow.reap;

    for %physicaldisk.keys.sort -> $dbm {
        for %physicaldisk{$dbm}.stdout-results.lines -> $record {
            my @fields      = $record.trim.split(/\s+/);
            my $cell        = @fields[0].ends-with(':') ?? @fields[0].chop(1) !! @fields[0];
            %inventory{$dbm}<CELLS>{$cell} = '';
            %status{$dbm}<PHYSICALDISK>{$cell}.push: PHYSICALDISK_RECORD.new:
                :name(@fields[1]),
                :serial(@fields[2]),
                :status(@fields[3..*].join(' '));
        }
    }

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

    %command                = ();
    for %inventory.keys -> $dbm {
        for %inventory{$dbm}<CELLS>.keys.sort -> $cell {
            %command{$cell} = (
                                'ssh',
                                $dbm,
                                'sudo',
                                'ssh',
                                $cell,
                                Q/"cellcli -e list alerthistory WHERE begintime \\> \\'/ ~ %ah-dt-cache{$dbm}{$cell}.Str ~ Q/\\'"/,
                            );
        }
    }

    my %alerthistory        = Async::Command::Multi.new(:%command).sow.reap;

    for %inventory.keys -> $dbm {
        for %inventory{$dbm}<CELLS>.keys.sort -> $cell {
            ALERTHISTORY-GRAMMAR.parse(%alerthistory{$cell}.stdout-results, :actions(ALERTHISTORY-ACTIONS.new(:$dbm, :$cell)));
        }
    }
    $ah-dt-cache.store(:data(to-json(%ah-dt-cache)));

    for %inventory.keys -> $dbm {
        put $dbm;
        for %inventory{$dbm}<CELLS>.keys.sort -> $cell {
            put "\t" ~ $cell;
            for %status{$dbm}<PHYSICALDISK>{$cell}.list -> $pd {
                printf "\t\t%s\t%s [%s]\n", $pd.status, $pd.name, $pd.serial if $pd.status ne 'normal';
            }
            if (%status{$dbm}<ALERTHISTORY>:exists) && (%status{$dbm}<ALERTHISTORY>{$cell}:exists) {
                for %status{$dbm}<ALERTHISTORY>{$cell}.list -> $logrcd {
                    printf "\t\t%s %s %s\n", $logrcd.datetime, $logrcd.severity, $logrcd.message;
                }
            }
        }
    }
}

=finish
