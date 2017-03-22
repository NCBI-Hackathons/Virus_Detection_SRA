cwlVersion: v1.0
class: Workflow
inputs:
#  bam: File
  refs: File
  blastdb: string
  srr: string

outputs:
  report_tsv:
    type: File
    outputSource: summarizebam/outputfile
  viral_contigs:
    type: File
    outputSource: assembly/contigs

steps:
  alignsrr:
    run: align_SRR_to_references
    in:
      srr: srr
      blastdb: blastdb
    out: [outputfile]

  summarizebam:
    run: summarize_bam_by_ref.cwl
    in:
      bamfile: alignsrr/outputfile
      genomefile: refs
    out: [outputfile]

  bam2seqs:
    run: bam2seqs.cwl
    in:
      bamfile: alignsrr/outputfile
    out: [outputfile]

  trim:
    run: trim.cwl 
    in:
      seqs: bam2seqs/outputfile
    out: [outputfile]

  assembly:
    run: assembly.cwl
    in:
      seqs: trim/outputfile
    out: [contigs]
