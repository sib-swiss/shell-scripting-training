---
title: Day 2 - Project
---

FASTA to TSV converter script project
=====================================

The Problem with Fasta
----------------------

Here are some operations that one might wish to perform on a FASTA file:

* Count the number of records
* Count the number of species
* Extract a record by ID
* Find the longest sequence
* Reject sequences with ambiguous nucleotides (`N`, `Y`, etc.)
* Discard aligned sequences with too many gaps
* Partition records by species

With shell tools, the first two are trivial, but
**the last four are next to impossible**.

Why ?
-----

* Unix shell tools (`sed`, `awk`, `grep`, etc.) are predominantly _line-oriented_.
* Some bioinformatics formats are line-oriented (_e.g._ [GFF](#gff), [VCF](#vcf))...
  but Fasta is not (neither are GenBank, UniProt, ...).
* Converting FASTA to some line-oriented format (_e.g._ TSV) would solve the
  problem.^[The _format_ problem, that is - the rest can be left to `grep` and
  the like.]

The project
-----------

To be able to perform more operations easily on FASTA file content, we are
going to write a **FASTA $\rightarrow$ TSV converter script**.

WARNING
-------

\begin{alertblock}{Didactical Script!}

The script is meant to \emph{illustrate} concepts, \strong{not} to be efficient.

$\Rightarrow$ We'll write it in pure style. A real-world
script would be in delegation style and very different (but mostly useless for
teaching).

\end{alertblock}

. . .

Indeed, a FASTA $\rightarrow$ TSV converter could be written in one line of
`sed`:

\small
```bash
sed -n '1{h;b};${H;bo};/^>/!{H;b};:o;x;s/^>//;s/\n/\t/;s/\n//g;p'
```
\normalsize

