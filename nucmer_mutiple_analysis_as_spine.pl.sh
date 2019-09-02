##http://mummer.sourceforge.net/manual/

## nucmer, for the alignment of multiple closely related nucleotide sequences.It finds the maximal exact matches of given length, at first. Then, it cluseters these matches to form largr inexact alignment, and extends alignments outward from each of the matches to join the clusters into a single high scoring pair-wise alignment, finally.

##--mum use anchor matches that are unique in both the reference and query
#nucmer --prefix=ref_qry ref_scaffold.fasta query.scaffold.fasta
#nucmer --mum --prefix=3427_3401 3427_combined_contigs.fasta 3401_combined_contigs.fasta
#nucmer --mum --prefix=3427_168 3427_combined_contigs.fasta 168_combined_contigs.fasta

## 显示坐标，-b不考虑方向合并重复
#show-coords -r -c -l -b 3427_3401.delta > 3427_3401.delta.coords
#show-coords -r -c -l -b 3427_168.delta > 3427_168.delta.coords

## awk print the interval
#awk 'NR>=6{print $16"\t"$1"\t"$2}' 3427_3401.delta.coords > 3427_3401.interval

#awk 'NR>=6{print $16"\t"$1"\t"$2}' 3427_168.delta.coords > 3427_168.interval

## bedtools intersect
## bedtools complement [options] -i <bed/gff/vcf> -g <genome> to get the complement interval
bedtools merge -i 3427_168.interval > 3427_168.combined.interval
bedtools merge -i 3427_3401.interval > 3427_3401.combined.interval
bedtools multiinter -i 3427_3401.combined.interval 3427_168.combined.interval > 3427_core.interval

## bedtools extract seq
bedtools nuc -seq -fi 3427_combined_contigs.fasta -bed 3427_core.interval > 3427_core.interval.seq

## sort the seq file
sort -n -t _ -k 2 3427_core.interval.seq > 3427_core.interval.sorted.seq


## formt the output as fasta file with the width equal to 60
awk '!/^#/{printf "%s\t%s\n",$1,$16;for(i=1;i<=length($17);i+=60){print substr($17,i,60)}}' 3427_core.interval.sorted.seq > 3427_core.interval.sorted.formted.seq
