##http://mummer.sourceforge.net/manual/

##1. mummer locates maximal unique matches between two sequences using a suffix tree data structure, generating lists of exact matches that can be displayed as a dot plot, or used as anchors in generating pair-wise alignments.
##mummer [options] <reference file> <query file1> ... <query file32>
##Both the reference and qurey files should be in mutil-FastA format, the maximum number of query files is 32, no limit on how many sequences each reference or qurey file may contain.

##2. nucmer, for the alignment of multiple closely related nucleotie sequences. It begains by finding maximal exact matches of a given length, it then clusters these matches to form larger inexact alignment regions, and finally, it extends alignments outward from each of the matches to join the clusters into a single high scoring pair-wise alignment.
##nucmer [options] < reference file> <qurey file>
##Both the reference and query file should be in multi-FastA format, however only the DNA characters will be aligned. For the output file out.delta, the user should convert the format to display the alignment by show-aligns and show-coords. To mask the input sequences to avoid the alignment of uninteresting sequences.

##3. aligns the multiple somewhat divergent nucleotide suqences. It works like the nucmer, the input sequences are translated in all six amino acid reading frames before any of the exacting matching takes place. This allows promer to identify regions of conserved protein sequences that may not be conserved on the DNA leves and thus gives it a higher sensitivity than nucmer. To mask the input sequences to avoid the alignment of uninteresting sequences.
##promer [options] < reference file> <query file>
##Both the reference and query files should be in multi-FastA format and many contain any set of upper and lowercase characters, however only valid DNA characters will result in correctly translated sequence, all other characters will be translated into masking characters and therefore will not be mathed by the BLOSUM scoring matrix. The output should be processed as the nucmer does.

##4. run-nummer1 and run-mummer3, for the general alignment of two sequences, they follow the same three steps of nucmer and promer, in that they match, cluster and extend, however they handle any input sequence, not just nuclotide. They are good at aligning very similar DNA sequences and identifying their differences, this makes them well suited for SNP and error detection. run-mummer1 is reconmmended for one vs. one comparisons with no rearrangements, while run-mummer3 is reconmmend for one vs. many comparisons that many involved rearrangements.
##run-mummer1 <reference file> <qurey file> <prefix> [-r]
##run-mummer3 <reference file> <query file> <prefix>
##The reference and query file should both be in FastA format and many contain any set of upper and lowercase characters. The -r options for run-mummer1 reverses the query sequence, while run-mummer3 automatically finds both forward and reverse mathces.



##Aliging two finished sequences
##mummer -mum -b -c ref.fasta qry.fasta > ref_qry.mums
##mummerplot --postscript --prefix=ref_qry ref_qry.mums
##gnuplot ref_qry.gp

##Highly similar sequences without rearrangements, compare two near identical sequences, the object of the alignment is usually SNP and small indel indentification.
##run-mummer1 ref.fasta qry.fasta ref_qry
##match on the reverse strand
##run-mummer1 ref.fasta qry.fasta ref_qry_r -r

##Highly similar sequences with rearrangements, often two sequences are highly similar, but large chunks of the sequence are rearranged, inverted and inserted. 
##To hunt for SNPs more accurately, you can edit the script and add the -D option to the combineMUMS command line, thus producing a concise file of only the difference positions between the two sequecnes.
##rum-mummer3 ref.fasta qry.fasta ref_qry

##Fairly similar sequences, run-mummer1 and run-mummer3 focus more on what is different between two sequences, nucmer focuses on what is the same. Rearrangements, inversions and repeats will all be indentified by nucmer. For a single reference sequence ref.fasta and a single query sequecne qry.fasta in FastA fromat.
##nucmer --maxgap=500 --mincluster=100 --profix=ref_qry ref.fasta qry.fasta
##show-coords -r ref_qry.delta > ref.qry.delta.coords
##show-aligns ref_qry.delta refname qryname > ref_qry.delta.alings
##The refname and qryname are the FastA IDs of the two sequences. With the mummerplot to display the voluminous result, and can be filtered by delta-filter, to exihibt the one-to-one local mapping of reference to query sequence.
##delta-filter -q -r ref_qry.delta > ref_qry.delta.filter
##mummerplot ref_qry.delta.filter -R ref.fasta -Q qry.fasta  cant work!!!

