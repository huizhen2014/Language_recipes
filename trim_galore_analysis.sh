##http://www.bioinformatics.babraham.ac.uk/projects/trim_galore/
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
trim_galore -j 4 -q 20 -a AGATCGGAAGAGCACACGTCTGAAC -a AGATCGGAAGAGCGTCGTGTAGGGA -a2 AGATCGGAAGAGCACACGTCTGAAC -a2 AGATCGGAAGAGCGTCGTGTAGGGA --stringency 3 --length 35 --trim-n --keep --paired --fastqc --basename kp_S_galore_trimmed -o kp_S_trim_galore KP_S.raw_1.fastq.gz KP_S.raw_2.fastq.gz
