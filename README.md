# Virus_Detection_SRA

## Workflow

Module 1: Viral RefSeq MagicBLASTer

+ Get viral RefSeq, makeblastdb, initiate magicBLAST

[link to code](link)

```Sample code snippet```

Module 1a: Strict Parameters (Known Viruses)

*Module 1b: Loose Parameters (New Viruses)*

Module 1c: Using a local database

+ makeblastdb, initiate magicBLAST
+ option to append to RefSeq

*Module 1d: Using a local protein database*

+ From isolated proteins
+ From conserved domains

Module 2: Extract reads from samfiles

Module 3: Generate report from step 1

*Module 4a: Adapter Trimming using cut adapt*

+ Usage: User defines adapters

*Module 4b: Adapter Prediction and Trimming using tag cleaner*

+ Usage: No need to define adapters

Module 5: Contig assembly

+ Abyss2 

*Module 6: Feeding contigs back into a local database*

*Module 7: Feeding contigs back into a shared database*

+ CWL-based management console keeps track of what has been searched and contributed


## Sample Results

