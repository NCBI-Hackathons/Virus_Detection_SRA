#!/usr/bin/env perl
# use this script for both the strict (default) alignments to referneces as well as the weaker alignments to non-degenrate set of seqs
use strict;
use warnings;
use Getopt::Long;
use File::Basename; # core

my ($srr, $blastdb) = ("", "");

# magicblast defaults
# for lower percent identity:
#   gapextend: 8 => 4
#   penalty: -8 => -4
# for faster alignments:
#   wordsize: 16 => 20
#   score: 20 => 24
my ($gapextend, $penalty, $wordsize, $score); # #(4, -4, 20, 24);
my $fast = 0;
my $weak = 0;
my $threads = 2;
GetOptions ("srr|s=s"  => \$srr,
            "blastdb|b=s" => \$blastdb,
            "fast"          => \$fast,
            "weak"          => \$weak,
            "gapextend|g=i" => \$gapextend,
            "penalty|p=i" => \$penalty,
            "wordsize|w=i" => \$wordsize,
            "score|c=i" => \$score,
            "threads|t=i" => \$threads,
            );
if ($fast) {
  $wordsize = 20;
  $score = 24;
}

if ($weak) {
  $gapextend = 4;
  $penalty = -4;
}

my $usage = <<USAGE;
$0 [-g|-p|-w|-c] -d -s SRR -b BLASTDB

      REQUIRED:
      -s|srr        SRR accession number (can be DRR or ERR)
      -b|blastdb    Blast database name of reference sequences. Can include degenerate nucleotide sequences

      OPTIONAL:
      -g|gapextend  default: 4  (magicblast default is 8)
      -p|penalty    default: -4 (magicblast default is -8)
      -w|wordsize   default: 20 (magicblast default is 16)
      -c|score      default: 24 (magicblast default is 20)

DESCRIPTION:
When you create Blast database of your sequences, make sure to use the '-parse_seqids' option to preserve the sequence identifiers (see 'makeblastdb -help')

USAGE

die $usage if (!$srr || !$blastdb);

my $magicblast = "magicblast";
system ("which $magicblast > /dev/null");
if ($? > 0) {
  print "$magicblast not found...please install magicblast\n\n";
  exit;
}

my $makeblastdb = "makeblastdb";
system ("which $makeblastdb > /dev/null");
if ($? > 0) {
  print "$makeblastdb not found...please install magicblast\n\n";
  exit;
}

my $filename = basename($blastdb);
my $bamfile = "$srr.$filename.bam";
my $command = "$magicblast -db $blastdb -sra $srr -num_threads $threads | samtools view -bS - | samtools sort -o $bamfile";

print "Running command: $command\n";
`time $command`;

exit 0;
