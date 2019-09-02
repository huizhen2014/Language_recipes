#### Introduction
##原核生物蛋白编码基因预测软件：提供快速准确地预测蛋白编码基因，格式包括GFF3, Genebank或Squin table format；可以处理组装好的基因组，或未组装好的基因组和宏基因组；用户可以指定存在gap的gene和如何处理contig边缘的genes；可以识别大部分gene的转录起点，且输出格式可包含基因组上所有潜在的转录起始点，以及对应置信值，RBS motif等。

#### Usage
##指定预测模型，版本3.X
#1. normal mode，根据提供的序列，直接预测
#2. anonymous mode，根据提前计算训练的文件来预测输入序列
#3. tarining mode，同normal mode，同时保留training文件供以后使用
#-p, --mode：默认single，当个基因组，可包含任何数目序列；train，仅用于训练，可以是一个或多个相近的基因组的mutltiple fasta文件；annon，使用现有的训练文件预测，针对metagenomic数据或单个短序列。
#旧版PRODIGAL v2.6.3 [February, 2016]，single对应normal，meta对应anon。
prodigal -i 38588-scaffolds.fasta -o 38588.coords.gbk -a 38588.protein.translations.faa

#-i，指定输入文件，可以为单个或多个fasta文件，genebank或embl格式，推荐fasta格式
#-o，指定输出文件(gene coordinates)
#-a，指定输出转录的蛋白序列
#-d，指定输出对应核酸序列文件
#-s，指定完整的起始文件
#-w，输出统计文件
#-f，指定输出格式，gbk默认，gff，sqn(sequin feature table format)，sco(simple coordinate output)
#-g，转录密码表，11为细菌/古生菌；4为支原体/螺原体，默认先11后4

##旧版：PRODIGAL v2.6.3 [February, 2016]
prodigal -i 38588-scaffolds.fasta -f gff -o 38588.coords.gff -a 38588.protein.translations.faa -d 38588.nucelotides.fna -s 38588.starts

#anonymous mode，新版为 -p anon，旧版 -p meta
prodigal -i 38588-scaffolds.fasta -p meta -a /Data_analysis/ref_database/NCBI/Klebsiella_pneumoniae_ncbi/GCF_000240185.1_ASM24018v2_genomic.faa -o 38588.anon.gbk -p meta

##training mode，可以指定输出training文件供以后使用，旧版无此功能
prodigal -i genome1.fna -p train -t genome1.trn
prodigal -i genome2.fna -t genome1.trn -o genome2.gbk -a genome2.faa

#### 输出
#ID: 序列经过排序的gene identifier，4_1023，表示第4个序列的第1023个gene
#partial：表示gene是否超过了序列边缘，0表示具有完整边界start和end，1表示部分gene，例如：01表示gene部分存在右侧边界；11表示gene两边超过边界；00表示gene具有完整起始密码子
#start_type：ATG/GTG/TTG，如果没有，为Edge
#stop_type：TAA/TGA/TAG，如果没有，为Edge
#rbs_motif：RBS motif，核糖体基序，例如AGGA/GGA等
#rbs_spacer：motif和起始密码之间的距离
#gc_skew：gene序列的gc skew
#conf：该gene的可信度
#sscore：gene的转录起始位置分值，为以下三种之和：rscore，该gene RBS motif分值；uscore：围绕起始密码分值；tscore：起始密码子类型分值
