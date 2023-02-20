# The pipeline specified in this script is used to prepare files for HPC computation.
# Feature selection files will be moved to each dataset folder. Batch files will be generated for each dataset.
# Author: Zhendong Sha@2023-01-09

#### Parameters ####
dir_proj=/Volumes/WorkingProj/DataComplexityAnalysisUsingGA
# dir_data=$dir_proj/data_epistasis/GAMETES
dir_script=$dir_proj/scr
dir_res=$dir_proj/res_epistasis
folder_name=SimulationStudy

# HPC parameters
para_env='source $HOME/.local/ENV/bin/activate'

para_genNum=30 # number of generations
para_popSize=100 # size of the population
para_mutRate=0.2 # mutation rate
para_crossRate=0.8 # crossover rate
para_tournSize=6 # tournament size
para_sizelimit_begin=1 # begin size limit
para_sizelimit_end=10 # end size limit (inclusive)
para_step=1 # step size

para_arrSize=3 # size of the sbatch array
para_hrs=24 # number of hours for each sbatch job
para_core=1 # number of cores for each sbatch job
para_mem=1028 # memory for each sbatch job (GB)
para_repeatNum=25 # number of repeats of each sbatch job

#### process GAMETES datasets ####

# move GA scr to each dataset folder
for folder in $dir_res/$folder_name/*
do
    cp $dir_script/GeneticAlgorithm/GeneticAlgorithm_eaSimple_LogisticRegression.py $folder
    cp $dir_script/GeneticAlgorithm/GeneticAlgorithm_eaSimple_DecisionTree_withFeatureReduction.py $folder
    cp $dir_script/GeneticAlgorithm/GeneticAlgorithm_eaSimple_DecisionTree_minus_LogisticRegression.py $folder
    cp $dir_script/GeneticAlgorithm/mytoolbox.py $folder
done

# remove the old sbatch files in each dataset folder
for folder in $dir_res/$folder_name/*
do
    rm -r $folder/res_*.sh
done

# iterate through all GEO datasets
for folder in $dir_res/$folder_name/*
do
    name=$(basename $folder) # get the name of the dataset
    echo "Process $name"
    # produce ga runs with LR as the fitness evaluation
    data="GAMETES"
    filter="LR"
    for (( c=$para_sizelimit_begin; c<=$para_sizelimit_end; c=$c+$para_step ))
    do
        echo "#!/bin/sh" > $folder/res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "#SBATCH --array=1-$para_arrSize" >> $folder/res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "#SBATCH --job-name=${data}_${filter}_$c" >> $folder/res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "#SBATCH --time=$para_hrs:00:00" >> $folder/res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "#SBATCH -c $para_core" >> $folder/res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "#SBATCH --mem ${para_mem}M" >> $folder/res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "" >> $folder/res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "$para_env" >> $folder/res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "" >> $folder/res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "python GeneticAlgorithm_eaSimple_LogisticRegression.py -f train.tsv -m $para_mutRate -c $para_crossRate -t $para_tournSize -p $para_popSize -s $c -g $para_genNum -r $para_repeatNum > res_simpleGAplus${filter}_sizelim_${c}_\$SLURM_ARRAY_TASK_ID.txt" >> $folder/res_simpleGAplus"$filter"_sizelim_"$c".sh
    done


    data="GAMETES"
    filter="DT"
    for (( c=$para_sizelimit_begin; c<=$para_sizelimit_end; c=$c+$para_step ))
    do
        echo "#!/bin/sh" > $folder/res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "#SBATCH --array=1-$para_arrSize" >> $folder/res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "#SBATCH --job-name=${data}_${filter}_$c" >> $folder/res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "#SBATCH --time=$para_hrs:00:00" >> $folder/res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "#SBATCH -c $para_core" >> $folder/res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "#SBATCH --mem ${para_mem}M" >> $folder/res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "" >> $folder/res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "$para_env" >> $folder/res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "" >> $folder/res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "python GeneticAlgorithm_eaSimple_DecisionTree_withFeatureReduction.py -f train.tsv -m $para_mutRate -c $para_crossRate -t $para_tournSize -p $para_popSize -s $c -g $para_genNum -r $para_repeatNum > res_simpleGAplus${filter}_sizelim_${c}_\$SLURM_ARRAY_TASK_ID.txt" >> $folder/res_simpleGAplus"$filter"_sizelim_"$c".sh
    done

    data="GAMETES"
    filter="Diff"
    for (( c=$para_sizelimit_begin; c<=$para_sizelimit_end; c=$c+$para_step ))
    do
        echo "#!/bin/sh" > $folder/res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "#SBATCH --array=1-$para_arrSize" >> $folder/res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "#SBATCH --job-name=${data}_${filter}_$c" >> $folder/res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "#SBATCH --time=$para_hrs:00:00" >> $folder/res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "#SBATCH -c $para_core" >> $folder/res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "#SBATCH --mem ${para_mem}M" >> $folder/res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "" >> $folder/res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "$para_env" >> $folder/res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "" >> $folder/res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "python GeneticAlgorithm_eaSimple_DecisionTree_minus_LogisticRegression.py -f train.tsv -m $para_mutRate -c $para_crossRate -t $para_tournSize -p $para_popSize -s $c -g $para_genNum -r $para_repeatNum > res_simpleGAplus${filter}_sizelim_${c}_\$SLURM_ARRAY_TASK_ID.txt" >> $folder/res_simpleGAplus"$filter"_sizelim_"$c".sh
    done

done