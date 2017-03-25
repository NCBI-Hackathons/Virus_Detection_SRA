#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool
baseCommand: assembly.pl

inputs:
  seqs:
    type: File
    inputBinding:
      prefix: -f
outputs:
  contigs:
    type: File
    outputBinding:
      glob: "*.contigs"
  logfile:
    type: File
    outputBinding:
      glob: "*.abyss.out"
