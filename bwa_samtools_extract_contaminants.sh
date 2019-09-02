##1. Create the ref database
##bwasw does not work with database less than 10MB
##bwa index -p kp GCF_000240185.1_ASM24018v2_genomic.fna

##2. map fastq to ref
##bwa mem kp O2-6_R1.fq.gz O2-6_R2.fq.gz > O2-6.aln.pe.sam

##3. samtools dilute the mapped read for kp
##samtools viwe -h -f 4 O2-6.aln.pe.sam > O2-6.aln.pe.unmap.kp.sam

##4. convert the sam format to fastq format
##samtools view -b O2-6.aln.pe.unmap.kp.sam -o O2-6.aln.pe.unmap.kp.bam

##since all of the reads are unmapped, it does not matter whether to include the -F 0x900 or not
##samtools fastq -1 test_paired1.fq -2 test_paired2.fq -0 /dev/null -s /dev/null -n -F 0X900 O2-6.aln.pe.unmap.kp.bam
