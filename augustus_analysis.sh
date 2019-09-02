###augustus gene prediction

###输出为gff文件格式，需要自写脚本提取对应序列信息

###重要参数
##--species=SPECIES,指定query物种；详见：augustus --species=help
##--strand=both/forward/backward，预测链方向，默认both
##--genemodel=partial/intronless/comlete/alteastone/exactlyone，预测基因模式，partial：允许预测处于序列两端的不完整基因(默认)，**intronless，仅预测当个外显子基因，例如在原核和一些真核生物中**；complete，仅预测完整的基因；atleastone：预测至少一个完整的基因；exactlyone，预测精确的一个完整基因
##--predictionStart=A, --predictionEnd=B, 定义预测序列范围
##--gff3=on/off，输出gff3格式

###gff3格式说明
##共9列信息：1，seqid；2，feature source；3，feature type；4/5，feature stert/end；6，feature score，使用E表示序列相似度，P值表示ab initio基因预测值，.表示没有值；7，feature strand；8，feature phase，0表示下一个密码子从该区域第一个碱基开始，1表示从第二个碱基开始，2表示从第三个碱基开始，.表示没有；9，feature attributes，格式tag=value，各attributes以分号隔开

##usage
#augustus --gff3=on --genemodel=intronless --species=E_coli_K12 38588-scaffolds.fasta > 38588_augustus.gff
