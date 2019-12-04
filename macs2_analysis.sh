##https://github.com/taoliu/MACS/wiki

##MACS empirically models the length of the sequenced ChIP fragments, which 
##tends to be shorter than sonication or library construction size estimates,
##ans uses it to improve the spatial resolution of predicted binding sites.
##MACS also uses a dynamic Poisson distribution to effectively capture local
##biases in the genome sequence, allowing for more sensitive and robust prediction.

##Build Signal Track
##callpeak, 从比对文件中检出peaks
##1. run MACS2 main program
##-t 需处理文件, -t A B C, 多个将会pooled汇聚一起对待
##-c 质控文件, -c A B C, 对个将pooled汇聚一起对待
##-B Whether or not to save extended fragment pileup, and local lambda tracks (two files) at every bp into a bedGraph file. DEFAULT: False
##--nomodel 是否构建shifting model,默认为FALSE, 默认shifting size=100, 建议根据不同
##数据集比较来设置nomodel和extsize来生成signal files进比较
##--extsize 147: 使用147bp作为片段长度来pileup测序reads,当nomodel为TRUE时,
##使用该值作为片段长度延伸read至3端,然后pile up.
##--SPMR, 生成每百万read的的信号文件来描述片段pileup情况, 格式为bedGraph
##-g ce 使用C elegans genome作为背景; dm 表fly, hs表人类
##-n 用于生成输出文件名称
macs2 callpeak -t H3K36me1_EE_rep1.bam -c Input_EE_rep1.bam -B --nomodel \
--extsize 147 --SPMR -g ce -n H3K36me1_EE_rep1

##2. run MACS2 bdgcmp to generate fold-enrichment and logLR track
##通过比较两bedGraph 信号文件来去除噪音
##-m 指定用于比较treatment和control时bin的值, 可选项有ppois,qpois,subtract,
##logFE, logLR和slogLR。代表了柏松分布pvalue(-log10(pvalue)form)，
##使用control作为lambda，treatment作为观察..., 默认为ppois
##-m FE 计算倍数富集
macs2 bdgcmp -t H3K36me1_EE_rep1_treat_pileup.bdg -c H3K36me1_EE_rep1_control_lambda.bdg \
-o H3K36me1_EE_rep1_FE.bdg -m FE

##-p 设置pseudocount值, 用于计算logLR, logFE或FE。
##该值将用于‘pileup per million reads’值，当用于fold enrichment时无需设置，
##因为labmda总是大于0,然而在log likelihood时，避免log(0)，这里使用0.0001
macs2 bdgcmp -t  H3K36me1_EE_rep1_treat_pileup.bdg -c H3K36me1_EE_rep1_control_lambda.bdg \
-o H3K36me1_EE_rep1_logLR.bdg -m logLR -p 0.00001

##3. fix the bedGraph and convert them to bigWig files
##http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/bedGraphToBigWig
##http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/bedClip
##http://code.google.com/p/bedtools/
bdg2bw H3K36me1_EE_rep1_FE.bdg hg19.len $ bdg2bw H3K36me1_EE_rep1_logLR.bdg hg19.len

##4. calculate correlation between replicates
##http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/wigCorrelate
wigCorrelate H3K36me1_EE_rep1_FE.bw H3K36me1_EE_rep2_FE.bw
##如果相关性足够好，那么合并replicates，再次运行masc2

##5. run macs2 combining replicates
##无需samtools merge
macs2 callpeak -t H3K36me1_EE_rep1.bam H3K36me1_EE_rep2.bam \
-c Input_EE_rep1.bam Input_EE_rep2.bam -B --nomodel --extsize 147 --SPMR -g ce -n H3K36me1_EE
##使用类似2和3步骤生成信号轨迹文件(bigWig format)


































