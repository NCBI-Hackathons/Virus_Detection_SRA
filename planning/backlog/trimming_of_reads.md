# Trim off non-template sequences of a set of reads

## Description

As a biologist, there is alot of non-template bases on sequences. I want to make sure that any non-template sequence is removed from the ends of my set of sequences.

## Notes

- Input: fastq sequences with list of adaptors to be removed

- Output: fastq sequences that have been trimmed

There are a few ways of doing this, and it's not clear which is best. 

- which tool to use? Cutadapt?
- is there a way to predict adaptors with TagCleaner if user does not input a list of adaptors?

## Estimate: 3
## Priority: MUST

