#!/usr/bin/env perl
use strict;
use warnings;
use Getopt::Long;

my $nopaired = 0;
my $format   = "fastq";
my $prefix   = "foo";         # foo_1.fq, foo_2.fq, foo.fq
my $bamfile = "";
my $dir = ".";
GetOptions("t=s" => \$format,
           "prefix=s" => \$prefix,
           "nopaired" => \$nopaired,
           "bamfile|b=s" => \$bamfile,
           "directory|d=s" => \$dir,
          );

die "Please supply a bamfile (-b)\n" if (!$bamfile);

my %preads;   # cache reads until you have both reads of a pair so you can output them in order
my ($one, $two, $single);
my $suffix = ($format eq "fastq") ? ".fq" : ".fa";

unless ($nopaired) {
  open ($one, ">", $dir . "/" . $prefix . "_1" . $suffix) or die "";
  open ($two, ">", $dir . "/" . $prefix . "_2" . $suffix) or die "";
}
open ($single, ">", $dir . "/" . $prefix . $suffix) or die "";

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
