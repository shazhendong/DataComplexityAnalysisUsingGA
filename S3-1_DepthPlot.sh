# The pipeline specified in this script is used to generate the results for generating linear and non-linear depth.

#### Parameters ####
targetFold_root=res_1-20\(1\)
scr=scr
home=$(pwd)
size_lim_begin=1
size_lim_end=20
size_lim_step=1

#### Process GAMETES ####

size_lim_begin=1
size_lim_end=8
size_lim_step=1

targetFold=$targetFold_root/GAMETES
# iterate folders in the target folder
for folder in $targetFold/*
do
    echo $folder
    cd $folder
    # process results of LR fitness
    # step 1: merge resutls
    filter=LR
    header=res_simpleGAplus${filter}_sizelim_
    filter_dir=merged_${filter}
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
    cd ..

    # process results of DT fitness
    # step 1: merge resutls
    filter=DT
    header=res_simpleGAplus${filter}_sizelim_
    filter_dir=merged_${filter}
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
    cd ..

    cd $home
    # enter to contiue

done