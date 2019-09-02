###fastqc
##对数据质量进行评估(quality control)

##usage
##-o --outdir fastqc生成报告文件路径
##t --treads 选择运行线程，每个线程为250MB内存
##-a --adapters 输入测序adapters序列信息，格式 Name [Tab] Sequence，若不输入，则按照通用引物序列评估adapter残留

##fastqc -o ./tmp_dir Sample.fq.gz 

##Mac version，采用GUI模式

##根据输出选择对应输入文件用于后续denove组装和变异检测
