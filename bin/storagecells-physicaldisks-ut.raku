#!/usr/bin/env raku

use lib $*HOME ~ '/github.com/ZDLRA/lib';
use ZDLRA::StorageCell::PhysicalDisk::Details;
use lib '/home/mdevine/github.com/raku-Our-KV/lib';
use Our::KV;

use Data::Dump::Tree;

my $kv-server               = Our::KV.new(:kv-cli('/usr/bin/redis-cli'), :local-port-forward);
my @parent-keys             = $kv-server.KEYS(:key('eb:zdlra:dbm:*'));
die "No ZDLRA dbm keys!"    unless @parent-keys;

my @cellcli-gateways;
for @parent-keys -> $key {
    @cellcli-gateways.push: ($kv-server.LRANGE(:$key, :0begin, :100end).sort)[0];
}
@cellcli-gateways          .= sort;

#my %ZDLRA;
#for @cellcli-gateways -> $cellcli-gateway {
#    %ZDLRA{$cellcli-gateway} = $kv-server.SMEMBERS(:key("eb:zdlra:{$cellcli-gateway}:storagecells"));
#}

my $d               = ZDLRA::StorageCell::PhysicalDisk::Details.new(:@cellcli-gateways);

put 'dumping...';
ddt $d;
=finish

for $d.Details.keys.sort -> $sn {
    put $sn;
    for $d.Details{$cn} -> $rcds {
        for $rcds.list -> $rcd {
            put "\t" ~ $rcd.name ~ "\t" ~ $rcd.status;
        }
    }
}
