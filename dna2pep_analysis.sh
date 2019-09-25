###dna2pep - full featured computational translation of DNA to peptide.

###dna2pep natively understands TAB files containing Intron/Exon annottaion(gb2tab/FeatureExtract)
###Input files can be in fasta(no intron/exon annotation) raw (single sequence with no header) or TAB(incluing annotation) format.

###Usage
##dna2pep [options] [input files] [-f outfile]

##-F, --outfile, or print to screeen
##-O, --outformat, --fasta, --tab, --report, default AUTO, both the report and sequence output
##-m, genetic code model, 1, standard code; 11, bacterial and plant plastid code
##-r, --readingframe=x, 1, default, from the frame 1, 3, from the frame 3;-1, from the minus strand 1; -3, from the minus strand 3...; or all/plus/minus


