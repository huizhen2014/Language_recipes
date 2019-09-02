##https://github.com/microgenomics/tutorials/blob/master/pangenome.md

##1. annotating genomes
## Add information regarding genes, their loaction, standedness, and features and attributes. Use prokka, which is extemely fast and performs well, and also the feature file that produces (GFF3) is compatible with Roary.

##prokka --kingdom Bacteria --prefix 36170_pan --outdir 36170_pan_prokka --locustag 36170_pan /Data_analysis/mic_divergent_analysis/Divergent_smaples_spine_agent/pan_analysis/36170-scaffolds.fasta
##prokka --kingdom Bacteria --prefix 34978_pan --outdir 34978_pan_prokka --locustag 34978_pan /Data_analysis/mic_divergent_analysis/Divergent_smaples_spine_agent/pan_analysis/34978-scaffolds.fasta
##prokka --kingdom Bacteria --prefix 36013_pan --outdir 36013_pan_prokka --locustag 36013_pan /Data_analysis/mic_divergent_analysis/Divergent_smaples_spine_agent/pan_analysis/36013-scaffolds.fasta
##prokka --kingdom Bacteria --prefix 42277_pan --outdir 42277_pan_prokka --locustag 42277_pan /Data_analysis/mic_divergent_analysis/Divergent_smaples_spine_agent/pan_analysis/42277_scaffolds.fasta
##prokka --kingdom Bacteria --prefix 38377_pan --outdir 38377_pan_prokka --locustag 38377_pan /Data_analysis/mic_divergent_analysis/Divergent_smaples_spine_agent/pan_analysis/38377-scaffolds.fasta
##prokka --kingdom Bacteria --prefix 40702_pan --outdir 40702_pan_prokka --locustag 40702_pan /Data_analysis/mic_divergent_analysis/Divergent_smaples_spine_agent/pan_analysis/40702_scaffolds.fasta
##prokka --kingdom Bacteria --prefix 42474_pan --outdir 42474_pan_prokka --locustag 42474_pan /Data_analysis/mic_divergent_analysis/Divergent_smaples_spine_agent/pan_analysis/42474_scaffolds.fasta
##prokka --kingdom Bacteria --prefix 38533_pan --outdir 38533_pan_prokka --locustag 38533_pan /Data_analysis/mic_divergent_analysis/Divergent_smaples_spine_agent/pan_analysis/38533-scaffolds.fasta
##prokka --kingdom Bacteria --prefix 42395_pan --outdir 42395_pan_prokka --locustag 42395_pan /Data_analysis/mic_divergent_analysis/Divergent_smaples_spine_agent/pan_analysis/42395_scaffolds.fasta
##prokka --kingdom Bacteria --prefix 40847_pan --outdir 40847_pan_prokka --locustag 40847_pan /Data_analysis/mic_divergent_analysis/Divergent_smaples_spine_agent/pan_analysis/40847_scaffolds.fasta
##prokka --kingdom Bacteria --prefix 36472_pan --outdir 36472_pan_prokka --locustag 36472_pan /Data_analysis/mic_divergent_analysis/Divergent_smaples_spine_agent/pan_analysis/36472-scaffolds.fasta
##prokka --kingdom Bacteria --prefix 38218_pan --outdir 38218_pan_prokka --locustag 38218_pan /Data_analysis/mic_divergent_analysis/Divergent_smaples_spine_agent/pan_analysis/38218-scaffolds.fasta

##2. determining the pangenome
## put all the .gff files in the same folder
## -e create a multiFASTA alignment of core genes using PRANK
## -n fast core gene alignment with MAFFT, use with -e
#mkdir pan_roary_output
##roary -r -f . -n -e -v *.gff

##fasttree -nt -gtr gff/core_gene_alignment.aln > core_gene_alignment.newick
##change to the roary_plots.py to run the scripts with python3
##python3 roary_plots.py core_gene_alignment.newick gene_presence_absence.csv 

##3. qurey_pan_genome
##perform set operations on the pan genome to see the gene differences between groups of isolates
##you need all Roary output within the same folder as the .gff files so query_pan_genome works

##query_pan_genome -a union *.gff  ##union of genes 
##query_pan_genome -a intersection *.gff  ##core genes
##query_pan_genome -a complement *.gff  ##complement of genes found in isolates(accessory genes)

##extract the sequence of each gene
##query_pan_genome -a gene_multifasta -n grya,mecA,abc *.gff

##gene differences between sets of isolates
##query_pan_genome -a difference --input_set_one 42474_accessory.gff,42277_accessory.gff,40847_accessory.gff,40702_accessory.gff,38218_accessory.gff,36472_accessory.gff,36170_accessory.gff,36013_accessory.gff,34978_accessory.gff --input_set_two 42395_accessory.gff,38533_accessory.gff,38377_accessory.gff
