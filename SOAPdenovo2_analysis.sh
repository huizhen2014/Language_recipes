###SOAPdenovo提供短read组装，可组装人类基因组大小的de novo draft，该软件针对Illumina GA short reaeds
###64-bit Linux system,最小5G physical memory; 针对人类基因组，需要150 GB memory

###配置文件包含整体信息
##avg_ins，平均插入文库长度或插入序列长度的峰值
##reverse_seq，0，forward-reverse，一般插入序列长度小于500bp；1，forward-forward，环状文库，一般插入长度大于2kb
##asm_flgs=3，1，仅contig装配；2，仅scaffold装配；3，contig和scaffold均装配；4，仅gap closure
##rd_len_cutoff，组装时将过长的read截断至该长度
##rank=1，决定了read用于构建scaffold的次序，值越低，数据越优先于构建scaffod，170/200/250bp,rank1;350/500bp,rank2;800bp,rank3;2kb,rank4;5kb,rank5;10kb,rank6;20kb,rank7
##pair_num_cutoff=3，可选参数，规定了连接连个contig或pre-scaffold的可信连接的阈值，当连接数目大于该值，连接有效；短插入(<2k)默认为3，长插入默认为5
##map_len=32，可选参数，规定了map过程中reads和contig的比对长度必须达到该值(不允许mismatch和gap)，该比对才能作为一个可信的比对，短插入(<2k)一般设置为32，长插入片段设置为35，默认值为k+2
##q1=/pathfastq_read_1.fq，read1的fastq路径文件
##q2=/pathfastq_read_2.fq，read2的fastq路径文件
##f1=/pathfasta_read_1.fa，read1的fasta路径文件
##f2=/pathfasta_read_2.fa，read2的fasta路径文件
##q=/pathfastq_read_single.fq，单端测序fastq路径文件
##f=/pathfasta_read_single.fa，单端测序fasta路径文件
##p=/pathpairs_in_one_file.fa，双端测序得到的一个fasta格式序列文件

###整体运行
##-s，配置文件，config_file
##-o，输出文件名前缀
##-g，输入文件名前缀
##-F，利用read对scaffold中gap填补，默认不执行
##-K, kmer(min13,max127),默认23，更大的K值期待解决基因组中跟多的重复，同时需要更深测序深度和读长,较小k-mer用于杂合基因组；较大k-mer用于高度重复的基因组
###关键参数
##-R，利用read鉴别短的重复序列,默认不进行
##-d，去除低频的K-mers，常由测序错误导致
##-D，删除低覆盖度的edges，常用于减少组装错误，减少graph的复杂度
##-M，基因组杂合率，假如杂合率高于0.3%，设置为3较好
SOAPdenovo-127mer all -s config_file -K 25 -R -F -o 5_L1_soap2 >ass.log

###分布运行
## 1
#SOAPdenovo-127mer pregraph -s config_file -K 25 -R -o output_prefix > pregraph.log

## 2
##-g，输入graph文件名称前缀
##-p, cpu使用数目[8]
#SOAPdenovo-127mer contig -R -g output_prefix > contig.log

## 3
##-s，配置文件，cofing_file
##-g，输入graph文件名称前缀
##-f，可选输出gap相关的reads,用于使用SRkgf来填充gap，默认NO
##-p，cpu使用数目[8]
##-k, kmer用于比对read到contig 
#SOAPdenovo-127mer map -g output_prefix -s config_file > map.log

## 4
##-g，输入graph文件名称前缀
##-F，可选参数，使用read对scaffold中的gap填补，默认 [No]
#SOAPdenovo-127mer scaff -g output_prefix -F >scaff.log
