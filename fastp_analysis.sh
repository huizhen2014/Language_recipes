##https://github.com/OpenGene/fastp
##快速自动识别adapter
##-w/--thread 工作线程，默认3
##输入输出
##-1/--in1 read1输入文件
##-o/--out1 read1输出文件
##-I/--in2 read2输入文件
##-O/--out2 read2输出文件
##-6/--phread64 指定read质量值为64

##过滤接头参数设置
##-A/--disable_adapter_trimming 取消自动adapter trim过程
##-a/--adapter_sequence read1 adapter序列
##--adapter_sequence_r2 read2 adapter序列

##划窗过滤
##-5/--cut_by_quality5 指定5端最小碱基质量阈值，默认取消
##-3/--cut_by_quality3 指定3端最小碱基质量阈值，默认取消
##-W/--cut_window_size 指定划窗大小，默认4bp
##-M/--cut_meadn_quality 指定窗口平均质量，默认20

##长度过滤
##-l/--length_required 最短read长度，默认15
##-L/--disable_length_filtering 取消长度阈值

##质量过滤
##-Q/--disable_quality_filtering 取消默认的质量过滤
##-q/---qualified_quality_phred 碱基质量阈值，默认15
##-u/--unqualified_percent_limit 最小比率碱基需满足最小碱基质量阈值，默认40(40%)
##-n/--n_base_limit 最多N碱基数目，默认5个

echo "Start time " $(date)
fastp -i KP_C.raw_1.fastq.gz -o KP_C_fastp_filtered_1.fastq.gz -I KP_C.raw_1.fastq.gz -O KP_C_fastp_filtered_2.fastq.gz --adapter_sequence AGATCGGAAGAGCACACGTCTGAAC --adapter_sequence_r2 AGATCGGAAGAGCGTCGTGTAGGGA -5 20 -3 20 -W 5 -M 20 -l 35 
echo "End time " $(date)

mkdir fastp_analysis_qc
fastqc -o fastp_analysis_qc KP_C_fastp_filtered_1.fastq.gz KP_C_fastp_filtered_2.fastq.gz
