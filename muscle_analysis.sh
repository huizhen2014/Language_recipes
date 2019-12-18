http://www.drive5.com/muscle/manual/

Diagonal optimization

Creating a pair-wise alignment by dynamic programming requires computing an N x M matrix, where N and M are the sequence lengths. A trick used in algorithms such as BLAST is to reduce the size of this matrix by using fast methods to find "diagonals", also called "gapless high-scoring segment pairs", i.e. short regions of high similarity between the two sequences. This speeds up the algorithm at the expense of some reduction in accuracy. MUSCLE uses a technique called k-mer extension to find diagonals, which is described in this paper:

Edgar, R.C. (2004) Local homology recognition and distance measures in linear time using compressed amino acid alphabets, Nucleic Acids Res., 32, 1. [Pubmed].

It is disabled by default because of the slight reduction in average accuracy, and can be turned on by specifying the –diags option. To enable diagonal optimization only in the first iteration, use –diags1, to enable diagonal optimization in the second iteration only use –diags2. These are provided separately because it would be a reasonable strategy to enable diagonals in the first iteration but not the second (because the main goal of the first iteration is to construct a multiple alignment quickly in order to improve the distance matrix, which is not very sensitive to alignment quality; whereas the goal of the second iteration is to make the best possible progressive alignment).

anchor optimization

Tree-dependent refinement (iterations 3, 4 ... ) can be speeded up by dividing the alignment vertically into blocks. Block boundaries are found by identifying high-scoring columns (e.g., a perfectly conserved column of Cs or Ws would be a candidate). Each vertical block is then refined independently before reassembling the complete alignment, which is faster because of the L2 factor in dynamic programming (e.g., suppose the alignment is split into two vertical blocks, then 2 x 0.5^2 = 0.5, so the dynamic programming time is roughly halved). The –noanchors option is used to disable this feature. This option has no effect if –maxiters 1 or –maxiters 2 is specified. On benchmark tests, enabling or disabling anchors has little or no effect on accuracy, but if you want to be very conservative and are striving for the best possible accuracy then –noanchors is a reasonable choice.

1. make an alignment and save to a file in FASTA format

muscle -in seqs.fa -out seqs.afa

2. write alignment to the console in CLUSTALW format(more readable than FASTA)

muscle -in seqs.fa -clw

3. make a UPGMA tree from a multiple alignment

UPGMA (unweighted pair group method with arithmetic mean) is a simple agglomerative (bottom-up) hierarchical clustering method. Note that the unweighted term indicates that all distances contribute equally to each average that is computed and does not refer to the math by which it is achieved.

muscle -maketree -in seqs.afa -out seqs.phy

4. make a Neighbor-Joining tree from a multiple alignment

In bioinformatics, neighbor joining is a bottom-up (agglomerative) clustering method for the creation of phylogenetic trees. Usually used for trees based on DNA or protein sequence data, the algorithm requires knowledge of the distance between each pair of taxa (e.g., species or sequences) to form the tree.

Neighbor-joining trees will usually be a better estimate of the true phylogenetic tree. UPGMA is faster, which can be useful with large datasets when N-J is too slow.

muscle -maketree -in seqs.afa -out seqs.phy -cluster neighborjoining

refineing an existing alignment

muscle -in msa.afa -out refined_msa.afa -refine

5. Specified using the -out option. The tree is written in Newick format, which is supported by most phylogenetic analysis packages such as PHYLIP. 