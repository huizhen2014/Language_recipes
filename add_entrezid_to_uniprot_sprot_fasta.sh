#!/bin/bash

declare -a Sep
Sep=({A..Z})

#for i in ${Sep[@]}
#do
#   echo $i"->"${sep[$i]}
#    done

###根据id首字母将文件拆分
#gzcat idmapping_selected.tab.gz |\
#while read line
#    do
#	for var in ${Sep[@]}
#	do
#	    if [[ $line =~ ^$var.* ]];then
#		echo $line >> ${var}_separated_mapping
#		continue
#	    fi
#       done
#
#    done

##针对每一uniprot_sprot id名称添加对应的entrezid
##">sp|Q6GZX4|001R_FRG3G" -> ">sp|Q6GZX4|001R_FRG3G|2947773"
##注意sed中使用变量替换，单引号要变为双引号

cat uniprot_sprot.fasta |\
while read seq last
    do
	if [[ $seq =~ ^\>sp.* ]];then
	    name=${seq#>sp|}
	    name=${name%|*}
	    Cap=${name:0:1}
	    ans=$(grep -w $name ${Cap}_separated_mapping)
	    ans=$( echo $ans | cut -d " " -f 3 -)
	    echo $seq $last | sed "s/\($seq\)/\1|$ans/" >> with_entrezid_uniprot_prot.fasta
	else
	     echo $seq $last >> with_entrezid_uniprot_prot.fasta
	fi
    done

