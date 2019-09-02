##https://github.com/katholt/kaptive

##Kaptive reports information about K and O types for Klebsiella genome assemblies. 
##? = the match was not in a single piece, possible due to a poor match or discontiguous assembly.
##- = genes expected in the locus were not found.
##+ = extra genes were found in the locus.
##* = one or more expected genes was found but with low identity.

##程序一次全部读入，所以命名的后缀出现了累加；因此，&&分阶段运行

##for the capsule polysacharides K
##kaptive.py -k /Data_analysis/ref_database/kaptive_database/Klebsiella_k_locus_primary_reference.gbk -a ./*.fasta -o ./kaptive_result/kaptive_k && echo "Done $(date)"

##for the lipopolysaccharides O
##kaptive.py -k /Data_analysis/ref_database/kaptive_database/Klebsiella_o_locus_primary_reference.gbk -a ./*.fasta -o ./kaptive_result/kaptive_o && echo "Done $(date)"

##combine the o and k output files 
##awk 'BEGIN{
##    while((getline<"kaptive_result/kaptive_o_table.txt")>0){
##    TMP[++i]=$0
##    }
##}
##{
##    print TMP[NR]
##    if(NR!=1)print $0
##}' kaptive_result/kaptive_k_table.txt > kaptive_result_ok.txt

