#!/usr/bin/env perl

=head1 NAME

sidearm.pl - your weapon for virus discovery in the NCBI SRA database

=head1 SYNOPSIS

sidearm.pl [optional] required

 Required:
   -d|sidearmdir DIR    The SIDEARM installation directory
   -s|srr SRR           SRA accession number (SRR073726, ERR.., DRR..)
   -b|blastdb NAME      BLAST database of the reference sequences
   -r|refsfile FILE     Fasta file of the reference sequences

 Optional:
   -t|threads INT       Number of threads (default: 2)
   -g|fiveprime STRING [-g ...]
                        Adapter list for 5' end
   -a|threeprime STRING [-a ...]
                        Adapter list for 3' end
   -h|help              Full documentation
   -t|test              Test but don't execute anything
   -h|help             	Full documentation

=head1 OPTIONS

=over 4

=item B<-s|sidearmdir>

    The directory where SIDEARM was installed. This can be a relative or
    absolute path.

=item B<-help>

    Print full documentation and exits.

=back

=head1 DESCRIPTION

B<This program> will...

=head1 REQUIREMENTS

=over 4

=item foo

=back

=cut

#
# Let the coding begin....
#
use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;
use File::Basename;

my ($sidearmdir, $srr, $blastdb, $refsfile);
my $threads = 2;
my $format = 'fasta';
my $nopaired = 1;
my $accver = 1;
my @prime5; my @prime3;
my ($help, $test) = (0, 0);
my $yml = "";
GetOptions ("sidearmdir|d=s" => \$sidearmdir,
            "srr|s=s"        => \$srr,
            "blastdb|b=s"    => \$blastdb,
            "refsfile|r=s"   => \$refsfile,
            "threads|t=i"    => \$threads,
            "fiveprime|g=s"  => \@prime5,
            "threeprime|a=s" => \@prime3,
            "help|h"         => \$help,
            "test|t"         => \$test,
            "yml|y"          => \$yml,
            ) || pod2usage (-verbose => 0);
pod2usage(-verbose => 2) if ($help);
pod2usage(-verbose => 1) if (!$sidearmdir || !$srr || !$blastdb || !$refsfile);

my $cwldir = "/cwl/tools/";
my $workflow = "workflow.cwl";
my $workflowpath = $sidearmdir . $cwldir . $workflow;
if (! -e $workflowpath || ! -e $refsfile) {
  #die "$workflow not found in ${sidearmdir}${cwldir}\n";
  pod2usage(-verbose => 1);
}

#
# build YML file
#
$yml = "sidearm.$srr.yml";
open (my $out, ">", $yml) or die ("Can't open $yml for writing: $!\n");

$nopaired = ($nopaired) ? 'true' : 'false';
$accver = ($accver) ? 'true' : 'false';

my $toPrint = <<TOPRINT;
# align
srr: $srr
blastdb: $blastdb
threads: $threads

# bam2seqs
format: $format
nopaired: $nopaired

# summ
accver: $nopaired
genomefile:
  class: File
  path: $refsfile

# # trim
# prime5: GCTCCTTTTTCTTTTTT
# prime3: CCCCCCCCCCCCCCC

TOPRINT
print $out $toPrint;
close ($yml);

#
# execute SIDEARM
#
my $command = "$workflowpath $yml";
print "Command to execute: $command\n";
`time $command` unless ($test);

exit 0;



