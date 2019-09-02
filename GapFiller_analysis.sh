##GapFiller程序用于填充scaffolds之间的gaps，gap定义为位置核酸(N's)，用于填充gaps，识别重复单元或者低覆盖度区域(之前未组装)

##-l,library file，包含各个文库的信息,共6列信息，每个信息间以空格分开
##Lib1 bwa file1.1.fastq file1.2.fastq 400 0.25 FR
##第一列为library名称，使用该短名称用于追溯libraries，临时文件和统计文件都以该名称为前缀
##第二列为比对软件名称，bowtie，bwa或bwasw；bowtie用于短read(<50bp)快速分析；bwa用于长read(>50,<150)；bwasw用于更长read
##第三/四列双端fasta或fastq文件，针对成对read，三四分为为对应单端read，且要求在统一行；另外read长度应>16，避免被去除
##第五列代表reads对期待对插入序列长度；第六列为对应插入序列长度的偏差率，例如插入长度为400，偏差为0.25，那么对应为400*0.25=100的偏差，则reads对之间距离为300-500为有效reads对
##第七列为reads的方向，F，代表-->;R，代表<--；因此FR代表方向--><--

##命令行参数
##-s，指定scaffolds fasta文件
##-m，read和gap最小的base重叠数目，越高的m值，gapclosing越准确，例如针对36bp文库，建议-m值在30-35之间以实现可信的gapclosing
##-o，在gapclosing过程中指定最小的reads数目用于填补一个位置，也称为base coverage
##-r，最小的base比率用于接受一个overhang consensus base，值越高越准确
##-n，合并围绕一个gap的两个序列的最小重叠数目
##-t，gap边缘需要删除的序列长度，一般而言，序列边缘的碱基常为低质量/错误装配的序列，因此会导致GapFiller不能正确延伸序列
##-d，用于指定gapclosed长度和原始gapsize之间的差异，假如偏离太远，gap填充不多终止，或者序列无法合并

##
## config_file
##5_L1 bwasw 5_L1_R1.fq.gz 5_L1_R2.fq.gz 500 0.25 FR
##perl GapFiller.pl -l config_file -s scaffolds.fasta -m 30 -o 3 -r 0.7 -n 10 -d 50 -t 10 -b best
