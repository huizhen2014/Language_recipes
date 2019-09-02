##snippy finds SNPs bwtween a haploid reference genome and your NGS sequence reads, it will find both substitutions(snps) and insertions/deletions(indels)
##https://github.com/tseemann/snippy

##默认条件下，使用尽可能多多CPUs；可对同一参考基因组检出的各样本的snps做进化关系树;若使用gbk文件作文参考基因组，同时在输出中将会给对对应注释信息
##--cpus 16
##--ref 参考基因组，可以是fasta或genbank格式
##--R1/--R2 输入序列文件可以是fastq或fasta格式
##--outdir 输出文件夹
##--rgid 设置Read Group ID和Sample SM信息，若未指定，使用--outdir命名ID和SM
##--mapqual 变异满足的最小比对质量,BWA MEM使用60表示‘uniquely mapped'
##--basequal 变异用于检出变异需要满足的最小的核酸质量，默认使用13，对应约5%的错误率,为samtools一般使用值
##--mincov 一个位点需要满足的最小的read数(默认为10)
##--minfrac 满足不同于refrence的最小reads比例，默认为0.9
##--minqual 最小的vcf variant call ‘quality’(默认为100)
##--targets 指定BED文件用于指定检出变异位置范围
##--report 自动输出snps.report.txt文件，对应显示snps.vcf中的snps的比对情况；可在运行后在输出目录运行：snippy-vcf_report --cups 8 --autuo > snps.report.txt
##或输出web版本report：snippy-vcf_report --html --cpus 16 --auto > snps.report.html
##.aligned.fa 输出文件参考文件对应比对信息，-表示深度为0，N表示深度大于0但是小于mincov
snippy --force --outdir 39401_mutations --ref GCF_000240185.1_ASM24018v2_genomic.gbff --R1 39401_trimed_1P.fq.gz --R2 39401_trimed_2P.fq.gz 1 > 39401_mutations_snippy.log 2>&1

snippy-vcf_reports --cups 8 --auto > snps.report.txt

##使用相同的参考基因组对多重样本检出变异信息,进而可以构建'cors SNPs'比对，用于构建high-resolution phylogeny(忽略可能的重组)。'core site'为存在于所有样本中的变异位置。在不考虑ins,del变异类型，仅使用variant sits,那么就为'core SNP genome'。
##建议直接使用snippy-multi，指定多重输入文件，同时自动运行snippy-core
snippy-core --ref GCF_000240185.1_ASM24018v2_genomic.gbff AH30/AH30_snippy_results/ AH2/AH2_snippy_results/ A7819/A7819_snippy_results/ ... 
##core.full.aln为fasta格式多重序列比对文件。含一个参考基因组序列，每个输入文件各一个序列文件,同时每条序列都有和参考序列一样的长度
##ATGC表示和reference序列相同
##atgc表示和reference序列不同
##-表示该样本位置覆盖度为0或者相对与reference出现删除
##N表示该样本位置覆盖度低于--mincov
##X表示reference序列的masked位置(来自--mask)
##n表示杂合区域或低质量基因行(GT=0/1或QUAL&lt; --minqual in snps.raw.vcf)
##去除core.full.aln中的'weired'字符，通过snippy-clean_full_aln使用N取代, 进而可用于构建pholygenic tree或recombination-removal tool
##使用'N'取代core.full.aln中的非[ATCG-]字符
snippy-clean_full_aln core.full.aln > clean.full.aln

##run_gubbins.py -p gubbins clean.full.aln

##从多重比对文件中提取snp信息
snp-sites -c gubbins.filtered_polymorphic_sites.fasta > clean.core.aln
snp-sites -c -o core.aln clean.full.aln
##构建SNPs phylogenetic tree
FastTree -gtr -nt clean.core.aln > clean.core.tree
