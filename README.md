# SIDEARM	- Your weapon for viral discovery in metagenomes

Sidearm searches the SRA database for viruses using the NCBI magicBLAST tool. It generates a table describing the number of alignments to each virus and various metrics such as the sequence coverage and average depth. The reads aligning to virus are assembled into viral contigs to attempt to generate complete viral genomes.

## Workflow

Module 1: Viral RefSeq MagicBLASTer

Module 1a: Defaut (strict) Parameters (Known Viruses)

+ Get viral RefSeq, makeblastdb, initiate magicBLAST[SRR073726](https://www.ncbi.nlm.nih.gov/sra/?term=SRR073726) RNA-seq prostate cancer cellline contains HPV18

```bash
wget ftp://ftp.ncbi.nlm.nih.gov/refseq/release/viral/viral.1.1.genomic.fna.gz
gunzip viral.1.1.genomic.fna.gz
makeblastdb -dbtype nucl -in viral.1.1.genomic.fna -out viral.1.1.genomic -parse_seqids  # 3 seconds
```

+ [align_SRR_to_references.pl](https://github.com/NCBI-Hackathons/Virus_Detection_SRA/blob/master/bin/align_SRR_to_references.pl)

```bash
align_SRR_to_references.pl -b viral.1.1.genomic -s SRR073726 &
```

```perl
my $command = "$magicblast -db $blastdb -sra $srr -num_threads $threads -gapextend $gapextend -penalty $penalty -word_size $wordsize -score $score > $samfile";
```

*Module 1b: Loose Parameters (New Viruses)*

+ to obtain lower % id alignments, lower gapextend and penalty options (Greg)

*Module 1c: Using a local database*

+ makeblastdb, initiate magicBLASTer
+ option to append to RefSeq

*Module 1d: Using a local protein database*

+ From isolated proteins
+ From conserved domains

Module 2: Extract reads from samfiles

+ [bam2seqs.pl](https://github.com/NCBI-Hackathons/Virus_Detection_SRA/blob/master/bin/bam2seqs.pl)
+ using '--nopaired' option since paired end reads are not supported yet

```bash
bam2seqs.pl -t fasta --nopaired --prefix SRR073726 -b SRR073726.viral.1.1.genomic.bam
```

```perl
     if ($flag & 64) {
        $preads{$id}{1} = $toPrint;
     }
     elsif ($flag & 128) {
        $preads{$id}{2} = $toPrint;
     }
     else {
        print $single $toPrint;
     }
```

Module 3: Generate report from step 1

+ [summarize_bam_by_ref.pl](https://github.com/NCBI-Hackathons/Virus_Detection_SRA/blob/master/bin/summarize_bam_by_ref.pl)
+ using the '-v' option to only use the accession.version identifier in Viral.genomic.fna when looking for reference sequence identifier matches in the SAM file

```bash
summarize_bam_by_ref.pl -v -f SRR073726.viral.1.1.genomic.bam -g viral.1.1.genomic.fna
```

```perl
    my $avgdepth = $ref{$rid}{td} / $rlen;          # average depth per base for reference    
    my $upos = $ref{$rid}{tp};
    my $seqcov   = $upos / $rlen * 100;    # percent of reference length that is covered by at least one read

    my $nalign  = $ref{$rid}{nalign};
    my $avgmapq = $ref{$rid}{mapq}/$nalign;
```

Module 4a: Adapter Trimming using cut adapt

+ Usage: User defines adapters (also uses default set of Illumina TruSeq adapters)
+ [trim.pl](https://github.com/NCBI-Hackathons/Virus_Detection_SRA/blob/master/bin/trim.pl)

```bash
trim.pl -g GCTCCTTTTTCTTTTTT -a CCCCCCCCCCCCCCC -f SRR073726.fa
```

*Module 4b: Adapter Prediction and Trimming using tag cleaner*

+ Usage: No need to define adapters

Module 5: Contig assembly with Abyss2

+ [assembly.pl](https://github.com/NCBI-Hackathons/Virus_Detection_SRA/blob/master/bin/assembly.pl)

```bash
assembly.pl -f SRR073726.fa.cutadapt.fa
```

```perl
my $command = "ABYSS -k 25 -o $fasta.contigs $fasta > $fasta.abyss.out 2>&1";
`$command`;
```

+ Resulting output file is ```SRR073726.fa.cutadapt.fa.contigs```

*Module 6: Build manager to crawl through set of SRRs*

+ the set of SRRs are either manually given by user or the result of SRA search criteria given by user
+ feed contigs back into a local database
+ keeps track of what has been searched and contributed

*Module 7: CWL-based management console*

+ Graphical user interface


## Sample Results

Module 3: Report of alignments

| id        | vname          | vlen  | seqcov | avgdepth | aligns | avgMAPQ | avgScore | avgEditDist
| ----------- | ----- | ----- | ---- | ------------- | ------------- | ----- | ---- | ---- |
| NC_032111.1 | BeAn 58058 | 163005 | 0.4 | 3.0 | 18,741 | 255 | 22.7 | 0.3 |
| NC_001357.1 | HPV18 | 7857 | 19.8 | 48.5 | 9,658 | 255 | 39.1 | 0.05 |

+ [BeAn](https://www.ncbi.nlm.nih.gov/nuccore/NC_032111)

Module 5: Contig assembly

+ Longest contig was 600bp. [BLASTN hit](http://bit.ly/2nwKiQL) was to HPV18 (as expected).


