#!/usr/bin/env perl
use strict;
use warnings;
use Getopt::Long;
use File::Basename;

my $fasta;
GetOptions ("fasta|f=s" => \$fasta,
            );
die "Usage: $0 -f FASTAFILE" if (!$fasta);

my $filename = basename($fasta);
my $outputfile = "$filename.contigs";
my $logfile    = "$filename.abyss.out";
my $command = "ABYSS -k 25 -o $outputfile $fasta > $logfile 2>&1";
print "Running command: $command\n";
`time $command`;

exit 0;

