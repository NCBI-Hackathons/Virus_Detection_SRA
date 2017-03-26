#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool
baseCommand: trim.pl

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
      glob: "*.trim.fa"
  logfile:
    type: File
    outputBinding:
      glob: "*.trim.log"
