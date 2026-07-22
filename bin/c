#!/usr/bin/env raku

use lib $*HOME ~ '/github.com/ZDLRA/lib';
use ZDLRA::ComputeNode::PhysicalDisk::Details;
use lib '/home/mdevine/github.com/raku-Our-KV/lib';
use Our::KV;

use Data::Dump::Tree;

my $kv-server               = Our::KV.new(:kv-cli('/usr/bin/redis-cli'), :local-port-forward);
my @parent-keys             = $kv-server.KEYS(:key('eb:zdlra:dbm:*'));
die "No ZDLRA dbm keys!" unless @parent-keys;

my @compute-nodes;
for @parent-keys -> $key {
    my @vs                  = $kv-server.LRANGE(:$key, :0begin, :100end).sort;
    @compute-nodes.append:  @vs;
}
@compute-nodes             .= sort;

my $d               = ZDLRA::ComputeNode::PhysicalDisk::Details.new(:@compute-nodes);

for $d.Details.keys.sort -> $cn {
    put $cn;
    for $d.Details{$cn} -> $rcds {
        for $rcds.list -> $rcd {
            put "\t" ~ $rcd.name ~ "\t" ~ $rcd.status;
        }
    }
}
