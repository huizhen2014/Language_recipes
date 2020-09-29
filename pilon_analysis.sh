##https://github.com/broadinstitute/pilon/wiki

##组装后fasta和以fasta为参考基因组比对的bam文件,bwa/bowtie2
ref=icu43_default.contigs.fasta
index=index/icu43_default
r1=ICU43_galore_R1_trimmed_1P_val_1.fq.gz
r2=ICU43_galore_R2_trimmed_2P_val_2.fq.gz
out=icu43_default
pilon=/home/huizhen/bin/pilon-1.23.jar

#mkdir index
bwa index -p $index $ref

bwa mem $index $r1 $r2 | samtools sort -O bam -o ${out}_align.bam

java -jar /home/huizhen/bin/picard-tools-1.119/MarkDuplicates.jar \
I=${out}_align.bam \
O=${out}_align.dedup.bam \
REMOVE_DUPLICATES=true \
METRICS_FILE=${out}.dedup.metric

samtools view -b -q 30 ${out}_align.dedup.bam > ${out}_align.dedup.filtered.bam

samtools index ${out}_align.dedup.filtered.bam

###pilon polish
java -jar ${pilon} --genome ${ref} --frags ${out}_align.dedup.filtered.bam --outdir ${out}_pilon --output ${out}_polish --vcf --tracks --changes --fix all --debug
