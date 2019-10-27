##trimmomatic glore bowtie2
ref=GCF_000240185.1_ASM24018v2_genomic.fna
read1=kp_21_R1.fastq.gz
read2=kp_21_R2.fastq.gz
out=KP_21_trimmo
index=hs11286_index
adapter=../Sangon_PE.fa

##trimmomatic 去除指定adapter序列
trimmomatic PE ${read1} ${read2} -baseout ${out}_trimmed.fastq.gz ILLUMINACLIP:${adapter}:2:30:10:3:keepBothReads LEADING:20 TRAILING:20 SLIDINGWINDOW:5:20 MINLEN:35 

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
##-q/--quality 除了adapterremove外，末端保留最小质量阈值
##--keep 保留trimmed掉的中间文件
##--paired 双端模式，均得满足条件
##--fastqc trim后运行fastqc默认分析
trim_galore --paired -j 4 -q 20 --illumina --stringency 3 --length 35 --trim-n --keep --fastqc --basename ${out}_galore ${out}_trimmed_1P.fastq.gz ${out}_trimmed_2P.fastq.gz

##bowtie2 align 
bowtie2-build ${ref} hs11286_index

bowtie2 -x hs11286_index -1 ${out}_galore_R1_trimmed_1P_val_1.fq.gz -2 ${out}_galore_R2_trimmed_2P_val_2.fq.gz -S ${out}_sangon_mapped.sam 2> ${out}_bowtie2_map.log

samtools view -bS  ${out}_sangon_mapped.sam > ${out}_sangon_mapped.bam

##根据位置排序
samtools sort ${out}_sangon_mapped.bam > ${out}_sangon_mapped_sorted.bam
samtools index ${out}_sangon_mapped_sorted.bam

rm ${out}_sangon_mapped.sam 
rm ${out}_sangon_mapped.bam

##使用Rsubread featureCounts
##-primary
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
