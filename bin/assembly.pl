#!/usr/bin/env perl
use strict;
use warnings;
use Getopt::Long;
use File::Basename;

my $fasta;
my $dir = ".";
GetOptions ("fasta|f=s" => \$fasta,
            "directory|d=s" => \$dir,
            );

die "Usage: $0 -f FASTAFILE" if (!$fasta);

my $filename = basename($fasta);
my $outputfile = "$dir/$filename.contigs";
my $logfile    = "$dir/$filename.abyss.out";
my $command = "ABYSS -k 25 -o $outputfile $fasta > $logfile 2>&1";
print "Running command: $command\n";
`time $command`;

exit 0;

