##GATK4
##Agilent SureSelect Human V5
##Hiseq XT PE 150
#
fq1=$1
fq2=$2
sample=${fq1%%_*}
sample=${sample##*/}
#ref=/share/Data01/huizhen/reference/hg19bundle_gatk4/ucsc.hg19.fasta
ref=/share/Data01/huizhen/reference/human_ref/hs37d5.fa
#hg19bundle_gatk4=/share/Data01/huizhen/reference/hg19bundle_gatk4
b37bundle_gatk4=/share/Data01/huizhen/reference/b37bundle_gatk4
bed=/share/Data01/huizhen/reference/Agilent_SureSelect_V5/Agilent_V5_Region_simplified.bed
snpEff=/share/Data01/huizhen/bin/snpEff

#
##Test the input file
if [ ! -f "$fq1" -o ! -f "$fq2" ]
		then
		    echo "Enter paired-end fastq files"
		    exit 1
fi
#
####bwtsw: Algorithm implemented in BWT-SW,This method works with the whole human genome.
##bwa index -a bwtsw $ref
##dict=${ref/.fa/.dict}
##samtools dict $ref > $dict
##samtools faidx $ref
##
bwa mem -t 8 -M -R "@RG\tID:SMA_Family_Li\tLB:agilent_v5\tPL:ILLUMINA\tPU:${sample}\tSM:${sample}" $ref $fq1 $fq2 >${sample}.sam
###
picard -Xmx4G ReorderSam \
I=${sample}.sam \
O=${sample}.reordered.sam \
REFERENCE=$ref
###
samtools view -@ 8 -bS ${sample}.reordered.sam -o ${sample}.reordered.bam
###
rm -rf ${sample}.sam
###
picard -Xmx4G SortSam \
INPUT=${sample}.reordered.bam \
OUTPUT=${sample}.reordered.sorted.bam \
SORT_ORDER=coordinate
###
rm -rf ${sample}.reordered.sam
###
##The tool's main output is a new SAM or BAM file, in which duplicates have been identified in the SAM flags field for each read. Duplicates are marked with the hexadecimal value of 0x0400, which corresponds to a decimal value of 1024.
## The records within the output of a SAM/BAM file will have values for the 'DT' tag (depending on the invoked TAGGING_POLICY), as either library/PCR-generated duplicates (LB), or sequencing-platform artifact duplicates (SQ).
picard -Xmx4G MarkDuplicates \
REMOVE_DUPLICATES=true \
INPUT=${sample}.reordered.sorted.bam \
OUTPUT=${sample}.reordered.sorted.dedup.bam \
METRICS_FILE=${sample}.reordered.sorted.dedup.metric 
###TAGGING_POLICY=all
###
rm -rf ${sample}.reordered.bam
###
samtools index ${sample}.reordered.sorted.dedup.bam
###
rm -rf ${sample}.reordered.sorted.bam
###
gatk --java-options '-Xmx4G' BaseRecalibrator \
-R ${ref} \
-I ${sample}.reordered.sorted.dedup.bam \
-O ${sample}.recalibration.BRreport \
--known-sites ${b37bundle_gatk4}/1000G_phase1.indels.b37.vcf \
--known-sites ${b37bundle_gatk4}/Mills_and_1000G_gold_standard.indels.b37.vcf \
--known-sites ${b37bundle_gatk4}/1000G_phase1.snps.high_confidence.b37.vcf \
--known-sites ${b37bundle_gatk4}/dbsnp_138.b37.vcf
###
gatk --java-options "-Xmx4G" GatherBQSRReports \
-I ${sample}.recalibration.BRreport \
-O ${sample}.recalibration.BQSRreport
###
gatk --java-options "-Xmx4G" ApplyBQSR \
-R $ref \
-I ${sample}.reordered.sorted.dedup.bam \
-O ${sample}.recalibrated.bam \
-bqsr ${sample}.recalibration.BQSRreport \
--emit-original-quals \
--add-output-sam-program-record \
--create-output-bam-md5 
###
#samtools bedcov $bed ${sample}.reordered.sorted.dedup.bam > ${sample}.bedcov.stats
#samtools depth -a -b $bed ${sample}.reordered.sorted.dedup.bam > ${sample}.bed.depth
##
gatk --java-options "-Xmx4G" HaplotypeCaller \
-R $ref \
-I ${sample}.recalibrated.bam \
-O ${sample}.gatk4.haplotype.vcf \
-L $bed \
-ERC GVCF \
--assembly-region-out ${sample}.gatk4.assembly.igv
##
gatk --java-options "-Xmx4G" GenotypeGVCFs \
-R $ref \
-L $bed \
-V ${sample}.gatk4.haplotype.vcf \
-O ${sample}.gatk4.genotype.vcf \
-D ${b37bundle_gatk4}/dbsnp_138.b37.vcf
##
gatk --java-options "-Xmx4G" SelectVariants \
-R $ref \
-V ${sample}.gatk4.genotype.vcf \
--select-type-to-include SNP \
-O ${sample}.gatk4.genotype.raw.snps.vcf 
##
gatk --java-options "-Xmx4G" SelectVariants \
-R $ref \
-V ${sample}.gatk4.genotype.vcf \
--select-type-to-include INDEL \
-O ${sample}.gatk4.genotype.raw.indels.vcf
##
##gatk filters snps
gatk --java-options "-Xmx4G" VariantFiltration \
-R $ref \
-L $bed \
-V ${sample}.gatk4.genotype.raw.snps.vcf \
-O ${sample}.gatk4.genotype.hardfiltered.snps.vcf \
--filter-expression "QD<2.0" \
--filter-name "LOW_QD" \
--filter-expression "FS>60.0" \
--filter-name "HIGH_FS" \
--filter-expression "SOR>3.0" \
--filter-name "HIGH_SOR" \
--filter-expression "MQ<40.0" \
--filter-name "LOW_MQ" \
--filter-expression "MQRankSum<-12.5" \
--filter-name "LOW_MQRS" \
--filter-expression "ReadPosRankSum<-8.0" \
--filter-name "LOW_RPRS" 
##
##when bcftools filters snps and indels, it will eliminate the sites has both snp and indel calling. 
bcftools filter -i 'TYPE="snp"' ${sample}.gatk4.genotype.hardfiltered.snps.vcf | \
bcftools filter --threads 4 -s "LowQual_snp" -i "((FORMAT/AD[0:1])/(FORMAT/AD[0:0]+FORMAT/AD[0:1])>0.2)" -O v -o ${sample}.gatk4.snps.filtered.vcf
##
##gatk filters indels
gatk --java-options "-Xmx4G" VariantFiltration \
-R $ref \
-L $bed \
-V ${sample}.gatk4.genotype.raw.indels.vcf \
-O ${sample}.gatk4.genotype.hardfiltered.indels.vcf \
--filter-expression "QD<2.0" \
--filter-name "LOW_QD" \
--filter-expression "FS>200.0" \
--filter-name "HIGH_FS" \
--filter-expression "SOR>10.0" \
--filter-name "HIGH_SOR" \
--filter-expression "InbreedingCoeff<-0.8" \
--filter-name "LOW_INC" \
--filter-expression "ReadPosRankSum<-20.0" \
--filter-name "LOW_RPRS"
##
bcftools filter -i 'TYPE="indel"' ${sample}.gatk4.genotype.hardfiltered.indels.vcf | \
bcftools filter --threads 4 -s "LowQual_indel" -i "((FORMAT/AD[0:1])/(FORMAT/AD[0:0]+FORMAT/AD[0:1])>0.25)" -O v -o ${sample}.gatk4.indels.filtered.vcf
##
picard -Xmx4G MergeVcfs \
I=${sample}.gatk4.snps.filtered.vcf \
I=${sample}.gatk4.indels.filtered.vcf \
O=${sample}.gatk4.combined.filtered.vcf
##
#java -Xmx4G -jar $snpEff/snpEff.jar \
#-c /share/Data01/huizhen/bin/snpEff/snpEff.config \
#hg19 ${sample}.combined.filtered.vcf.gz > ${sample}.snpEff.combined.filtered.vcf

#perl /share/Data01/huizhen/bin/ensembl-tools-release-85/scripts/variant_effect_predictor/variant_effect_predictor.pl -i exon_snp_indel_snpEff_ann.vcf -o haplotyper_snpEff_vep_ann.vcf --port 3337 --assembly GRCh37 --offline --vcf --cache --dir /share/Data01/huizhen/bin/ensembl-tools-release-85/scripts/variant_effect_predictor/cache --force_overwrite --sift b --polyphen b --humdiv --gene_phenotype --regulatory --domains --symbol --ccds --biotype --maf_1kg --maf_exac --pubmed
