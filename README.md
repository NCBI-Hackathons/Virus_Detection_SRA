# Virus_Detection_SRA

## Workflow

Module 1: Viral RefSeq MagicBLASTer

Module 1a: Defaut (strict) Parameters (Known Viruses)

+ Get viral RefSeq, makeblastdb, initiate magicBLAST

+ [align_SRR_to_references.pl](https://github.com/NCBI-Hackathons/Virus_Detection_SRA/blob/master/bin/align_SRR_to_references.pl)

+ [SRR073726 RNA-seq prostate cancer cell line](https://www.ncbi.nlm.nih.gov/sra/?term=SRR073726) contains HPV18

```bash
wget ftp://ftp.ncbi.nlm.nih.gov/refseq/release/viral/viral.1.1.genomic.fna.gz
gunzip viral.1.1.genomic.fna.gz
makeblastdb -dbtype nucl -in viral.1.1.genomic.fna -out viral.1.1.genomic -parse_seqids  # 3 seconds
align_SRR_to_references.pl -b viral.1.1.genomic -s SRR073726 &
```

```perl
my $command = "$magicblast -db $blastdb -sra $srr -num_threads $threads -gapextend $gapextend -penalty $penalty -word_size $wordsize -score $score > $samfile";
```

*Module 1b: Loose Parameters (New Viruses)*

+ to obtain lower % id alignments, lower gapextend and penalty options (Greg)

Module 1c: Using a local database

+ makeblastdb, initiate magicBLASTer
+ option to append to RefSeq

*Module 1d: Using a local protein database*

+ From isolated proteins
+ From conserved domains

Module 2: Extract reads from samfiles

+ [sam2fq.pl](https://github.com/NCBI-Hackathons/Virus_Detection_SRA/blob/master/bin/sam2fq.pl)

```bash
~/local/lib/virus_Detection_SRA/bin/sam2fq.pl -t fasta --nopaired SRR073726.viral.1.1.genomic.sam 
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

+ [summarizebam_by_ref.pl](https://github.com/NCBI-Hackathons/Virus_Detection_SRA/blob/master/bin/summarizebam_by_ref.pl)

```bash
summarizebam_by_ref.pl -v -f SRR073726.viral.1.1.genomic.sam -g viral.1.1.genomic.fna > summarize.tsv
```

```perl
    my $avgdepth = $ref{$rid}{td} / $rlen;          # average depth per base for reference    
    my $upos = $ref{$rid}{tp};
    my $seqcov   = $upos / $rlen * 100;    # percent of reference length that is covered by at least one read

    my $nalign  = $ref{$rid}{nalign};
    my $avgmapq = $ref{$rid}{mapq}/$nalign;
```

*Module 4a: Adapter Trimming using cut adapt*

+ Usage: User defines adapters

*Module 4b: Adapter Prediction and Trimming using tag cleaner*

+ Usage: No need to define adapters

Module 5: Contig assembly

+ Abyss2
+ [assembly.pl](https://github.com/NCBI-Hackathons/Virus_Detection_SRA/blob/master/bin/assembly.pl)

```bash
assembly.pl SRR073726.fa
```

```perl
my $command = "ABYSS -k 25 -o $fasta.contigs $fasta > $fasta.abyss.out 2>&1";
`$command`;
```

*Module 6: Feeding contigs back into a local database*

*Module 7: Feeding contigs back into a shared database*

+ CWL-based management console keeps track of what has been searched and contributed


## Sample Results

Module 3: Report of alignments

| id        | vname          | vlen  | seqcov | avgdepth | aligns | avgMAPQ | avgScore | avgEditDist
| ----------- | ----- | ----- | ---- | ------------- | ------------- | ----- | ---- | ---- |
| NC_032111.1 | BeAn 58058 | 163005 | 0.4 | 3.0 | 18,741 | 255 | 22.7 | 0.3 | 
| NC_001357.1 | HPV18 | 7857 | 19.8 | 48.5 | 9,658 | 255 | 39.1 | 0.05 |

Module 5: Contig assembly

+ Longest contig was 600bp. [BLASTN hit](http://bit.ly/2nwKiQL) was to HPV18 (as expected).


