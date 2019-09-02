#freebayes
#Calling variants: from fastq to vcf
#1. Align your reads to a suitable reference (e.g. with bwa or MOSAIK)
#2. Ensure your alignments have read groups attached so their sample may be identified by freebayes. Aligners allow you to do this, but you can also use bamaddrg to do so post-alignment.
#3. Sort the alignments (e.g. bamtools sort).
#4. Mark duplicates, for instance with samtools rmdup (if PCR was used in the preparation of your sequencing library)
#5. Run freebayes on all your alignment data simultaneously, generating a VCF. The default settings should work for most use cases, but if your samples are not diploid, set the --ploidy and adjust the --min-alternate-fraction suitably.
#6. Filter the output e.g. using reported QUAL and/or depth (DP) or observation count (AO).
#7. Interpret your results.
#8. (possibly, Iterate the variant detection process in response to insight gained from your interpretation)

#Analysis_flow
fq1=$1
fq2=$2
sample=${fq1##*/}
sample=${sample%%_*}
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
##
######bwtsw: Algorithm implemented in BWT-SW,This method works with the whole human genome.
####bwa index -a bwtsw $ref
###
#bwa mem -t 8 -M -R "@RG\tID:SMA_Family_Li\tLB:agilent_v5\tPL:ILLUMINA\tPU:${sample}\tSM:${sample}" $ref $fq1 $fq2 >${sample}.sam
###
#samtools sort -@ 8 --reference $ref -O bam -o ${sample}.sorted.bam ${sample}.sam
###
###samtools faidx $ref
###
##The tool's main output is a new SAM or BAM file, in which duplicates have been identified in the SAM flags field for each read. Duplicates are marked with the hexadecimal value of 0x0400, which corresponds to a decimal value of 1024.
#picard -Xmx4G MarkDuplicates \
#REMOVE_DUPLICATES=true \
#INPUT=${sample}.sorted.bam \
#OUTPUT=${sample}.sorted.dedup.bam \
#METRICS_FILE=${sample}.sorted.dedup.metric 
##TAGGING_POLICY=All
##
##rm -rf ${sample}.sam
###
#samtools index ${sample}.sorted.dedup.bam
###
##rm -rf ${sample}.sorted.bam
###
#samtools bedcov $bed ${sample}.sorted.dedup.bam > ${sample}.bedcov.stats
##samtools depth -a -b $bed ${sample}.sorted.dedup.bam > ${sample}.bed.depth
####
###########################################################################################
###samtools stats -d -t $bed ${sample}.sorted.dedup.bam > ${sample}.sorted.dedup.bam.stats
#####
##rm -rf ${sample}.sorted.bam
####cant work !!!
####plot-bamstats -t $bed ${sample}.sorted.dedup.bam.stats > ${sample}.sorted.dedup.bam.stats.plot
##################################################################################################
###
freebayes --min-alternate-fraction 0.2 --min-alternate-count 4 --no-complex --use-best-n-alleles 4 --min-base-quality 10 --min-mapping-quality 20 -t $bed -f $ref ${sample}.sorted.dedup.bam > ${sample}.freebayes.combined.raw.vcf
#
##########################################################################################
##vcffilter -f "QUAL > 20 & TYPE = snp & DP > 20 & AF > 0.20" > freebayes_filtered.snps.vcf
##vcffilter -f "QUAL > 20 & TYPE = ins & DP > 20 & AF > 0.25" -o -f "QUAL > 20 & TYPE = del & DP > 10 & AF > 0.25" P18027754LU01.freebayes_raw.vcf > freebayes.filtered.indels.vcf
#####################################################################################################
#
bcftools sort ${sample}.freebayes.combined.raw.vcf -O z -o ${sample}.freebayes.combined.sorted.raw.vcf.gz
bcftools filter -i 'TYPE="snp"' ${sample}.freebayes.combined.sorted.raw.vcf.gz |\
bcftools filter --threads 6 -s "LowQual_snp" -i '((FORMAT/AD[0:1])/(FORMAT/AD[0:0]+FORMAT/AD[0:1])>0.2) & (QUAL > 20) & ((INFO/SRF)+(INFO/SAF))>=10 & ((INFO/SAR)+(INFO/SRR))>=10' -O z -o ${sample}.freebayes.snps.filtered.vcf.gz 
bcftools filter -i 'TYPE="indel"' ${sample}.freebayes.combined.sorted.raw.vcf.gz |\
bcftools filter --threads 6 -s "LowQual_indel" -i '((FORMAT/AD[0:1])/(FORMAT/AD[0:0]+FORMAT/AD[0:1])>0.25) & (QUAL > 20) & ((INFO/SRF)+(INFO/SAF))>=10 & ((INFO/SAR)+(INFO/SRR))>=10' -O z -o ${sample}.freebayes.indels.filtered.vcf.gz 
bcftools index ${sample}.freebayes.snps.filtered.vcf.gz
bcftools index ${sample}.freebayes.indels.filtered.vcf.gz
#
#rm -rf ${sample}.combined.raw.vcf.gz
#rm -rf ${sample}.combined.sorted.raw.vcf.gz
#
bcftools concat -a ${sample}.freebayes.indels.filtered.vcf.gz ${sample}.freebayes.snps.filtered.vcf.gz -O z -o ${sample}.freebayes.combined.filtered.vcf.gz
bcftools index ${sample}.combined.filtered.vcf.gz
###
#java -Xmx8G -jar $snpEff/snpEff.jar \
#-c /share/Data01/huizhen/bin/snpEff/snpEff.config \
#hg19 ${sample}.combined.filtered.vcf.gz > ${sample}.snpEff.combined.filtered.vcf
###
####perl /share/Data01/huizhen/bin/ensembl-tools-release-85/scripts/variant_effect_predictor/variant_effect_predictor.pl -i exon_snp_indel_snpEff_ann.vcf -o haplotyper_snpEff_vep_ann.vcf --port 3337 --assembly GRCh37 --offline --vcf --cache --dir /share/Data01/huizhen/bin/ensembl-tools-release-85/scripts/variant_effect_predictor/cache --force_overwrite --sift b --polyphen b --humdiv --gene_phenotype --regulatory --domains --symbol --ccds --biotype --maf_1kg --maf_exac --pubmed
