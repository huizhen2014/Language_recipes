##http://etetoolkit.org/cookbook/ete_build_basics.ipynb


##Simplied by the scripts below
##############
## muscle -in EmrA_all_samples.faa -out EmrA_all_samples.align
## sed -e 's/Multidrug export protein EmrA//' EmrA_all_samples.align > EmrA_all_samples.align.modified
## fasttree EmrA_all_samples.align > EmrA_all_samples.nw
## ipython
## from ete3 import PhyloTre
## tree=PhyloTree("EmrA_all_samples.nw")
## tree.link_to_alignment("EmrA_all_samples.align.modified") ## since the name should be the same for the two files
## tree.render("EmrA_all_samples.pdf") 
## tree.show()
## print (tree)
################

