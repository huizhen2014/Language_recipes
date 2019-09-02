##bowtie2 align
##http://bowtie-bio.sourceforge.net/bowtie2/manual.shtml
##samtolls/bcftools call SNP
##http://samtools.sourceforge.net/mpileup.shtml
##https://samtools.github.io/bcftools/bcftools.html#mpileup

##bowtie2
##bowtie2-build
##构建ref索引文件，针对小于4 billion的长度ref，使用32-bit构建‘small’index文件，后缀.bt2;针对大的ref，使用64-bit构建‘large’index文件，后缀为.bt21

##bowtie2-build [options] <reference_in> <bt2_index_base>
# bowtie2-build GCF_000240185.1_ASM24018v2_genomic.fna K.p 

##bowtie2
##bowtie2 [options] -x <bt2-idx> {-1 <m1> -2 <m2> | -U <r> | --interleaved <i> | -b <bam>} [-S <sam>]
##<bt2-idx> bowtie2-build构建参考基因组输出前缀
##<m1> 双端测序文件reads#1，和<m2>配对;可使用逗号分隔一列输入
##<r> 未成对的测序文件reads;可使用逗号分隔一列输入
##<bam> 根据read名称排序后的未比对的BAM文件
##<sam> SAM文件输出,默认未stdout
##--phred33/--phred64 输入reads文件质量,默认为phred33
##--int-quals 逗号分隔输入reads文件质量值

##-f 指定输入文件为fasta
##-q 指定输入文件为fastq
##--rg-id <text> 添加<text>到SAM头文件
##--rg <text> ("lab:value") 向SAM头添加@RG行信息，仅当--rg-id使用时，才添加--rg-id时，才打印@R行
##必须此5个头信息: --rg-id 39401 --rg LB:39401 --rg PL:ILLUMINA --rg PU:39401 --rg SM:39401
##或全不加头文件信息，后续在MarkDuplicates前使用samtools addreplacerg完整添加
##samtools addreplacerg -r ID:39401 -r LB:39401 -r PL:Illumina -r PU:39401 -r SM:39401 39401_fq/39401_trimmed_sorted.bam -O BAM -o 39401_fq/39401_trimmed_sorted_adrg.bam
##
##默认查询多重比对，仅输出最佳比对，MAPQ有意义
##-k <int> 针对每条read输出至多<int>个比对，MAPQ无意义
##-a/--a 针对每条read输出所有可能比对, MAPQ无意义
#bowtie2 -x K.p --rg-id 39401 --rg LB:39401 --rg PL:ILLUMINA --rg PU:39401 --rg SM:39401 -1 39401_fq/39401_trimed_1P.fq.gz -2 39401_fq/39401_trimed_2P.fq.gz -S 39401_fq/39401_trimmed.sam 1> 39401_fq/39401_trimmed_align.log 2>&1

##samtools sort 对bam文件排序(默认为coordinate)以便后续tviwe查看
##-n 根据read名称排序
##-t 根据TAG值排序
##-o 输出排序后文件
##-O 输出格式，SAM,BAM,CRAM
##--reference 根据参考基因组排序
#samtools sort --reference GCF_000240185.1_ASM24018v2_genomic.fna -O BAM -o 39401_fq/39401_trimmed_sorted.bam 39401_fq/39401_trimmed.sam 2> 39401_fq/39401_sort.log

##samtools view 过滤+转换sam为bam
##picard MarkDuplicate.jar 去除duplication比对,输入文件要先排序
##I=input.bam
##O=marked_duplicates.bam
##M=marked_dup_metrics.txt
##REMOVE_DUPLICATES=true

##java -jar ~/Bin/picard-tools-1.119/MarkDuplicates.jar \
##I=39401_fq/39401_trimmed_sorted.bam \
##O=39401_fq/39401_trimmed_sorted_dedup.bam \
##M=39401_dup_metrics.txt \
##REMOVE_DUPLICATES=true

##samtools flags 查看对应bits set和比对关系
##-b 以bam格式输出
##-S 自动识别输入文件格式
##-F 4 过滤掉任何含该值FLAG的比对;-f 相关输出
##-q 当MAPQ小于改值时，忽略
##-h 在输出中包含头文件；-H 反之
##samtools view -bS -F 4 39401_fq/39401_trimmed_sorted_dedup.bam -o 39401_fq/39401_trimmed_sorted_dedup_filtered.bam

##samtools index 索引bam文件以便samtools tview 查看
##-b 默认针对BAM文件索引，BAI-format
##-c CSI-format索引BAM文件
##samtools index -b 39401_fq/39401_trimmed_sorted_filtered_dedup.bam >39401_fq/39401_trimmed_sorted_filtered_dedup.index 

##推荐使用bcftools mpileup取代samtools mpileup生成BCF/VCF文件
##这里使用bcftools call从BCF/VCF文件中检出SNP/indel
##bcftools call --ploidy ? 查看polidy选项解释，默认为diploid
##--polidy 1 Treat all samples as haploid
##bcftools mpileup -Ov -f ref.fa aln.bam | bcftools call --ploidy 1 -Ou -mv | bcftools filter -s LowQual -e 'QUAL < 20 || DP <20' > var.flt.vcf

##推荐使用freebayes 检出变异
##freebayes 
##-p 默认二倍体
##-C 默认至少满足2个reads才认为是变异
##-F 默认至少20%的reads满足变异
##-min-coverage 最低覆盖度,20
##筛选独特,SAF>0 & SAR>0; PRR>1 & RPL>1; QUAL/AO > 10等
##freebayes -f GCF_000240185.1_ASM24018v2_genomic.fna -p 1 --min-coverage 20 39401_fq/39401_trimmed_sorted_dedup_filtered.bam > 39401_trimmed_freebayes.vcf
##MQ is the mapping quality, which is the fifth column in SAM record. QUAL, meanwhile, is the base quality score, which is derived from the 11th column in SAM record. MQ is typically an indication of how unique the region's sequence is, the higher the MQ, the more unique the sequence. QUAL, is the sequencing quality, which can be platform biased, e.g. Ion seemed to have lower QUAL compared to Illumina.
##使用vcffilter过滤
