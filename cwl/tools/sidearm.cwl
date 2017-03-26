#!/usr/bin/env cwl-runner --preserve-environment BLASTDB --preserve-environment PERL5LIB
cwlVersion: v1.0
class: Workflow

inputs:
  # align
  srr: string
  blastdb: string
  threads: int

  # bam2seqs
  seqformat: string
  nopaired: boolean

  # summarize_bam_by_ref
  accver: boolean?
  genomefile: File

  # trim
  prime5: string?
  prime3: string?

outputs:
  bamfile:
    type: File
    outputSource: alignsrr/outputfile
  report_tsv:
    type: File
    outputSource: summarizebam/outputfile
  trimlog:
    type: File
    outputSource: trim/logfile
  trimseqs:
    type: File
    outputSource: trim/outputfile
  assemblylog:
    type: File
    outputSource: assembly/logfile
  viral_contigs:
    type: File
    outputSource: assembly/contigs

steps:
  alignsrr:
    run: align_SRR_to_references.cwl
    in:
      srr: srr
      blastdb: blastdb
      threads: threads
    out: [outputfile]

  summarizebam:
    run: summarize_bam_by_ref.cwl
    in:
      bamfile: alignsrr/outputfile
      genomefile: genomefile
      accver: accver
    out: [outputfile]

  bam2seqs:
    run: bam2seqs.cwl
    in:
      bamfile: alignsrr/outputfile
      seqformat: seqformat
      nopaired: nopaired
    out: [outputfile]

  trim:
    run: trim.cwl
    in:
      seqs: bam2seqs/outputfile
    out: [outputfile, logfile]

  assembly:
    run: assembly.cwl
    in:
      seqs: trim/outputfile
    out: [contigs, logfile]
