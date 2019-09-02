##SCOTTI(structured coalescent transmission tree inference) 
##predefined assumptions:1. all hosts have the same infection rate and that it stays constant over the course of infection; 2. the infection is equally likely between every pair of hosts; 3. all hosts have the same effective population size, Ne.
##all hosts have the same within-host genetic diversity and thus all hosts have equal and constant within-host dynamics.

##TreeAnnotator
##summarise the posterior sample of trees to produce a maximum clade credibility tree
##Tracer
##summarise the posterior estimates of the various parameters sampled by the Markov Chain; view median estimates and 95% highest posterior density intervals of the parameters, and calculates the effective sample size(ESS) of parameters; investigate potential parameter correlations.
##FigTree
##view trees and producing publication-quality figures; interpret the node-annotations; display node-based statistics(e.g. posterior probabilities)

##a third, optional, script that makes use of the graph-tool package to produce a better looking figure. users could install by homebrew

##--maxHosts maximum number of hosts (between sampled, non-sampled, and non-observed) allowed.
#python SCOTTI_generate_xml.py --fasta parsnp.multi-fasta.align --dates TEST_dates.csv --hosts TEST_hosts.csv --hostTimes TEST_hostTimes.csv --maxHosts 20 --output TEST_parsnp.FMDV

##Open Tracer and load the file FMDV.log, check the parameter traces.

##Open TreeAnnotator set the Burnin percentage to 10, change the Output file to FMDV.MCC.tree

##Open FigTree and load FMDV.MCC.tree

##Constructing the transmission network
python Make_transmission_tree_alternative.py --inputF TEST_parsnp.FMDV.trees --outputF TEST_parsnp.FDMV.transmissiom.pdf
