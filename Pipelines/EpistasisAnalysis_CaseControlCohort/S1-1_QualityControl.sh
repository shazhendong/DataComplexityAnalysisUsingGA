# This sh file performs quality control for the case-control GWAS data using PLINK.
# Author: Zhendong Sha@2023-01-26

# Parameters
# Path to the data
data=/Volumes/WorkingProj/DataComplexityAnalysisUsingGA/data_epistasis/GWAS/1st\(190cases575controls\)
# Path to the output
output=/Volumes/WorkingProj/DataComplexityAnalysisUsingGA/res_epistasis/processed_case_control_GWAS
# Path to the scripts
scripts=/Volumes/WorkingProj/DataComplexityAnalysisUsingGA/scr/DatasetPrep/GWAS_QualityControl
# name of the data
data_name=axiom_corect_nf_ab_20130612


# Create the output folder
rm -rf $output
mkdir $output
cp $data/* $output

cd $output
#### Per-individual QC ####

# (i) the removal of individuals with discordant sex information
plink --bfile $data_name --check-sex --out QC_sexcheck
grep "PROBLEM" QC_sexcheck.sexcheck > sexcheck_failedRows.txt
awk '{ print $1, $2 }' sexcheck_failedRows.txt > sexcheck_removeIndi.txt # save removed individual
plink --bfile $data_name --remove sexcheck_removeIndi.txt --make-bed --out ${data_name}_ori-sexcheck

# (ii) the removal of individuals with outlying missing genotype or heterozygosity rates
plink --bfile ${data_name}_ori-sexcheck --mind 0.01 --make-bed --out ${data_name}_sexcheck-sampMiss
plink --bfile ${data_name}_sexcheck-sampMiss --het --out QC_hetcheck
Rscript $scripts/heterozygosity_outliers_list.R
plink --bfile ${data_name}_sexcheck-sampMiss --remove fail-het-qc.txt --make-bed --out ${data_name}_sampMiss-heteCherck

# (iii) the removal of duplicate individuals
plink --bfile ${data_name}_sampMiss-heteCherck --genome --min 0.5
awk '{ print $3, $4 }' plink.genome > remove_subjects.txt
plink --bfile ${data_name}_sampMiss-heteCherck --remove remove_subjects.txt --make-bed --out ${data_name}_heteCherck-dupRemoval

#### Per-marker QC ####

# (i) the removal of markers with an excessive missing genotype rates
plink --bfile ${data_name}_heteCherck-dupRemoval --geno 0.01 --make-bed --out ${data_name}_dupRemoval-missGeno

# (ii) the removal of SNPs showing a significant deviation from Hardy-Weinberg equilibrium (HWE)
plink --bfile ${data_name}_dupRemoval-missGeno --hwe 0.000001 --make-bed --out ${data_name}_missGeno-HWE

# (iii) the removal of all markers with a very low minor allele frequency (MAF)
plink --bfile ${data_name}_missGeno-HWE --maf 0.01 --make-bed --out ${data_name}_HWE-MAF

# (iv) the removal of markers with LD > 0.2
plink --bfile ${data_name}_HWE-MAF --indep-pairwise 2000 100 0.2 --out QC_LD
plink --bfile ${data_name}_HWE-MAF --extract QC_LD.prune.in --make-bed --out ${data_name}_MAF-LD

#### Preparing the data for analysis ####

# rename the data file
cp ${data_name}_MAF-LD.bed ${data_name}_processed.bed
cp ${data_name}_MAF-LD.bim ${data_name}_processed.bim
cp ${data_name}_MAF-LD.fam ${data_name}_processed.fam
cp ${data_name}_MAF-LD.log ${data_name}_processed.log

echo "Note: the data has been processed with missingness rate < 1%, HWE < 0.000001, MAF > 0.01, LD < 0.2. You need to perform data imputation before analysis."

