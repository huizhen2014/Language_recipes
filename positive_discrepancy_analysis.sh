## mlst call ST

##mlst --csv *.fasta > mlst_positive.csv

##kaptive.py for the klebsiella pnuemoniae, only
##for the capsular polysaccharides K
##kaptive.py -k /Data_analysis/ref_database/kaptive_database/Klebsiella_k_locus_primary_reference.gbk -a ./*.fasta -o ./kaptive_result/kaptive_k && echo "Done $(date)"

##for the capsular polysaccharides k variant
##kaptive.py -k /Data_analysis/ref_database/kaptive_database/Klebsiella_k_locus_variant_reference.gbk -a ./*.fasta -o ./kaptive_result/kaptive_k_variant && echo "Done $(date)"

##for the lipopolysaccharides O
##kaptive.py -k /Data_analysis/ref_database/kaptive_database/Klebsiella_o_locus_primary_reference.gbk -a ./*.fasta -o ./kaptive_result/kaptive_o && echo "Done $(date)"

##combine the kaptive.py results
#awk 'BEGIN{
#    while((getline<"kaptive_result/kaptive_o_table.txt")>0){
#	O[++i]=$0
#    }
#    while((getline<"kaptive_result/kaptive_k_table.txt")>0){
#	K[++j]=$0
#    }
#}
#{
#    print $0
#    if(NR!=1)print O[NR]
#    if(NR!=1)print K[NR]
#	
#}' kaptive_result/kaptive_k_variant_table.txt > kaptive_positive_result_ok.txt && echo "Done kaptive $(date)"

## plasmidfilder
##batch process script
##for name in $(find $(pwd) -maxdepth 1 -name "*.fasta")
##    do
##	tmp=${name##*/}
##	tmp=${tmp%%[-_]*}
##	mkdir ${tmp}_plasmidfinder_output
##	plasmidfinder.py -x -i $name -o ${tmp}_plasmidfinder_output -p plasmidfinder_db	
##	done

## Cocatenate the plasmidfinder results
##for name in $(find $(pwd) -name "*results_tab.tsv")
##    do 
##	tmp=${name##*high_mic/}
##	tmp=${tmp%%[-_]*}
##	awk -v NAME=$tmp '{print NAME"\t"$0}' $name >> tmp
##	done

##awk 'NR>1 && $2 != "Database"{print}NR==1{print}' tmp | sed '1,1 s/[0-9]\{5\}/sample/' >plasmidfinder_positive.results
#rm -rf tmp

## staramr scans 
##staramr search --output-hits-dir positive_staramr_hits_output --output-excel staramr_positive_result.xlsx /Data_analysis/k.pnuemoniae_divergetn_mic/high_mic/*.fasta

##rgi analysis
##&& 表示上一个命令成功执行完成后，才执行下一个命令
##& 表示后台多线程同时进行
##rgi main --clean --input_sequence XX.fasta --output_file rgi_positive_result/xx_output --input_type contig

##mkdir rgi_positive_results

##for name in $(find $(pwd) -maxdepth 1 -name "*.fasta")
##    do
##	tmp=${name##*/}
##	tmp=${tmp%%[-_]*}
##	rgi main --clean --input_sequence $name --input_type contig --output_file ./rgi_positive_results/${tmp}_rgi_result && echo "${tmp}.scaffolds.fasta finished at $(date)"	
##	done

## rgi heatmap with AMR gene family categorization and fill display
##rgi heatmap --display fill --category gene_family --input /Data_analysis/MIC_discrepancy_analysis/Positive_samples/rgi_positive_results --output Positive_gene_family

##rgi heatmap with drug class category and frquency enabled
##rgi heatmap --frequency --category drug_class --display text --input /Data_analysis/MIC_discrepancy_analysis/Positive_samples/rgi_positive_results --output Positive_drug_class

##rgi hearmap with samples and genes clustered
##rgi heatmap --cluster both --input /Data_analysis/MIC_discrepancy_analysis/Positive_samples/rgi_positive_results --output Positive_cluster_both

##rgi heatmap with resistance mechanism categorization and clustered samples
##rgi heatmap --cluster samples --category resistance_mechanism --display fill --input /Data_analysis/MIC_discrepancy_analysis/Positive_samples/rgi_positive_results --output Positive_cluster_resistance

