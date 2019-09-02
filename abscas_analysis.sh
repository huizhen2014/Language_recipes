###
##ABACAS用于根据参考基因组快速快速连接(align, order, orientate)，查看并设计引物用于contigs之间gaps的填充。根据参考基因组，使用mummer查询比对位置并识别共线性。输出结果使用N代表contigs之间的重叠和gaps，contigs之间的重叠重由于contigs末端的低质量以及低复杂度区域。同时，ABACAS能自动提取gaps，并设计引物用于gaps填充，设计引物的特异性可通过mummer比对查看。

##输出中凡比对到反向序列，均经过了反向互补转换

##-c 环状序列
##-i 最小一致性
##-v 最小contig覆盖度，默认40%
##-V 最小contig差异，0表示多重比对，随机放置
##-t 针对为使用contigs(.bin)，采用tblastx比对
##-N 不实用N对contigs间重叠及gaps填充
##-m 输出经过排序和重定向的多重fasta格式文件
##-b 输出包含未比对的contigs多重fasta文件
##-g 输出reference上的多重fasta文件对应gaps

abacas -v 5 -c -N -m -g ref_query_gaps -b -r NC_016845.1.fna -q 39401_len500_cov20_sacffolds.fasta -p nucmer -o ref_query_5
