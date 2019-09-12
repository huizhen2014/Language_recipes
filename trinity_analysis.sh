##https://github.com/trinityrnaseq/trinityrnaseq/wiki/Running-Trinity
##https://github.com/trinityrnaseq/trinityrnaseq/wiki/There-are-too-many-transcripts!-What-do-I-do%3F

##Trinity对来自Illumina平台的RNA-Seq数据，进行搞笑稳健的转录本de novo组装
##Trinity综合了三个独立的软件模型:Inchworm, Chrysalis, Butterfly
##Inchworm assembles the RNA-seq data into the unique sequences of transcripts, often generating full-length transcripts for a dominant isoform, but then reports just the unique portions of alternatively spliced transcripts
##Chrysalis clusters the Inchworm contigs into cluster and constructs complete de Bruijn graphs for each cluster. Each cluster represents the full transcriptonal complexity for a given gene(or set of genes that share sequences in common). Chrysalis then paritions the full read set among these disjoint graphs.
##Butterfly then processes the individual graphs in parallel, tracing the paths that reads and pairs of reads take within the graph, ultimately reporting full-length transcripts for alternatively spliced isoforms, and testing apart transcripts that corresponds to paralogous genes.

##--seqType <string>: fa/fq
##--max_memory <string>: 最大使用内存
##--left/--right <string>: 双端测序reads
##--single <string>: 单端测序reads，多个文件使用逗号隔开；若单个文件包含成对reads，使用：--run_as_paired
##--SS_lib_type <string>: 链特异性RNA-seq read；双短使用RF/FR，单端使用F/R，dUTP方法使用RF
##--min_contig_length <int>: 最短的组装的contig输出，默认为200
##--trimmomatic :使用trimmomatic进行质量过滤,默认采用：ILLUMINACLIP:$TRIMMOMATIC_DIR/adapters/TruSeq3-PE.fa:2:30:10 SLIDINGWINDOW:4:5 LEADING:5 TRAILING:5 MINLEN:25
##--no_normalize_reads :不进行reads标准化处理。默认最大read coverage为50
##--output <string>: 输出文件夹名称

##a typical trinity command 
##Trinity --seqType fq --max_memory 50G --left reads_1.fq.gz  --right reads_2.fq.gz --CPU 

##for Genome-guided trinity, provide a coordinate-sorted bam
##Trinity --genome_guided_bam rnaseq_alignments.csorted.bam --max_memory 50G --genome_guided_max_intron 10000 --CPU 6

##output
##输出文件内的Trinity.fasta为trinity完成后输出
## >TRINITY_DN1000_c115_g5_i1 len=247 path=[31015:0-148 23018:149-246]
##AATCTTTTTTGGTATTGGCAGTACTGTGCTCTGGGTAGTGATTAGGGCAAAAGAAGACAC
##ACAATAAAGAACCAGGTGTTAGACGTCAGCAAGTCAAGGCCTTGGTTCTCAGCAGACAGA
##一个转录本的cluster指得是一个gene; TRINITY_DN1000_c115_g5_i1：read cluster为‘TRINITY_DN100_c115'，gene为'g5'，isoform为'i1'
##由于一次trinity运行可能涉及到很多很多的reads cluster，每个cluster都分别进行组装，由于'gene'数目在给定处理的read cluster中是唯一的，因此'gene'识别符应该为read cluster加上对应的基因识别符:TRINITY_DN1000_c115_g5，因此，'TRINITY_DN1000_c15_g5'编码isoform'TRINITY_DN1000_c115_g5_i1'
##Path information存在header中:'path=[31015:0-148 23018:149-246'，node'31015'对应转录的序列范围0-148;node23018对应转录序列的序列范围149-246

##针对输出过多的转录本,可能源于可变剪切或测序错误引入新的转录本,由于多重比对，可能给定量带来困难
##筛选同一基因的最长转录本作为unigene
##get_longest_isoform_seq_per_trinity_gene.pl Trinity.fasta > uniqgene.fasta
##使用聚类去除冗余
##cd-hit-est -i Trinity.fasta -o output_cdhitest.fasta -c 0.98 -p 1 -d 0 -b 3 
##使用>=1 fpkm or tpm 筛选
