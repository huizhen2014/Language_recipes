##https://harvest.readthedocs.io/en/latest/content/parsnp/tutorial.html
##https://github.com/marbl/parsnp

###Parsnp was designed to align the core genome of hundreds to thousands of bacterial genomes within a few minutes to few hours. Input can be both draft assemblies and finished genomes, and output includes variant(SNP) calls, core genome phylogeny and multi-alignments. Parsnp leverages contextual information provides by multi-alignments surrounding SNP sits for filtration/cleaning, in addition to existing tools for recombination detection/filtration and phylogenetic reconstruction.
##The main advantages of parsnp over alternative approaches is robust filtration of variant(SNP) calls, multiple alignments as output and superior sepeed.If interested in pan genome/whole genome alignment, existing tools for the job that perform well include Mauve, Mugsy, among others. Parsnp is tailored for intraspecific genome analysis(outbreak analysis of a pathogen, etc). One main limitation of Parsnp is that it cannot handle subsets(core genome only) and is not as sensitive as existing methods.
##Parsnp is a conservative core genome alignment method that necessarily requires that all genomes are present in each aligned regions.
##Parsnp defult will eleminate the MUMi distance <= 0.01 genomes.
##Any SNPs in regions not shared by all genomes will not reported.
##LCBs locally collinear blocks
##MUMs maximal unique matches

##-c force inclusion of all genomes
##-o output directory
##-C maximal cluster D values? (default 100) -C 1000 -c force alignment across large collinear regions, -C maximum distance between collinear MUMs
##LCB alignment -u output unaligned regions, default NO
##parsnp -p <threads> -d <directory of genomes> -r <ref genome> : -r fasta
##parsnp -g <reference_replicon1, reference_replicon2,..> -d <genome_dir> -p <threads> :-g genebank files
##Output files
##Newick formatted core genome SNP tree: $outputdir/parsnp.tree
##SNPs used to infer phylogeny: $output/parsnp.vcf
##Gingr formatted binary archive: $output/parsnp.ggr
##XMFA formatted multiple alignment: $output/parsnp.xmfa
#parsnp -r GCF_000240185.1_ASM24018v2_genomic.fna -d ../assembly_fasta/ -c -C 1000 -o SERTY_parsnp_fasta_out
#parsnp -g GCF_000240185.1_ASM24018v2_genomic.gbff -d ../assembly_fasta/ -c -C 1000 -o SERTY_parsnp_genebank_out

##only call the MUMs distance and quit
#parsnp -r GCF_000240185.1_ASM24018v2_genomic.fna -d ../assembly_fasta/ -M

##harvesttools 
##with reference & genbank file as input:
#harvesttools -g <ref_genbank_file> -r <ref_fasta_file> -x <XMFA file> -o hvt.ggr

##with harvest-tools file as input, XMFA output, sames as the output by Gingr alignment(XMFA):
#harvesttools -i input.ggr -X output.xmfa

##with harvest-tools file as input, fasta formatted SNP file as output，sames as the output by Gingr variants(MFA):
#harvesttools -i input.ggr -S output.snps

##multi-fastas output as the SCOTTi input multi-fasta alignment file before filtered the eliminated genomes
#harvesttools -i input.ggr -M out.multi-fasta.align
