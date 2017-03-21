#!/usr/bin/env perl
use strict;
use warnings;
use Getopt::Long;
use Cwd;

my $fasta;
my $dir = getcwd;
GetOptions ("fasta|f=s" => \$fasta,
            "directory|d=s" => \$dir,
            );

die "Usage: $0 -f FASTAFILE" if (!$fasta);

my $outputfile = "$dir/$fasta.contigs";
my $logfile    = "$dir/$fasta.abyss.out";
my $command = "ABYSS -k 25 -o $outputfile $fasta > $logfile 2>&1";
print "Running command: $command\n";
`time $command`;

exit 0;

