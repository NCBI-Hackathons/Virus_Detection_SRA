#!/usr/bin/env cwl-runner --preserve-environment BLASTDB
cwlVersion: v1.0
class: CommandLineTool
baseCommand: align_SRR_to_references.pl

inputs:
  srr:
    type: string
    inputBinding:
      prefix: -s
  blastdb:
    type: string
    inputBinding:
      prefix: -b
  threads:
    type: int?
    inputBinding:
      prefix: -t
  gapextend:
    type: int?
    inputBinding:
      prefix: -g
  penalty:
    type: int?
    inputBinding:
      prefix: -p
  wordsize:
    type: int?
    inputBinding:
      prefix: -w
  score:
    type: int?
    inputBinding:
      prefix: -c

outputs:
  outputfile:
    type: File
    outputBinding:
      glob: "*.bam"
