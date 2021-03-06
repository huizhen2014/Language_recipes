##
ref=GCF_000786735.1_ASM78673v1_genomic.fna
read1=LAC_4.raw_1.fastq.gz
read2=LAC_4.raw_2.fastq.gz
out=LAC_4
ref_index=lac_4_index

##PE150
##去除指定接头
##minAdapterLength:3
##keepBothReads:true 
trimmomatic PE $read1 $read2 -summary ${out}_trimmed.summary -baseout ${out}_pe_trimmed.fastq.gz ILLUMINACLIP:Sangon_adapter.txt:2:30:10:3:true LEADING:20 TRAILING:20 SLIDINGWINDOW:5:20 MINLEN:35 

##http://www.bioinformatics.babraham.ac.uk/projects/trim_galore/
##--illumina 去除illumina通用adapter序列
##-a 需要trimmed的adatper序列1
##-a2 需要trimmed的dapter序列read2，paried-end reads
##--stringency 至少需要满足多少个adapter重叠方才trim，默认1，选择3
##--length 至少满足的read长度
##--trim-n 去除read末端的Ns
##-o/--outpur_dir 输出目录，若无自动创建
##--basename 输出文件名称:PREFERRED_NAME_trimmed.fq
##-j/--cores 运行cores数目
##-q/--quality 出了adapterremove外，末端保留最小质量阈值
##--keep 保留trimmed掉的中间文件
##--paired 双端模式，均得满足条件
##--fastqc trim后运行fastqc默认分析
trim_galore --paired -j 4 -q 20 --illumina --stringency 3 --length 35 --trim-n --keep --fastqc --basename ${out}_pe_galore ${out}_pe_trimmed_1P.fastq.gz ${out}_pe_trimmed_2P.fastq.gz

##bowtie2 align 

#bowtie2-build ${ref} ${ref_index}

bowtie2 -x ${ref_index} -1 ${out}_pe_galore_R1_trimmed_1P_val_1.fq.gz -2 ${out}_pe_galore_R2_trimmed_2P_val_2.fq.gz -S ${out}_sangon_mapped.sam 2> ${out}_bowtie2_mapping.log

samtools view -bS ${out}_sangon_mapped.sam > ${out}_sangon_mapped.bam

##根据比对名称排序
samtools sort ${out}_sangon_mapped.bam > ${out}_sangon_mapped_sorted.bam
samtools index -b ${out}_sangon_mapped_sorted.bam 

rm ${out}_sangon_mapped.sam
rm ${out}_sangon_mapped.bam

##使用Rsubread count
##-T 线程
##-q GTF/GFF 注释文件
##-p paired-end 数据
##-f 指定舒适文件格式，默认GTF
##-g 从注释文件提去信息用于count
##-t 默认将一个exon当作一个feature
##-o 默认输出
##-d -D 最短最长片段
##-B 指定两端均得比对方才认为有效
##-C 排除chimeric 片段
##--ignoreDup RNAseq 允许duplication
##-M count Multi-mapping reads ，目前无推荐
#featureCounts -p -a HS11286.gtf -g Name -t transcript -d 35 -B -C -o kp_21_sangon.counts kp_21_sangon_mapped_sorted.bam 
