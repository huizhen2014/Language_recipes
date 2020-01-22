##
##ETEC_H10407
#ref=/Data_analysis/Ref_database/NCBI/ETEC_H10407/GCF_000210475.1_ASM21047v1_genomic.fna.gz
#index=etec_h10407

#rmdup=/Users/carlos/Bin/picard-tools-1.119/MarkDuplicates.jar

##bowtie2 ref ETEC_H10407
#bowtie2-build ${ref} ${index}

##galore_trim & bowtie2 align 
##XS:i:N,表多重比对时才出现
##XM:i:N,N表错配数目
##XO:i:N,N表示gap数目

#count=0
#for file in $(find $(pwd) -maxdepth 1 -name "*.fastq.gz" |sort)
#    do
#	out=$(basename $file ".fastq.gz")
#	count=$(( $count + 1))
#	{
#	trim_galore -j 4 -q 20 --illumina --stringency 3 --trim-n --fastqc --keep --basename ${out} $file 
#	bowtie2 -x ${index} -U ${out}_trimmed.fq.gz -S ${out}.sam 1> ${out}.log 2>&1
#	samtools view -hF 4 ${out}.sam |grep -v "XS:i" | grep "XM:i:0"| grep "XO:i:0" > ${out}_filtered.sam 
#	samtools view -H ${out}.sam > ${out}.header 
#	cat ${out}.header ${out}_filtered.sam > ${out}.tmp
#	mv ${out}.tmp  ${out}_filtered.sam
#	samtools view -bS ${out}_filtered.sam > ${out}_filtered.bam
#	samtools sort ${out}_filtered.bam > ${out}_filtered_sorted.bam 
#       samtools index ${out}_filtered_sorted.bam

#	java -jar ${rmdup} \
#        I=${out}_filtered_sorted.bam \
#	O=${out}_filtered_sorted_rmdup.bam \
#	METRICS_FILE=${out}_rmdup.metric \
#	REMOVE_DUPLICATES=true

#       samtools index ${out}_filtered_sorted_rmdup.bam
#       rm ${out}.sam ${out}_filtered.sam ${out}_filtered.bam ${out}.header
#	}&
#
#	if [ $count -eq 4 ];then
#	    wait
#	    count=0
#	    fi
#
#	done

##macs2
#macs2 callpeak --pvalue 0.05 --SPMR --trackline --bdg --keep-dup 1 --mfold 2 50 --gsize 5.3e6 --format BAM --name "RNAP_beta" --outdir "RNAP_beta_output" -t ERR654293.RNAP_beta_filtered_sorted.bam ERR654291.RNAP_beta_filtered_sorted.bam -c ERR654295.untagged_filtered_sorted.bam ERR654288.untagged_filtered_sorted.bam

macs2 callpeak --SPMR --trackline --bdg --keep-dup 1 --mfold 2 50 --gsize 5.3e6 --format BAM --name "CRP" --outdir "CRP_output" -t ERR654289.CRP_filtered_sorted.bam ERR654290.CRP_filtered_sorted.bam -c ERR654295.untagged_filtered_sorted.bam ERR654288.untagged_filtered_sorted.bam

#macs2 callpeak --SPMR --trackline --bdg --keep-dup 1 --mfold 2 50 --gsize 5.3e6 --format BAM --name "H_NS" --outdir "H_NS_output" -t ERR654287.H-NS_filtered_sorted.bam ERR654286.H-NS_filtered_sorted.bam -c ERR654295.untagged_filtered_sorted.bam ERR654288.untagged_filtered_sorted.bam
