##bowtie2 align 

#bowtie2-build GCF_000240185.1_ASM24018v2_genomic.fna hs11286_index

bowtie2 -x hs11286_index -1 kp_28_pe_trimmed_1P.fastq.gz -2 kp_28_pe_trimmed_2P.fastq.gz -S kp_28_sangon_mapped.sam

samtools view -bS kp_28_sangon_mapped.sam > kp_28_sangon_mapped.bam

samtools sort kp_28_sangon_mapped.bam > kp_28_sangon_mapped_sorted.bam

##-T 线程
##-q GTF/GFF 注释文件
##-p paired-end 数据
##-f 指定舒适文件格式，默认GTF
##-g 从注释文件提去信息用于count
##-t 默认将一个exon当作一个feature
##-o 默认输出
##-d -D 最短最长片段
##-B 指定两端均得比对方才认为有
##-C 排除chimeric 片段
featureCounts -p -a HS11286.gtf -g Name -t transcript -d 35 -B -C -o kp_28_sangon.counts kp_28_sangon_mapped_sorted.bam
