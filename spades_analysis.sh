###flash, fast length adjustment of short reads, 用于快速准确低将二代测序产出的paired-end reads合并。针对双端测序插入dna片段短于两倍reads长度情况，合并成对reads，产生更长的reads能够显著性提高基因组组装，同时可以用于合并RNA测序数据提高转录本组装
###-m, --min-overlap=NUM,两reads最小重叠长度，默认10
###-M, --max-overlap=NUM,最大重叠长度，期望其长度不超过read pairs长度的90%；默认65，适用于180bp文库测100bp长度；
###-x, --max-mismatch-density=NUM, 最大容忍的错配碱基对占总长必读，默认0.25，超过就不合并
###-o, --output--prefix=PREFIX, 输出文件前缀，默认out
###-d, --output-directory=DIR, 输出文件目录路径，默认当前路径
###-t, --treads=NTTHREADS, 设置工作线程
###-p, --phread-offseq=OFFSET,最小的ACSII值用于带白哦碱基质量
###-r, --read-len=LEN, 平均read长度
###-f, --fragment-len=LEN, 平均插入片段长度
###-s, --fragment-len-stddev=LEN, 平均插入片段长度标准偏差
###默认，-r 100, -f 180, -s 16, -M 65
flast read1.fq read2.fq -p 33 -r 250 -f 500 -s 100 -o output


####spades.py
###版本3.10.1 spades.py可用于Illumina, IonTorrent以及PacBio, Oxford Nanopore, Sanger测得reads
###支持双端，配对reads，非配对reads组装
###用于细菌(single-cell MDA and standard isolates), 真菌和其他小基因组，不适用与大的基因组，例如哺乳动物
###By default we suggest to increase k-mer lengths in increments of 22 until the k-mer length reaches 127
###--careful, 尝试减少错配和短插入缺失数目
###-k, 逗号分隔一系列用于组装的k-mer长度
###-o, 指定输出目录
spades.py -1 fq1.gz -2 fq2.gz --careful -t 4 -k 21,33,55,77,99,127 -o output_dir


###输出结果
###corrected/, 路径包含bayeshammer修正后reads
###scaffolds.fasta，最终scaffolds，推荐作为结果序列
###contigs.fasta，输出的contigs
###assembly_graph.gfa，输出组assembly graph and scaffolds paths in GFA format
###assembly_graph.fastg，输出FASTG格式装配图
###contigs.paths，包含对应contigs.path对应的组装图的paths
###scaffolds.pahts，包含对应scaffolds.pahts对应组装图的paths
###contigs.paths,对应contigs/scaffolds在组装图中跨过gaps，以分号分开gap位置
###NODE_5_length_100000_cov_215.651_ID_5
###2+,5-,3+,5-,4+;
###31+,23-,22+,23-,4-

###quast评估组装
###-r, <filename>, 参考基因组文件
###-g, --feature[type:]<filename>, 参考文件上(GFF, BED, NCBI or TXT)的genomic feature位置
###--features CDS:~/data/my_genome_annotation.gff
###--features gene:./test_data/genes.gff, 仅考虑来自文件的feature
###-m, --min-contig <int>, 最小的contig长度，默认500,Optional 'type' can be specified for extracting only a specific feature type from GFF
quast scaffolds.fasta -r ref.file -o output_dir

















