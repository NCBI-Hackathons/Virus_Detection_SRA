#!/usr/bin/env perl
use strict;
use warnings;
use Getopt::Long;
use File::Basename;

my $nopaired = 0;
my $format   = "fastq";
my $bamfile = "";
GetOptions("format|f=s" => \$format,
           "nopaired" => \$nopaired,
           "bamfile|b=s" => \$bamfile,
          );

die "Please supply a bamfile (-b)\n" if (!$bamfile);

my %preads;   # cache reads until you have both reads of a pair so you can output them in order
my ($one, $two, $single);
my $suffix = ($format eq "fastq") ? ".fq" : ".fa";

my $filename = basename($bamfile);
unless ($nopaired) {
  open ($one, ">", $filename . "_1" . $suffix) or die "";
  open ($two, ">", $filename . "_2" . $suffix) or die "";
}
open ($single, ">", $filename . $suffix) or die "";

open(my $in, "samtools view $bamfile | ");
while (<$in>) {
   next if /^@/;
   chomp;
   my ($id, $flag, $rname, $seq, $qual) = (split /\t/, $_)[0,1,2,9,10];

   if ($flag & 16) {
      $seq = reverse($seq);
      $seq =~ tr/[ACGTacgt]/[TGCAtgca]/;
      $qual = reverse($qual);
   }

   my $toPrint = ($format eq "fastq") ? join("","@",$id,"\n",$seq,"\n","+","\n",$qual,"\n") : join("",">",$id,"\n",$seq,"\n");

   if ($nopaired) {
     print $single $toPrint;
   }
   else {    # paired
     if ($flag & 64) {
        $preads{$id}{1} = $toPrint;
     }
     elsif ($flag & 128) {
        $preads{$id}{2} = $toPrint;
     }
     else {
        print $single $toPrint;
     }

     if ($preads{$id}{1} && $preads{$id}{2}) {
        print $one $preads{$id}{1};
        print $two $preads{$id}{2};
        delete $preads{$id};
     }
   }

}
close ($in);

unless ($nopaired) {
  # for all the paired reads that didn't have a mate in the BAM file, need to
  # print the remaining singletons
  foreach my $id (keys %preads) {
    foreach (keys %{$preads{$id}}) {
       print $single $preads{$id}{$_};
    }
  }
}

exit 0;
