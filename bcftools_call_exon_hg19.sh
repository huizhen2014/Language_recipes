#Bcftools
#Agilent SureSelect Human V5
#ILLUMINA Hiseq XT PE 150

fq1=$1
fq2=$2
sample=${fq1##*/}
sample=${sample%%_*}
ref=/share/Data01/huizhen/reference/hg19bundle_gatk4/ucsc.hg19.fasta
hg19bundle_gatk4=/share/Data01/huizhen/reference/hg19bundle_gatk4
#bed=/share/Data01/huizhen/reference/Agilent_SureSelect_V5/Agilent_V5_Region_simplified.bed
snpEff=/share/Data01/huizhen/bin/snpEff

#
#Test the input file
if [ ! -f "$fq1" -o ! -f "$fq2" ]
		then
		    echo "Enter paired-end fastq files"
		    exit 1
fi
###
#####bwtsw: Algorithm implemented in BWT-SW,This method works with the whole human genome.
###bwa index -a bwtsw $ref
##
bwa mem -t 8 -M -R "@RG\tID:wgs\tLB:wgs\tPL:ILLUMINA\tPU:${sample}\tSM:${sample}" $ref $fq1 $fq2 >${sample}.sam
##
samtools sort -@ 8 --reference $ref -O bam -o ${sample}.sorted.bam ${sample}.sam
##
##samtools faidx $ref
##
##The tool's main output is a new SAM or BAM file, in which duplicates have been identified in the SAM flags field for each read. Duplicates are marked with the hexadecimal value of 0x0400, which corresponds to a decimal value of 1024.
picard -Xmx4G MarkDuplicates \
REMOVE_DUPLICATES=true \
INPUT=${sample}.sorted.bam \
OUTPUT=${sample}.sorted.dedup.bam \
METRICS_FILE=${sample}.sorted.dedup.metric 
###TAGGING_POLICY=All
##
#rm -rf ${sample}.sam
##
samtools index ${sample}.sorted.dedup.bam
##
#rm -rf ${sample}.sorted.bam
##
#samtools bedcov $bed ${sample}.sorted.dedup.bam > ${sample}.bedcov.stats
#samtools depth -a -b $bed ${sample}.sorted.dedup.bam > ${sample}.bed.depth
##########################################################################################
#samtools stats -d -t $bed ${sample}.sorted.dedup.bam > ${sample}.sorted.dedup.bam.stats
####
##rm -rf ${sample}.sorted.bam
###cant work !!!
###plot-bamstats -t $bed ${sample}.sorted.dedup.bam.stats > ${sample}.sorted.dedup.bam.stats.plot
#################################################################################################
##
##The -P option specifies that indel candidates should be collected only from read groups with the @RG-PL tag set to ILLUMINA. Collecting indel candidates from reads sequenced by an indel-prone technology may affect the performance of indel calling.
bcftools mpileup -C 50 -P ILLUMINA -a "FORMAT/AD" -a "FORMAT/ADF" -a "FORMAT/ADR" -a "FORMAT/DP" -a "FORMAT/SP" -f $ref -O b ${sample}.sorted.dedup.bam > ${sample}.bcftools.bcf.gz
bcftools index ${sample}.bcftools.bcf.gz
#
#construct the sample gender info, without this info, it will take sample as male the default option.
cat > "${sample}.PED"<<EOF
${sample}	M
EOF
#
bcftools call --ploidy GRCh37 -m -v -S "${sample}.PED" -O z ${sample}.bcftools.bcf.gz -o ${sample}.bcftools.combined.raw.vcf.gz
#
rm -rf ${sample}.PED

bcftools sort ${sample}.bcftools.combined.raw.vcf.gz -O z -o ${sample}.bcftools.combined.sorted.raw.vcf.gz
bcftools filter -i 'TYPE="snp"' ${sample}.bcftools.combined.sorted.raw.vcf.gz |\
bcftools filter --threads 6 -s "LowQual_snp" -i '((FORMAT/AD[0:1])/(FORMAT/AD[0:0]+FORMAT/AD[0:1])>0.2) & (INFO/MQ >= 30) & (QUAL >= 50) & ((DP4[0]+ DP4[2])>=10) & ((DP4[1]+DP4[3])>=10)' -O z -o ${sample}.bcftools.snps.filtered.vcf.gz 
bcftools filter -i 'TYPE="indel"' ${sample}.bcftools.combined.sorted.raw.vcf.gz |\
bcftools filter --threads 6 -s "LowQual_indel" -i '((FORMAT/AD[0:1])/(FORMAT/AD[0:0]+FORMAT/AD[0:1])>0.25) & (INFO/MQ >= 30) & (QUAL >= 50) & ((DP4[0]+ DP4[2])>=10) & ((DP4[1]+DP4[3])>=10)' -O z -o ${sample}.bcftools.indels.filtered.vcf.gz 
bcftools index ${sample}.bcftools.snps.filtered.vcf.gz
bcftools index ${sample}.bcftools.indels.filtered.vcf.gz
#
#rm -rf ${sample}.bcftools.combined.raw.vcf.gz
#rm -rf ${sample}.bcftools.combined.sorted.raw.vcf.gz
#
bcftools concat -a ${sample}.bcftools.indels.filtered.vcf.gz ${sample}.bcftools.snps.filtered.vcf.gz -O z -o ${sample}.bcftools.combined.filtered.vcf.gz
bcftools index ${sample}.bcftools.combined.filtered.vcf.gz
##
#java -Xmx8G -jar $snpEff/snpEff.jar \
#-c /share/Data01/huizhen/bin/snpEff/snpEff.config \
#hg19 ${sample}.bcftools.combined.filtered.vcf.gz > ${sample}.snpEff.combined.filtered.vcf
##
###perl /share/Data01/huizhen/bin/ensembl-tools-release-85/scripts/variant_effect_predictor/variant_effect_predictor.pl -i exon_snp_indel_snpEff_ann.vcf -o haplotyper_snpEff_vep_ann.vcf --port 3337 --assembly GRCh37 --offline --vcf --cache --dir /share/Data01/huizhen/bin/ensembl-tools-release-85/scripts/variant_effect_predictor/cache --force_overwrite --sift b --polyphen b --humdiv --gene_phenotype --regulatory --domains --symbol --ccds --biotype --maf_1kg --maf_exac --pubmed
