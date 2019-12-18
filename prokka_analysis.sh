##https://github.com/tseemann/prokka
##prokka --listdb
##[10:07:53] Looking for databases in: /usr/local/Cellar/prokka/1.13/bin/../db
##[10:07:53] * Kingdoms: Archaea Bacteria Mitochondria Viruses
##[10:07:53] * Genera: Enterococcus Escherichia Staphylococcus
##[10:07:53] * HMMs: HAMAP
##[10:07:53] * CMs: Bacteria Viruses

##1. moderate 
##Choose the names of the output files
##prokka --outdir mydir --prefix mygenome contigs.fa
##Visulalize it in Artemis
#art mydir/mygenome.gff
##--compliant when the gbk result is used for snippy software as the ref file

##2. sepcialist
##--proteins [X]    FASTA or GBK file to use as 1st priority (default '')
##The --proteins option is recommended when you have good quality reference genomes and want to ensure gene naming is consistent. 
##If you have Genbank or Protein FASTA file(s) that you want to annotate genes from as the first priority, use the --proteins myfile.gbk.
##prokka --proteins MG1655.gbk --outdir mutant --prefix

##3. expert
##prokka --kingdom Archaea --outdir mydir --genus Pyrococcus --locustag PYCC
##prokka  --kingdom Bacteria --gcode 11 --locustag ${tmp} --genus Klebsiella --species pneumonia --outdir prokka_roary_gm_analysis/${tmp} --prefix ${tmp} --force $name
##search for your favorite gene
##exonerate --bestn 1 zetatoxin.fasta mydir/PYCC_06072012.faa | less

##4. wizard
##prokka --outdir mydir --locustag EHEC --proteins NewToxins.faa --evalue 0.001 --gram neg --addgenes contigs.fa
## Check to see if anything went really wrong
## less mydir/EHEC_06072012.err

##-rawproduct      Do not clean up /product annotation (default OFF)
##Prokka annotates proteins by using sequence similarity to other proteins in its database, or the databses the user provides via --proteins. By default, Prokka tries to "cleans" the /product names to ensure they are compliant with Genbank/ENA conventions. Some of the main things it does is:
##set vague names to hypothetical protein
##consistifies terms like possible, probable, predicted, ... to putative
##removes EC, COG and locus_tag identifiers
##