##Fairly dissimilar sequences. Sometimes two sequences exhibit poor similarity on the DNA level, but their protein sequences are conserved. Promer will be the most useful MUMmer tools, since it translates the DNA input sequences into amino acids before processing with the alignment.
##promer --prefix=ref_qry ref.fasta qry.fasta
##show-coords -r ref_qry.delta > ref_qry.delta.coords
##show-aligns -r ref_qry.delta refname qryname > ref_qry.delta.aligns  mummerplot cant work

##Aligning two draft sequences. Align two sets of contigs, scaffolds or chromosomes, if two divergent for nucmer, use promer instead.
##nucmer --prefix=ref_qry ref.fasta qry.fasta
##shouw-coords -rcl ref_qry.delta > ref_qry.delta.coords
##show_aligns ref_qry.delta refname qryname > ref_qry.delta.qligns
##To yield a one-to-one mapping of each reference and query, delta-filter -r -q
##delta-filter -r -q ref_qry.delta > ref_qry.delta.filter
##mummerplot ref_qry.delta -R ref.fasta -Q qry.fasta --filter --layout

##Mapping a draft sequence to a finished sequence, nucmer or promer
##nucmer --prefix=ref_qry ref.fasta qry.fasta
##show-coords -rcl ref_qry.delta > ref_qry.delta.coords
##show-aligns ref_qry.delta refname qryname > ref_qry.aligns
##show-tiling ref_qry.delta > ref_qry.delta.tiling
##Output is to stdout, and consists of the predicted location of each aligning query contig as mapped to the reference sequences. These coordinates reference the extent of the entire query contig, even when only a certain percentage of the contig was actually aligned (unless the -a option is used). Columns are, start in ref, end in ref, distance to next contig, length of this contig, alignment coverage, identity, orientation, and ID respectively.
##mapping the draft sequences to each of their repeat locations, delta-filter program can quickly select the optimal placement of each draft sequence to the reference
##delta-filter -q ref_qry.delta > ref_qry.delta.filter

##SNP detection, to form a reliable SNP detecion pipeline. To select the one-to-one mapping and call the SNP positions. The user can then process these SNP positions to assign quality scores based on the underlying traces and surrounding context.
##To find a reliable set of SNPs bwtween highly similar multi-FastA sequence sets ref.fasta and qry.fasta
##nucmer --prefix=ref_qry ref.fasta qry.fasta
##show-snps -Clr ref_qry.delta > ref_qry.delta.snps
##-C in show-snps assures only snps found in uniquely aligned sequence will be reported, excluding snps contained in repeats. An alternative method which first attempts to determine the "correct" repeat copy
##nucmer --prefix=ref_qry ref.fasta qry.fasta
##delta-filter -r -q ref_qry.delta > ref_qry.delta.filter
##show-snps show-snps -C -I -T -r -l ref_qry.delta.filter > ref_qry.delta.filter.snps

##Identifying repeats, it has a few methods to indentify exact and exact tandem repeats. the nucmer alignment script can align a sequence(or set of sequences) to itself. By ignoring all of the hits that have the same coordinates in both inputs, one can generate a list of inexact repeats. When using this method of repeat detection, be sure to set the --maxmatch and --nosimplify options to ensure the correct results
##To find large inexact repeats 
##nucmer --maxmatch --nosimplify --prefix=seq_seq seq.fasta seq.fasta
##show-coords -r seq_seq.delta > seq_seq.delta.coords
##To find exact repeats of length 50 or greater in a single sequence seq.fastq
##repeat-match -n 50 seq.fasta > seq.repeats
##To find exact tandem repeats of length 50 or greater in a single sequence
##exact-tandems seq.fasta 50 > seq.tandems
