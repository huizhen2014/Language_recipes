##http://vfsmspineagent.fsm.northwestern.edu/index_age.html
##https://sourceforge.net/projects/clustage/files/

##prepare for the spine.pl by annotating the fasta with prokka
#for file in $(find $(pwd) -maxdepth 1 -name "*.fasta")
#    do
#	tmp=${file##*/}
#	tmp=${tmp%[-_]*}
#	prokka --kingdom Bacteria --prefix ${tmp}_pan --outdir ${tmp}_pan_prokka --locustag ${tmp}_pan $file && echo "Done prokka $(date)"
#	dir=$(pwd)
#	printf "%s\t%s\n" $(dir)/${tmp}_pan_prokka/${tmp}_pan.gbk "gbk" >> "spine_input_tmp.txt"
#	done

##1. spine.pl use the nucmer to get the intersect interval for each input files, and the combine all the intersect files to get the common intersect interval, so the aggregate interval will be the core interval
## the output backbone.fasta is the core seq of the first input fasta file
##mkdir spine_output
##spine.pl -t 2 -f spine_input.txt -o spine_output/spine_output && echo "Done spine $(date)"
##spine.pl -r 1 -f pan_spine_input.txt -o pan_spine_output
#mkdir pan_spine_output_90
#spine.pl -t 2 -p 90 -f spine_input.txt -o pan_spine_output_90/pan_spine_output_90 && echo "Done spine $(date)"

##mkdir pan_spine_output_95
##spine.pl -t 2 -p 95 -f spine_input.txt -o pan_spine_output_95/pan_spine_output_95 && echo "Done spine $(date)"

##2. AGEnt.pl to extract the accessory seq for the qurey seq by the core seq outputed by spine.pl
## for the other files, you want to extract the core or accessory seq according to the core seq from the spine.pl
##AGEnt.pl -r file_of_core_genoem -q /Data_analysis/MIC_discrepancy_analysis/Positive_samples/38588-scaffolds.fasta -o pefix_output

## 3. annotate the core and accessory seq, to check whether the core seq has the different mutations or the accessory seq has divergent genes.

## 4. ClustAGE.pl, takes a set of nucleotide sequences of accessory genomic elements(AGEs) from bacterial or other small genome organisms and cluster them to identify the minimum set of acessory genomic elements in the genomes. ClustAGE will also determine the distribution of each accessory genomic element among the provided genomic sequences.
ClustAGE.pl -t 2 -f age_input.txt -p --annot annot_input.txt -o clustage_output

## 5. subelements_to_tree.pl This pipeline script calculates a Bray-Curtis distance matrix from distributions of accessory elements that it uses to create a neighbor joining tree of accessory element distribution patterns. Note these distances are not based on sequence similarity, but only on presence or absence of an accessory element within a genome within the threshold parameters given to ClustAGE. It will also produce output files that can be used to create a heatmap of Bray-Curtis similarity values.
##subelements_to_tree.pl -c out_subelements.csv -k out_subelements.key.txt -o subelements.tree.out
