###http://snpeff.sourceforge.net/SnpEff_manual.html
###snpEff.jar SnpSift.jar instruction

###Common options 
##-c path/to/snpEff/snpEff.config 指定配置数据文件
##-noStats 取消对vcf文件内容的统计输出
##-t 指定运行线程 multithreaded implementation
##-classic 取消HGVS注释，默认采取该注释
##-noLog 取消usage信息输出
##-fi intervals.bed 指定过滤区间
##-canon 使用canonical transcripts
##-v verbose模式，会显示很多有用调试信息
##-onlyTr file.txt 指定转录本列表，来注释指定列表信息
##-ud size_in_bases 修改默认的interval区间上下游的注释，取消：-ud 0
##-interval file.bed 修改第四列信息，将一同注释到ANN后:
##bed:	1	1000	20000	MY_ANNOTATION
##会针对不同转录本，以此注释，以ANN开始，不同转录本间用逗号分开
##java -Xmx4g path/to/snpEff/snpEff.jar -c path/to/snpEff/snpEff.contig GRCh37.75 path/to/snps.vcf
##java -jar snpEff.jar -c ~/snpEff.config GRCh37.75 Shared_by_father_and_son.vcf.gz>Shared_by_father_and_son.ann.vcf.gz

##-cds 显示coding exons(no UTRs)
##-e 显示外显子
##-f <file.txt> TXT文件，每个基因一行
##-tr 仅显示整个转录本区间
###这个很棒！！！
##java -jar snpEff.jar genes2bed -c ~/snpEff.config GRCh37.75 -e -f gene_list.txt > gene_list.intervals

##Show sequence (from command line) translation
##-r 反向互补序列
##snpEff seq [-r] genome seq_1 seq_2 seq_3
##java -jar snpEff.jar seq GRCh37.75 -r GTACCTTGATTTCGTATTCTGAGAGGCTGCTGCTTAGCGGTAGCCCCTTGGTTTCCGTGGCAACGGAAAA
##FSVATETKGLPLSSSLSEYEIKV?

###http://snpeff.sourceforge.net/SnpSift.html#Split
###SnpSift 过滤处理注释后文件
##SnpSift filter
##所有VCF fields都可做变量名字用于过滤，只要在VCF头文件或者为标准VCF字段
## | 表或，& 表同时, ! 表反选
##-e file 从file读取过滤表达式
##-n 反选，选择不满足表达式
##-r 满足表达式的情况下，抹掉FILTER注释
##=~ 支持正则表达 FILTER =~ 'Low'
##INFO 内的内容可直接使用(DP > 10)&(AF1 = 0)

##Gneotype: GT:PL:GQ 1/1:255,66,0:63 0/1:245,0,255:99
##"(GEN[0].GQ >60) & (GEN[1].GQ >90)" or ANY field "(GEN[*].GQ > 60)
##"(GEN[0].PL[2] = 0) or ANY field "(GEN[*].PL[*] = 0 )"
##或直接使用样本名: "(GEN[HG00096].DS > 0.2) & (GEN[HG00097].DS > 0.5)"

##针对转录本，过滤基因或者特定变异类型,第一注释ANN[0]
##LOF 和 NMD sub-fileds一样 LOF.GENE NMD.GENE
##java -jar SnpSift.jar filter "(exists INDEL) | (FILTER = 'PASS')" Shared_by_father_and_son.vcf |le    ## PASS 用小括号
##java -jar SnpSift.jar filter "(GEN[0].AD[1]>75)&(GEN[2].AD[1]>80)" Combined.merged.vcf | le
##java -jar SnpSift.jar filter "ANN[0].GENE = 'TRMT2A')" ...

###这个很棒！！！
##SnpSift Annotate 使用其他VCF file来注释(eg. dbSnp, 1000 Genomes projects, ClinVar, ExAC, etc).
##-info -id -exists 选择db.vcf内包含子集
##java -jar SnpSift.jar annotate dbsnp132.vcf variants.vcf > variants_annotated.vcf
##tabix af.hs37d5.vcf.gz
##java -jar SnpSift.jar annotate -info EAS_AF af.hs37d5.vcf.gz Combined.merged.vcf >Combined.merged.af.EAS_AF.vcf

##SnpSift CaseControl ...elimination!!!
##SnpSift Intervals, 提取和任何interval相交的变异
##intervals as BED files
##-i 指定输入vcf文件(默认为STDIN)
##-x 反选interval
##java -jar SnpSift.jar intervales -i variants.vcf my_intervals.bed > variants_intersecting_intervals

##SnpSift TsTv
##only snp
##java -jar SnpSift.jar tstv variants.vcf

##SnpSift Extract Fields
##提取vcf文件栏为tab分隔的txt文件
##java -jar 
##java -jar SnpSift.jar tstv hom s.vcf 

##这个很棒！！！
##SnpSift extractFileds 
##-s "," -e "." 使用逗号分隔多重位置；使用点好代表空位
##java -jar SnpSift.jar extractFields -e "." Shared_by_father_and_son.ann.af.EAS_AF.vcf CHROM POS ID REF ALT FILTER MQ DP EAS_AF ANN[0].GENE ANN[0].EFFECT ANN[0].IMPACT ANN[0].HGVS_C ANN[0].HGVS_P ANN[0].CDNA_POS ANN[0].CDS_POS ANN[0].AA_POS LOF[0].GENE LOF[0].NUMTR LOF[0].PERC NMD[0].GENE NMD[0].NUMTR NMD[0].PERC > Shared_by_father_and_son.ann.af.EAS_AF.extracted.txt

##SnpSnift Variant type
##Adds an INFO field denoting variant type
##java -jar SnpSift.jar varType test.vcf
##SNP/MNP/INS/DEL/MIXED in the INFO	field

##SnpSift dbNSFP
##download and index(tabix)	
##Dont know how to work with it, now !!!

##SnpSift Split
##java -jar SnpSift.jar split myhuge.vcf 默认根据染色体分隔 myhuge.1.vcf ...
##java -jar SnpSift.jar split -j huge.000.vcf huge.001.vcf ... > huge.out.vcf

##The other ...

