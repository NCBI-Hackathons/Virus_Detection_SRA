#!/usr/bin/env perl
use strict;
use warnings;

my $fasta = shift;

die "Usage: $0 FASTAFILE" if (!$fasta);
my $command = "ABYSS -k 25 -o $fasta.contigs $fasta > $fasta.abyss.out 2>&1";

print "Running command: $command\n";
`time $command`;

exit 0;

