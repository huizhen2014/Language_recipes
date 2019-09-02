##https://github.com/trinityrnaseq/trinityrnaseq/wiki/RNA-Seq-Read-Representation-by-Trinity-Assembly

##先使用bowtie2对fq数据依据组装后文件比对，samtools检查比对统计
##bowtie2-build Trinity.fasta Trinity.fasta
##bowtie2 -p 10 -q --no-unal -k 20 -x Trinity.fasta -1 reads_1.fq -2 reads_2.fq 2>align_stats.txt| samtools view -@10 -Sb -o bowtie2.bam
##cat align_stats.txt
##一般trinity转录本组装将会回贴约70%-80%的reads

##使用IGV查看trinity组装
##samtools sort bowtie2.bam -o bowtie2.coordSorted.bam
##samtools index bowtie2.coordSorted.bam
##samtools faidx Trinity.fasta
##查看组装
##igv.sh -g Trinity.fasta  bowtie2.coordSorted.bam


