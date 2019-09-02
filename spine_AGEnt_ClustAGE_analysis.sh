##http://vfsmspineagent.fsm.northwestern.edu/index_age.html
##https://sourceforge.net/projects/clustage/files/

##1. spine.pl use the nucmer to get the intersect interval for each input files, and the combine all the intersect files to get the common intersect interval, so the aggregate interval will be the core interval
## the output backbone.fasta is the core seq of the first input fasta file
#mkdir spine_output
#spine.pl -t 2 -f total_input.txt -o spine_output/total_spine_output
#spine.pl -t 2 -f total_input.txt -e -n -o spine_output/total_spine_output
##spine.pl -r 1 -f positive_spine_input.txt -o positive_spine_output/positive


##2. AGEnt.pl to extract the accessory seq for the qurey seq by the core seq outputed by spine.pl
## for the other files, you want to extract the core or accessory seq according to the core seq from the spine.pl
##AGEnt.pl -r file_of_core_genoem -q /Data_analysis/MIC_discrepancy_analysis/Positive_samples/38588-scaffolds.fasta -o pefix_output

## 3. annotate the core and accessory seq, to check whether the core seq has the different mutations or the accessory seq has divergent genes.

## 4. ClustAGE.pl, takes a set of nucleotide sequences of accessory genomic elements(AGEs) from bacterial or other small genome organisms and cluster them to identify the minimum set of acessory genomic elements in the genomes. ClustAGE will also determine the distribution of each accessory genomic element among the provided genomic sequences.
##ClustAGE.pl -t 2 -f age_input.txt -p -o clustage
##ClustAGE.pl -t 2 -f ClustAGE_input.txt --annot ClustAGE_annot.txt -p -o clustage

## 5. subelements_to_tree.pl This pipeline script calculates a Bray-Curtis distance matrix from distributions of accessory elements that it uses to create a neighbor joining tree of accessory element distribution patterns. Note these distances are not based on sequence similarity, but only on presence or absence of an accessory element within a genome within the threshold parameters given to ClustAGE. It will also produce output files that can be used to create a heatmap of Bray-Curtis similarity values.
##subelements_to_tree.pl -c out_subelements.csv -k out_subelements.key.txt -o subelements.tree.out
