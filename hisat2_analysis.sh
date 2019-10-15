##hisat2 align 
##1 构建index，无法使用gtf提取exon，因为不同对ref注释名称不同
#hisat2-build -p 4 GCA_000742135.1_ASM74213v1_genomic.fna  atcc13883_hisat2_index

##2. hisat2 alin

hisat2 -p 4 -x atcc13883_hisat2_index -1 kp_S_pe_trimmed_1P.fastq.gz -2 kp_S_pe_trimmed_2P.fastq.gz -S kp_S_trimmed_hisat2_align.sam

##3. samtools 
samtools view -bS kp_S_trimmed_hisat2_align.sam > kp_S_trimmed_hisat2_align.bam

##4. samtooles sort 
samtools sort -n kp_S_trimmed_hisat2_align.bam > kp_S_trimmed_hisat2_align_sorted.bam
rm kp_S_trimmed_hisat2_align.sam 
rm kp_S_trimmed_hisat2_align.bam

##
hisat2 -p 4 -x atcc13883_hisat2_index -1 kp_C_pe_trimmed_1P.fastq.gz -2 kp_C_pe_trimmed_2P.fastq.gz -S kp_C_trimmed_hisat2_align.sam

##3. samtools 
samtools view -bS kp_C_trimmed_hisat2_align.sam > kp_C_trimmed_hisat2_align.bam

##4. samtooles sort 
samtools sort -n kp_C_trimmed_hisat2_align.bam > kp_C_trimmed_hisat2_align_sorted.bam
rm kp_C_trimmed_hisat2_align.sam 
rm kp_C_trimmed_hisat2_align.bam 
