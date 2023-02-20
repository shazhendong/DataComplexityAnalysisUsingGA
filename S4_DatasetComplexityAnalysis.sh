# This sh file generates determin the depth for each dataset based on the result of S3-1_DepthPlot.sh. The result is saved in the folder "PredictivePerformance"

# Parameters
targetFold_root=res_1-100\(2\)
scr=scr/AnalysisGeneticAlgorithmResult
home=$(pwd)

# plot depth plot for GWAS data
echo "Processing GWAS"
targetFold=$targetFold_root/GWAS/PredictivePerformance
cd $targetFold
python $home/$scr/determin_depth.py res_simpleGAplusDT_summary_auc.csv res_simpleGAplusDT_summary_auc_depth.csv
python $home/$scr/determin_depth.py res_simpleGAplusLR_summary_auc.csv res_simpleGAplusLR_summary_auc_depth.csv
cd $home

# plot depth plot for GAMETES data
# itearate through all GAMETES dataset folders
echo "Processing GAMETES"
for folder in $(ls $targetFold_root/GAMETES)
do
    echo $folder
    targetFold=$targetFold_root/GAMETES/$folder/PredictivePerformance
    cd $targetFold
    python $home/$scr/determin_depth.py res_simpleGAplusDT_summary_auc.csv res_simpleGAplusDT_summary_auc_depth.csv
    python $home/$scr/determin_depth.py res_simpleGAplusLR_summary_auc.csv res_simpleGAplusLR_summary_auc_depth.csv
    cd $home
done

# plot depth plot for GEO data
# itearate through all GEO dataset folders
echo "Processing GEO"
for folder in $(ls $targetFold_root/GEO_Datasets)
do
    echo $folder
    targetFold=$targetFold_root/GEO_Datasets/$folder/PredictivePerformance
    cd $targetFold
    python $home/$scr/determin_depth.py res_simpleGAplusDT_summary_auc.csv res_simpleGAplusDT_summary_auc_depth.csv
    python $home/$scr/determin_depth.py res_simpleGAplusLR_summary_auc.csv res_simpleGAplusLR_summary_auc_depth.csv
    cd $home
done
