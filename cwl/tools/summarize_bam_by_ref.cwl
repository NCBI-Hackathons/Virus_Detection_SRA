cwlVersion: v1.0
class: CommandLineTool
baseCommand: summarize_bam_by_ref.pl
arguments: ["-d", $(runtime.outdir)]
inputs:
  accver:
    type: boolean?
    inputBinding:
      prefix: -v
  bamfile:
    type: File
    inputBinding:
      prefix: -f
  genomefile:
    type: File
    inputBinding:
      prefix: -g
outputs:
  outputfile:
    type: File
    outputBinding:
      glob: "*.summarize.tsv"
