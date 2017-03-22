cwlVersion: v1.0
class: Workflow
inputs:
  bam: File
# refs: File

outputs:
  result:
    type: File
    outputSource: assembly/contigs

steps:
#  summarizebam:
#    run: summarize_bam_by_ref.cwl
#    in:
#      bamfile: bam
#      genomefile: refs
#    out: [outputfile]

  bam2seqs:
    run: bam2seqs.cwl
    in:
      bamfile: bam
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
