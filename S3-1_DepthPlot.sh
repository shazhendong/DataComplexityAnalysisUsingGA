# The pipeline specified in this script is used to generate the results for generating linear and non-linear depth.

#### Parameters ####
targetFold_root=res_1-20\(1\)
scr=scr
home=$(pwd)
size_lim_begin=1
size_lim_end=20
size_lim_step=1
random_seed=25
folder_res=PredictivePerformance

#### Process GAMETES ####
echo "Processing GAMETES"

size_lim_begin=1
size_lim_end=8
size_lim_step=1

targetFold=$targetFold_root/GAMETES

# iterate folders in the target folder
for folder in $targetFold/*
do
    echo $folder
    cd $folder
    # create folder for results
    rm -rf $folder_res
    mkdir $folder_res
    # process results of LR fitness
    # step 1: merge resutls
    filter=LR
    model=lr
    header=res_simpleGAplus${filter}_sizelim_
    filter_dir=merged_${filter}
    rm -rf $filter_dir
    mkdir $filter_dir
    # loop through all size limits
    for ((size_lim=$size_lim_begin; size_lim<=$size_lim_end; size_lim+=$size_lim_step))
    do
        cat $header$size_lim\_*.txt > $header$size_lim.txt # merge results
        # summarize results
        python $home/$scr/AnalysisGeneticAlgorithmResult/summrize.py $header$size_lim.txt $header$size_lim\_summary.csv
        mv $header$size_lim.txt $filter_dir # move merged results to the merged folder
        mv $header$size_lim\_summary.csv $filter_dir # move merged results to the merged folder
    done
    cd $filter_dir
    # merge summary files
    echo "size_lim,fitness,featureSel" > res_simpleGAplus${filter}_summary.csv
    cat ${header}*\_summary.csv >> res_simpleGAplus${filter}_summary.csv

    # step 2: compute training testing validation auc-rocs
    cd ..
    python $home/$scr/AnalysisGeneticAlgorithmResult/plot_auc_roc_train_test_val.py -t train.tsv -v validation.tsv -r $random_seed -f $filter_dir/res_simpleGAplus${filter}_summary.csv -o $folder_res/res_simpleGAplus${filter}_summary_auc.csv -m $model
    

    # process results of DT fitness
    # step 1: merge resutls
    filter=DT
    model=dt
    header=res_simpleGAplus${filter}_sizelim_
    filter_dir=merged_${filter}
    rm -rf $filter_dir
    mkdir $filter_dir
    # loop through all size limits
    for ((size_lim=$size_lim_begin; size_lim<=$size_lim_end; size_lim+=$size_lim_step))
    do
        cat $header$size_lim\_*.txt > $header$size_lim.txt # merge results
        # summarize results
        python $home/$scr/AnalysisGeneticAlgorithmResult/summrize.py $header$size_lim.txt $header$size_lim\_summary.csv
        mv $header$size_lim.txt $filter_dir # move merged results to the merged folder
        mv $header$size_lim\_summary.csv $filter_dir # move merged results to the merged folder
    done
    cd $filter_dir
    # merge summary files
    echo "size_lim,fitness,featureSel" > res_simpleGAplus${filter}_summary.csv
    cat ${header}*\_summary.csv >> res_simpleGAplus${filter}_summary.csv
    
    # step 2: compute training testing validation auc-rocs
    cd ..
    python $home/$scr/AnalysisGeneticAlgorithmResult/plot_auc_roc_train_test_val.py -t train.tsv -v validation.tsv -r $random_seed -f $filter_dir/res_simpleGAplus${filter}_summary.csv -o $folder_res/res_simpleGAplus${filter}_summary_auc.csv -m $model

    cd $home
    # enter to contiue

done