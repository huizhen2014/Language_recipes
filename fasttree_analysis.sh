##http://www.microbesonline.org/fasttree/

##FastTree uses the Jukes-Cantor or generalized time-reversible (GTR) models of nucleotide evolution and the JTT (Jones-Taylor-Thornton 1992), WAG (Whelan & Goldman 2001), or LG (Le and Gascuel 2008) models of amino acid evolution.

##input formats: multiple sequence alignment in fasta format or in interleaved phylip format
##To infer a tree for a protein alignment with the JTT+CAT model
##fasttree alignment.file > tree_file

##Use the -wag or -lg to use the WAG+CAT or LG+CAT model instead
##To infer a tree for a nucleotide alignment withe the GTR+CAT model
##fasttree -gtr -nt alignment.file > tree_file

