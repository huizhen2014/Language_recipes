##http://snpeff.sourceforge.net/SnpEff_manual.html#databasesNc

##ln -s /the/path/to/snpEff.config ~/.snpEff.config

##注意：data路径已在snpEff.config文件中提前说明

##1. mkdir data/GRCh37.7
##   cd data/GRCh37.70

##2. download annotated genes gtf/gff/protein/cds/regulatory
##mv Homo_sapiens.GRCh37.70.gtf.gz genes.gtf.gz
##mv mv Homo_sapiens.GRCh37.70.pep.all.fa.gz protein.fa.gz
##mv mv Homo_sapiens.GRCh37.70.cdna.all.fa.gz cds.fa.gz
##mv mv AnnotatedFeatures.gff.gz regulation.gff.gz
##gunzip *.gz

##3. mkdier data/genomes
##cd data/genomes
##download genome
##mv mv Homo_sapiens.GRCh37.70.dna.toplevel.fa.gz GRCh37.70.fa.gz
##gunzip GRCh37.70.fa.gz

##4. edit snpEff.config file
##add lines
##GRCh37.70.genome : GRCh37.70
##GRCh37.70.reference : /Data_analysis_ref_database/data/genomes

##5. 构建本地数据库,以上满足genes.gff和protein.fa，即可构建，以免注释文件多出现信息对不上，build失败
##snpEff build -c ~/.snpEff.config -v GRCh37.70 --gff3

##6. 运行
##snpEff -c ~/.snpEff.cofing GRCh37.70 test.vcf
