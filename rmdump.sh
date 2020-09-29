

rmdup=/Users/carlos/Bin/picard-tools-1.119/MarkDuplicates.jar

java -jar ${rmdup} \
I=ERR654293.RNAP_beta_filtered_sorted.bam \
O=ERR654293.RNAP_beta_filtered_sorted_rmdup.bam \
METRICS_FILE=ERR654293.RNAP_beta_filtered_sorted_rmdup.log \
REMOVE_DUPLICATES=true


java -jar ${rmdup} \
I=ERR654288.untagged_filtered_sorted.bam \
O=ERR654288.untagged_filtered_sorted_rmdup.bam \
METRICS_FILE=ERR654288.untagged_filtered_sorted_rmdup.log \
REMOVE_DUPLICATES=true

