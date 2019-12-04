##canu
##根据基因组大小和测序数据量判断测序覆盖度(～多少X)
##设置corOutCoverage控制用于校正的数据量, 默认为40X数据量,根据实际情况
##minOverlapLength, default 500
##设置，这里使用全部数据量

#echo "ICU43 100x start time" $(date)
##if read quality is too low to meet the assemble standard, 
##add corMhapSensitivity=normal
canu -p icu43_100x -d icu43_100x \
-pacbio-raw ICU43_subreads.fastq.gz \
genomeSize=4m \
minReadLength=2000 \
corOutCoverage=100 \
corMhapSensitivity=normal \
correctedErrorRate=0.040 

#echo "ICU43 100x end time" $(date)

##lac4同上
#echo "LAC4 100x start time" $(date)
#canu -p lac4_100x -d lac4_100x \
#genomeSize=4m \
#minReadLength=2000 \
#corOutCoverage=100 \ 
#correctedErrorRate=0.040 \
#-pacbio-raw lac4_subreads.fastq.gz

#echo "LAC4 100x end time" $(date)

###############################
#echo "ICU43 50x start time" $(date)
##if read quality is too low to meet the assemble standard, 
##add corMhapSensitivity=normal
#canu -p icu43_50x -d icu43_50x \
#genomeSize=4m \
#minReadLength=2000 \ 
#corOutCoverage=50 \
#corMhapSensitivity=norma \
#correctedErrorRate=0.040 \
#-pacbio-raw ICU43_subreads.fastq.gz 

#echo "ICU43 50x end time" $(date)

##lac4同上
#echo "LAC4 50x start time" $(date)
#canu -p lac4_50x -d lac4_50x \
#genomeSize=4m \
#minReadLength=2000 \
#corOutCoverage=50 \
#correctedErrorRate=0.040 \
#-pacbio-raw lac4_subreads.fastq.gz
#echo "LAC4 50x end time" $(date)
###################################






###########################################################################
##分步运行
##1. 校正/自身纠错
#canu -correct \
#-p icu43_cor -d icu43_cor \
#genomeSize=4m \
#minReadLength=2000 minOverlapLength=500 \
#corOutCoverage=100 corMinCoverage=4 \
#-pacbio-raw xxx.fa

##2. 过滤/修剪read
#canu -trim \
#-p icu43_trim -d icu43_trim \
#genomeSize=4m \
#minReadLength=2000 minOverlapLength=500 \
#-pabcio-corrected icu43_cor/icu43_cor.correctedReads.fasta.gz

##3. 组装
#canu -assemble \
#-p icu43_ass -d icu43_assemble \
#genomeSize=4m \
#correctedErrorRate=0.040 \
#-pabcio-corrected icu43_cor/icu43_trim.trimmedReads.fasta.gz

