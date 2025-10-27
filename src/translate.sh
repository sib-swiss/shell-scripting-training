#!/usr/bin/env bash

#declare -rA GENETIC_CODE=(
#    [AAA]=K [AAC]=N [AAG]=K [AAT]=N [ACA]=T [ACC]=T [ACG]=T [ACT]=T
#    [AGA]=R [AGC]=S [AGG]=R [AGT]=S [ATA]=I [ATC]=I [ATG]=M [ATT]=I
#    [CAA]=Q [CAC]=H [CAG]=Q [CAT]=H [CCA]=P [CCC]=P [CCG]=P [CCT]=P
#    [CGA]=R [CGC]=R [CGG]=R [CGT]=R [CTA]=L [CTC]=L [CTG]=L [CTT]=L
#    [GAA]=E [GAC]=D [GAG]=E [GAT]=D [GCA]=A [GCC]=A [GCG]=A [GCT]=A
#    [GGA]=G [GGC]=G [GGG]=G [GGT]=G [GTA]=V [GTC]=V [GTG]=V [GTT]=V
#    [TAA]=0 [TAC]=Y [TAG]=0 [TAT]=Y [TCA]=S [TCC]=S [TCG]=S [TCT]=S
#    [TGA]=0 [TGC]=C [TGG]=W [TGT]=C [TTA]=L [TTC]=F [TTG]=L [TTT]=F
#)

declare -A GENETIC_CODE
while IFS=',' read codon aa; do
	GENETIC_CODE[$codon]=$aa
done < ../data/genetic_code.csv

nuc_seq=$1

while [[ $nuc_seq ]]; do
    codon=${nuc_seq:0:3}
    printf "%s" "${GENETIC_CODE[$codon]}"
    nuc_seq=${nuc_seq:3}
done
printf "\n"
