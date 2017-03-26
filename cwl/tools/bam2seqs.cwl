#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool
baseCommand: bam2seqs.pl

inputs:
  seqformat:
    type: string?
    inputBinding:
      prefix: -f
  nopaired:
    type: boolean?
    inputBinding:
      prefix: --nopaired
  bamfile:
    type: File
    inputBinding:
      prefix: -b

outputs:
  outputfile:
    type: File
    outputBinding:
      glob: "*.fa"
