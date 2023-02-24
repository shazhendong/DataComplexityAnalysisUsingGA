# This pipeline perform complexity analysis for all dataset using the existing metrics.

#### Parameters ####

# set home directory to pwd
home=$(pwd)

data=$home/data
res=$home/res_problexityAnalysis
scr=$home/scr/problexityAnalysis

# create result folder
rm -r $res
mkdir -p $res

#### Main ####

# analyze GAMETES datasets
data_gametes=$data/GAMETES

# run complexity analysis
for file in $data_gametes/*.tsv
do
    echo $file
    # get file name
    name=$(basename $file)
    python $scr/problexityAnalysis.py -i $file -o $res/$name.csv -f tsv -p target
done

# analyze GEO datasets
data_geo=$data/GEOdatasets

for file in $data_geo/*.csv
do
    echo $file
    # get file name
    name=$(basename $file)
    python $scr/problexityAnalysis.py -i $file -o $res/$name.csv -f csv -p type
done

# analyze GWAS dataset
data_gwas=$data/GWAS/WithImputation
cd $data_gwas
python $scr/problexityAnalysis.py -i AllSamples_Imputation -o $res/AllSamples_Imputation.csv -f plink

# merge 
cd $res
python $scr/merge.py *.csv
