cwlVersion: v1.0
class: CommandLineTool
baseCommand: trim.pl
arguments: ["-d", $(runtime.outdir)]
inputs:
  prime5:
    type: string?
    inputBinding:
      prefix: -g
  prime3:
    type: string?
    inputBinding:
      prefix: -a
  seqs:
    type: File
    inputBinding:
      prefix: -f
outputs:
  outputfile:
    type: File
    outputBinding:
      glob: "*.cutadapt.fa"
  logfile:
    type: File
    outputBinding:
      glob: "*.cutadapt.out"


