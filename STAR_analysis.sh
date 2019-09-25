##STAT mapping analysis
##STAR --help
##1. 生成genome idnexes 文件，需提供参考基因组fasta files和注视文件gtf files, 该步骤生成的genomeindexes用于第2步的mapping过程
##--runThreadN 运行线程
##--runMode genomeGenerate 用于genome indexes文件生成
##--genomeFastaFiles 指定1个或多个genome参考序列文件
##--sjdbGTFfile 指定转录注释文件gtf格式文件, STAR可不需要注释文件运行，但是高度推荐使用注释文件;默认情况下，该选项仅处理第3列为exon的区间(--sjdbGTFfeatureExon)，可选择相应名称参数,这里transcript, --sjdbGTFtagExonParentTranscript，指定转录本名称,其他对应名称默认
##--sjdbOverhang 指定注释junction区域基因组序列长度，用于构建splice junctions database。理想跳线下为ReadLength-1，ReadLength为最长reads长度；大多数情况，默认值100可达到理想值相同效果
##--genomeSAindexNbases 对于很小的基因组，该值应安比例缩小 min(14,log2(GenomeLength)/2 -1)。细菌选择10
STAR --runMode genomeGenerate --genomeFastaFiles GCF_000240185.1_ASM24018v2_genomic.fna --sjdbGTFfile HS11286.gtf --sjdbGTFfeatureExon transcript --sjdbGTFtagExonParentTranscript Name --sjdbGTFtagExonParentGeneName Name --genomeSAindexNbases 10 --genomeDir STAR_index/

##2. 比对，同样可以在mapping阶段使用上不注释步骤
##--runThreadN 线程数目
##--runMode alignReads/inputAlignmentsFromBAM
##--genomeDir 指定genome indexes文件路径
##--readFilesIn /path/to/read1 /path/to/read2
##--readFilesCommand zcat/gunzip -c / bunzip2 -c 若read文件为压缩文件，使用该命令解压缩后输入
##针对多个read文件，使用逗号分隔输入同一端reads文件
##--outFileNamePrefix /path/to/output/dir/prefix,需要提前mkdir
STAR --runMode alignReads --genomeDir STAR_index --readFilesIn kp_21_trimmed.pe_1P.fastq.gz kp_21_trimmed.pe_2P.fastq.gz --readFilesCommand gunzip -c --quantMode GeneCounts --outSAMtype BAM SortedByCoordinate --outFileNamePrefix kp_21_STAR_align_results/kp_21_star

##3. 输出文件
##Log.out 主要log文件，记录详细运行信息
##Log.progress.out 任务运行统计信息，例如处理的reads数目，mapping百分率等
##Log.final.out mapping运行完成后，总结比对统计数据
##Multimappers 见sam文件的NH:i:Nmap，1表是唯一比对；>1表示多重比对
##第5列的MAPQ值为255表示唯一比对
##--outSAMtype BAM Unsorted 输出未排序的Aligned.out.bam文件
##--outSAMtype BAM SortedByCoordinate 输出Aligned.sortedByCoord.out.bam，类似samtools sort
##--outSAMtype BAM Unsorted SortedByCoordinate 输出以上两种
##--quantMode -/TranscriptomeSAM/GeneCounts 默认输出nothing/对应注释区域比对的SAM或BAM文件/注释序列基因数目
##嵌合融合略!


























