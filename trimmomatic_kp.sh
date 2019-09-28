##PE150
#trimmomatic PE -summary kp_21_pe_trimmed.summary kp_21_R1.fastq.gz kp_21_R2.fastq.gz -baseout kp_21_trimmed.pe.fastq.gz ILLUMINACLIP:../Sangon_PE.fa:2:30:10 LEADING:20 TRAILING:20 SLIDINGWINDOW:5:20 MINLEN:35

Trim=/home/huizhen/bin/Trimmomatic-0.36/trimmomatic-0.36.jar	

##trim PE as SE
#java -jar $Trim SE kp_28_R1.fastq.gz kp_28_R1_se_trimmed.fastq.gz ILLUMINACLIP:../../Sangon_PE.fa:2:30:10

#java -jar $Trim SE kp_28_R2.fastq.gz kp_28_R2_se_trimmed.fastq.gz ILLUMINACLIP:../../Sangon_PE.fa:2:30:10

java -jar $Trim PE kp_28_R1_se_trimmed.fastq.gz kp_28_R2_se_trimmed.fastq.gz -baseout kp_28_pe_trimmed.fastq.gz LEADING:20 TRAILING:20 SLIDINGWINDOW:5:20 MINLEN:35
