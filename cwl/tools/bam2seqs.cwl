cwlVersion: v1.0
class: CommandLineTool
baseCommand: bam2seqs.pl
arguments: ["-d", $(runtime.outdir)]
inputs:
  format:
    type: string?
    inputBinding:
      prefix: -t
  nopaired:
    type: boolean?
    inputBinding:
      prefix: --nopaired
  prefix:
    type: string?
    inputBinding:
      prefix: --prefix
  bamfile:
    type: File
    inputBinding:
      prefix: -b
outputs:
  outputfile:
    type: File
    outputBinding:
      glob: "*.fa"
