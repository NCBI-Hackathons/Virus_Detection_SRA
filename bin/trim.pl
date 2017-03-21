#!/usr/bin/env perl
use warnings;
use strict;
use Getopt::Long;

=head

preprocess_ncores.sh "$TEMP_IN" "$ADAPTERSET" S 15 60 30 "$THREADS"
$scriptname <FASTQfile> <adapter_set> <S/I quality> <quality_cutoff> <entropy_cutoff> <length cutoff; 0 for no length cutoff> <# of cores>"

preprocess.sh
$scriptname <FASTQfile> <adapter_set> <S/I quality> <quality_cutoff> <entropy_cutoff> <length_cutoff; 0 for no length_cutoff>"
             inputfile  adapter_set     quality
cutadapt_quality.sh "$inputfile" "$quality" "$adapter_set"
cutadapt_quality.csh <FASTQfile> <quality S/I> <adapter_set>"

#    Illumina Adapter 1 (-a seq based on Illumina bulletin; using -g revcom similar to Surpi)
#             Adapter 2 (-a seq based on Illumina bulletin; using -a revcom exactly like Surpi)
echo "Trimming Primer B + Primer K pubmed 22855479 + Illumina TruSeq adapters"
cutadapt
-g GTTTCCCAGTCACGATA    -a TATCGTGACTGGGAAAC \
         -g GACCATCTAGCGACCTCCAC -a GTGGAGGTCGCTAGATGGTC \


          -o "${inputfile%.*}".cutadapt.fastq $inputfile
elif [[ $adapter_set = prepx ]]; then


-x ADAPTER ... (5' end) -> '-g'
-y ADAPTER ... (3' end -> '-a'

-g GCTCCTTTTTCTTTTTT,TCGGGGGGGGTTTTT -a CCCCCCCCCCCCCCC,GGGGGGGGGGGGGGGGG

=cut

#reads; NO SUPPORT FOR PAIRED READS

my @prime5 = qw/TGACTGGAGTTCAGACGTGTGCTCTTCCGATCT/;
my @prime3 = qw/AGATCGGAAGAGCACACGTCTGAACTCCAGTCA
                AATGATACGGCGACCACCGAGATCTACACTCTTTCCCTACACGACGCTCTTCCGATC
                AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT
                /;
my $minlen = 30;
my $rmdefadapters = 0;   # not implemented
my $outputfile;
GetOptions("fiveprime|g=s"    => \@prime5,
           "threeprime|a=s"   => \@prime3,
           "minlen|m=i"        => \$minlen,
           "rm-def-adapters|r" => \$rmdefadapters,
           "outputfile|o=s"    => \$outputfile,
           );

my $usage = <<USAGE;
$0 [options] FASTAFILE
  OPTIONS
    -g    Adapter list for 5' end ( -g ADAPTER1 ... )
    -a    Adapter list for 3' end ( -a ADAPTER2 ... )
    -o    Output file (default: your input sequence file name with ".cutadapt.fa" appended)
    -m    Minimum length cutoff after trimming (default: 50)
    -r    NOT SUPPORTED. If supplied, default adapters (TruSeq) will be removed and not searched for.
USAGE

my $seqs = shift;
die $usage if (!$seqs);

# build cutadapt command line
my @tmp;
my $fiveprime = "";
foreach (@prime5) {
  push (@tmp, "-g $_");
}
$fiveprime = join (" ", @tmp);

@tmp = ();
my $threeprime = "";
foreach (@prime3) {
  push (@tmp, "-a $_");
}
$threeprime = join (" ", @tmp);

$outputfile //= "$seqs.cutadapt.fa";

my $command = "cutadapt $fiveprime $threeprime -m $minlen -o $outputfile $seqs > $seqs.cutadapt.out 2>&1";
print "Running command: $command\n";
`time $command`;

exit 0;

