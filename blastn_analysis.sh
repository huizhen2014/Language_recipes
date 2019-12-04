###https://github.com/enormandeau/ncbi_blast_tutorial
###tblastx是核酸序列到核酸库中的一种查询。此种查询将库中的核酸序列和所查的核酸序列都翻译成蛋白（每条核酸序列会产生6条可能的蛋白序列），这样每次比对会产生36种比对阵列。
###blastn search mapping condition
###

##1. Create blast database
##-type nucl  告诉软件这是核酸序列数据库
##-parse_seqids parse seqid for FASTA
##-hash_index   create index of sequence hash values
#makeblastdb -in kpc_ref/blaKPC-2.fsa -hash_index -dbtype nucl -out databases/blaKPC-2

##2. blast
##-evalue le-3, 表示10的-3次方，e表这是一种指数形式的计数方法。由数符、十进制数、阶码标志'E'或'e'以及阶符和阶码组成。
##如：1e-3的数符为'+'，十进制数为1，阶码为'-'，阶码为3
##注：阶码标志'E'或'e'之前必须有数字。
##S: S值表示两个序列的同源性，分值越高表示它们之间相似的程度越大
##E: S值的可靠性，表随机情况下，其他序列能和目标序列相似度大于S值的可能性，所以改值越小越好
##E=K*m*n(e^-lambada*S), K和lambada与数据库及算法有关，常量；m代表目标序列的长度，n代表数据库的大小，S就是前面提到的S值
##E值局限性：1. 当目标序列过小是，E值偏大，因无法的到较高S值；2. 在有gap情况下，两序列同源性高，但S值会下降；3. 序列非功能区域的有较低随机性，可能会导致两序列较高同源性
##btop: 简述比对情况, 数字表示匹配; GA表示G变成了A; -表示gap; * tblastx表示gap
mkdir result_blaIMP/ && echo "Done create result dir"
printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" "Scaffold" "query_id" "qlen" "qstart" "qend" "sseqid" "slen" "sstart" "send" "length" "pident" "mismatch" "gapopen" "bitscore" "evalue" "btop" >>result_blaIMP/blastn_blaIMP
for query in $(find ../ -type l -name "*.fasta")
		do
				name=${query##*/}
				name=${name%.fasta}
				echo $name
				blastn -evalue 1e-2 -db database/blaIMP -query $query -outfmt "6 qseqid qlen qstart qend sseqid slen sstart send length pident mismatch gapopen bitscore evalue btop" >result_blaIMP/${name}.blastn && echo "Done $name blastn"
				awk -v n="$name" '!/^#/{printf("%s\t%s\n",n,$0)}' result_blaIMP/${name}.blastn >>result_blaIMP/blastn_blaIMP && echo "Done $name awk print"
				done
				
##3. Translated Query-Translated Subject tblastx
##Add the same prot database to the same nucl database
#makeblastdb -in kpc_ref/blaKPC-2.fsa -hash_index -dbtype nucl -out databases/blaKPC-2
#makeblastdb -in kpc_ref/blaKPC-2.fsa -hash_index -dbtype prot -out databases/blaKPC-2

###tblastx 
##-db_gencode
##tblastx -evalue 1e-2 -db database/blaKPC-2 -db_gencode 11 -query tmp.fasta -outfmt "6 qseqid qstart qend sseqid sstart send length pident mismatch gapopen bitscore evalue btop" >tmp_test.map  && echo "Done $name blastn"
