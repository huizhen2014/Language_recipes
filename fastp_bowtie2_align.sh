##fastp
##TruSeq Stranded mRNA sample prep kit 

#for file in $(find . -name "*.fastq.gz")
#    do
#	tmp=${file%%.fastq.gz}
#	tmp=${tmp##*/}
#	fastp -i $file -o ${tmp}_trimmed.fastq.gz -W 5 -M 20 -q 20 -l 25 
#    done

#bowtie2-build GCF_000006765.1_ASM676v1_genomic.fna pao1_index

#for file in $(find . -name "*_trimmed.fastq.gz")
#    do
#	tmp=${file%%_trimmed.fastq.gz}
#	tmp=${tmp##*/}
#	bowtie2 -x pao1_index -U $file -S ${tmp}.sam
#	samtools view -bS ${tmp}.sam > ${tmp}.bam
#	samtools sort ${tmp}.bam > ${tmp}_sorted.bam
#   done

##为方便后续分析，使用Rsubread包featureCounts计算count
#for file in $(find . -name "*_sorted.bam")
#    do
#	tmp=${file##*/}
#	tmp=${tmp%%_*}
#	featureCounts -a GCF_000006765.1_ASM676v1_genomic.gtf -g gene_id -t gene -C -o ${tmp}.counts $file
#    done
