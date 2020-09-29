####Trimmomatic
##Trimmomatic主要针对illumina测序数据过滤，包括去除接头和剪短测序reads
##针对PE，去除非配对的read

##usage
##输入文件可以使用'gzip'或'bzip2'文件，通过文件后缀'.gz', '.bz2'识别

##输入输出选项，若不明确指定，使用-basein，则反向reads文件将根据输入标签自动搜索
##Sample_Name_R1_001.fq.gz -> Sample_Name_R2_001.fq.gz
##Sample_Name.f.fastq -> Sample_Name.r.fastq
##Sample_Name.1.sequence.txt -> Sample_Name.2.sequence.txt

##输出选项使用-baseout，那么4个输出文件将自动根据标签指定
##-baseout mySampleFilered.fq.gz
##mySampleFiltered_1P.fq.gz - for paired forward reads
##mySampleFiltered_1U.fq.gz - for unpaired forward reads
##mySampleFiltered_2P.fq.gz - for paired reverse reads
##mySampleFiltered_2U.fq.gz - for unpaired reverse reads

##默认质量值为-phred64，若不指定，将自动检测所采用质量值(-phred33/-phred64)
##SLIDINGWINDOW: 从5‘端开始按照窗口大小对低于阈值的平均质量read去除
##LEADING：去除起点起低于阈值质量的base
##TRAILING：去除末端低于阈值质量的base
##MINLEN：舍弃修剪后长度低于阈值的reads
##AVGQUAL：舍弃平均质量值低于阈值的reads
##ILLUMINACLIP:<fastaWithAdaptersEtc>:<seed mismathess>:<palindrome clip threshold>:<simple clip threshold>:<minAdapterLength>:<keepBothReads>
## <fastaWithAdaptersEtc>: adapter或primer序列文件
## <seed mismatchess>: 匹配过程中允许的最大错配数目
## <palindromeClipThreshold>: 在两个'adapter ligated' reads之间,此时双向reads读通, 反向互补, 需要满足的准确程度, 针对PE palindrome read alignment, 针对一对reads
## <simpleClipThreshold>: 两个adapter之间的匹配程度, 序列必需对应单个read
## <minAdapterLength>: 仅针对PE palindrom模式, 最小的adapter长度, 默认为8 bases. 由于palidrome mode拥有很低的假阳性, 即使设置为1, 允许更短的adapter片段去除, 也无妨
## <keepBothReads>: 去除一个方向时也去除对应另一个方向read, 默认: true 


##单端举例
##java -jar trimmomatic-0.30.jar SE s_1_1_sequence.txt.gz lane1_forward.fq.gz ILLUMINACLIP:TruSeq3-SE:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

##过滤双端实例
##文献中PE 2X100 MINLEN设为60
##trimmomatic PE -summary 5_L1_trim.summary 5_L1_R1.fq.gz 5_L1_R2.fq.gz 5_L1_R1.trimed.paired.fq.gz 5_L1_R1.trimed.unpaired.fq.gz 5_L1_R2.trimed.paired.fq.gz 5_L1_R2.trimed.unpaired.fq.gz LEADING:30 TRAILING:30 MINLEN:90 AVGQUAL:20

##过滤RNA-seq Sangon PE150 
##java -jar ~/software/Trimmomatic-0.36/trimmomatic-0.36.jar PE -threads 30 rawdata/input_forward.fq.gz rawdata/input_reverse.fq.gz QCoutput/output_forward_paired.fq.gz QCoutput/output_forward_unpaired.fq.gz QCoutput/output_reverse_paired.fq.gz QCoutput/output_reverse_unpaired.fq.gz ILLUMINACLIP:rawdata/adaptor.fa:2:30:10 LEADING:20 TRAILING:20 SLIDINGWINDOW:5:20 MINLEN:35

##ILLUMINACLIP:adapter.fa:2:30:10
##Remove Illumina adapters provided in the TruSeq3-PE.fa file (provided). Initially Trimmomatic will look for seed matches (16 bases) allowing maximally 2 mismatches. These seeds will be extended and clipped if in the case of paired end reads a score of 30 is reached (about 50 bases), or in the case of single ended reads a score of 10, (about 17 bases).

##for adapter files
#Naming of the sequences indicates how they should be used.
#For 'Palindrome' clipping, the sequence names should both start with 'Prefix', and end in '/1' for the forward adapter and '/2' for the reverse adapter. 
#All other sequences are checked using 'simple' mode. Sequences with names ending in '/1' or '/2' will be checked only against the forward or reverse read. Sequences not ending in '/1' or '/2' will be checked against both the forward and reverse read.
#If you want to check for the reverse-complement of a specific sequence, you need to specifically include the reverse-complemented form of the sequence as well, with another name.
