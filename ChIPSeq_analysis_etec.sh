##
##E.coli k12
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
macs2 callpeak  --SPMR --trackline --bdg --keep-dup 1 --mfold 1 50 --gsize 4.6e6 --format BAM --name "k12_fnr_36" --outdir "k12_fnr_output" -t SRR576933_filtered_sorted.bam -c SRR576938_filtered_sorted.bam
macs2 callpeak --SPMR --trackline --bdg --keep-dup 1 --mfold 1 50 --gsize 4.6e6 --format BAM --name "k12_fnr_35" --outdir "k12_fnr_output" -t SRR576934.2_filtered_sorted.bam -c SRR576937.2_filtered_sorted.bam 

#macs2 callpeak --SPMR --trackline --bdg --keep-dup all --mfold 5 50 --gsize 5.3e6 --format BAM --name "k12_fnr_two" --outdir "k12_fnr_two" -t SRR576933_filtered_sorted.bam SRR576934.2_filtered_sorted.bam -c SRR576938_filtered_sorted.bam SRR576937.2_filtered_sorted.bam
