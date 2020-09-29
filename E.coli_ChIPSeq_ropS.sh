##https://github.com/taoliu/MACS/wiki

##MACS empirically models the length of the sequenced ChIP fragments, which 
##tends to be shorter than sonication or library construction size estimates,
##ans uses it to improve the spatial resolution of predicted binding sites.
##MACS also uses a dynamic Poisson distribution to effectively capture local
##biases in the genome sequence, allowing for more sensitive and robust prediction.

##Build Signal Track
##callpeak, 从比对文件中检出peaks
##1. run MACS2 main program
##-t 需处理文件, -t A B C, 多个将会pooled汇聚一起对待
##-c 质控文件, -c A B C, 对个将pooled汇聚一起对待
##-B Whether or not to save extended fragment pileup, and local lambda tracks (two files) at every bp into a bedGraph file. DEFAULT: False
##--nomodel 是否构建shifting model,默认为FALSE, 默认shifting size=100, 建议根据不同
##数据集比较来设置nomodel和extsize来生成signal files进比较
##--extsize 147: 使用147bp作为片段长度来pileup测序reads,当nomodel为TRUE时,
##使用该值作为片段长度延伸read至3端,然后pile up.
##--SPMR, 生成每百万read的的信号文件来描述片段pileup情况, 格式为bedGraph
##-g ce 使用C elegans genome作为背景; dm 表fly, hs表人类;根据实际指定比对的基因组大小或有效-n 用于生成输出文件名称
##-n 用于生成输出文件名称

#macs2 callpeak -t H3K36me1_EE_rep1.bam -c Input_EE_rep1.bam -B --nomodel \
#--extsize 147 --SPMR -g ce -n H3K36me1_EE_rep1

#for((i=1;i<=4;i++))
#   do
#	trim_galore -q 20 -j 4 --illumina --stringency 3 --trim-n --keep --fastqc --basename ${out}_galore  SRR128599${i}.fastq
#  done

##2. bowtie2 align

#bowtie-build GCF_000005845.2_ASM584v2_genomic.fna mg1655_index

#for((i=1;i<=4;i++))
#    do
#	bowtie2 -x hg19 -U SRR128599${i}.fastq.gz -S SRR128599${i}.sam 1>SRR128599${i}.log 2>&1
#	samtools view -hF 4 SRR128599${i}.sam | grep -v "XS:i" > SRR128599${i}_filtered.sam
#       samtools view -bS SRR128599${i}_filtered.sam > SRR128599${i}_filtered.bam && rm SRR128599${i}_filtered.sam && rm SRR128599${i}.sam
#	samtools sort SRR128599${i}_filtered.bam > SRR128599${i}_filtered_sorted.bam
#	samtools index SRR128599${i}_filtered_sorted.bam
#
#    done

##Evaluate the reference genome effective size
##-s 大小可直接设置为基因组大小
#jellyfish bc -m 21 -s 5M -t 4 -o E.coli_mg1655.bc GCF_000005845.2_ASM584v2_genomic.fna
#jellyfish count -m 21 -s 5M -t 4 --bc E.coli_mg1655.bc GCF_000005845.2_ASM584v2_genomic.fna 

##3. MACS2
macs2 callpeak -g 4.6e6 -B -m 5 50 --SPMR -c ERR654295.untagged_trimmed_filtered_sorted.bam ERR654288.untagged_trimmed_filtered_sorted.bam -t SRR1285993_filtered_sorted.bam SRR1285994_filtered_sorted.bam SRR1285991_filtered_sorted.bam SRR1285992_filtered_sorted.bam --format BAM --name "rpoS" --keep-dup 1
