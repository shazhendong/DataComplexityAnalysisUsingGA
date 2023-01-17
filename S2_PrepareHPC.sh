# The pipeline specified in this script is used to prepare for HPC computation.
# Author: Zhendong Sha@2023-01-09

#### Parameters ####
dir_scr=scr
dir_res=res

para_env='source $HOME/.local/ENV/bin/activate'

#### Prepare genetic algrithms scr ####
echo "Prepare genetic algrithms scr"

# copy GA to GWAS folder
cp -r $dir_scr/GeneticAlgorithm/*.py $dir_res/GWAS

# copy GA to GAMETES folder
for folder in $dir_res/GAMETES/*
do
    cp -r $dir_scr/GeneticAlgorithm/*.py $folder
done

# copy GA to GEO folder
for folder in $dir_res/GEO_Datasets/*
do
    cp -r $dir_scr/GeneticAlgorithm/*.py $folder
done

#### Prepare HPC scr ####
echo "#### Prepare HPC scr ####"
rm -r $dir_res/GWAS/res_*.sh
# process GWAS runs

echo "Process GWAS runs"

para_genNum=50 # number of generations
para_popSize=1000 # size of the population
para_mutRate=0.2 # mutation rate
para_crossRate=0.8 # crossover rate
para_tournSize=6 # tournament size
para_sizelimit_begin=1 # begin size limit
para_sizelimit_end=20 # end size limit (inclusive)
para_step=1 # step size

para_arrSize=15 # size of the sbatch array
para_hrs=100 # number of hours for each sbatch job
para_core=1 # number of cores for each sbatch job
para_mem=4 # memory for each sbatch job (GB)
para_repeatNum=5 # number of repeats of each sbatch job

# produce ga runs with LR as the fitness evaluation
data="CRC"
filter="LR"
for (( c=$para_sizelimit_begin; c<=$para_sizelimit_end; c=$c+$para_step ))
do
	echo "#!/bin/sh" > res_simpleGAplus"$filter"_sizelim_"$c".sh
    echo "#SBATCH --array=1-$para_arrSize" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
    echo "#SBATCH --job-name=${data}_${filter}_$c" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
    echo "#SBATCH --time=$para_hrs:00:00" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
    echo "#SBATCH -c $para_core" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
    echo "#SBATCH --mem ${para_mem}g" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
    echo "" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
    echo "$para_env" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
    echo "" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
    echo "python GeneticAlgorithm_eaSimple_LogisticRegression.py -b train -m $para_mutRate -c $para_crossRate -t $para_tournSize -p $para_popSize -s $c -g $para_genNum -r $para_repeatNum > res_simpleGAplus${filter}_sizelim_${c}_\$SLURM_ARRAY_TASK_ID.txt" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
done

data="CRC"
filter="DT"
for (( c=$para_sizelimit_begin; c<=$para_sizelimit_end; c=$c+$para_step ))
do
	echo "#!/bin/sh" > res_simpleGAplus"$filter"_sizelim_"$c".sh
    echo "#SBATCH --array=1-$para_arrSize" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
    echo "#SBATCH --job-name=${data}_${filter}_$c" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
    echo "#SBATCH --time=$para_hrs:00:00" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
    echo "#SBATCH -c $para_core" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
    echo "#SBATCH --mem ${para_mem}g" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
    echo "" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
    echo "$para_env" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
    echo "" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
    echo "python GeneticAlgorithm_eaSimple_DecisionTree_withFeatureReduction.py -b train -m $para_mutRate -c $para_crossRate -t $para_tournSize -p $para_popSize -s $c -g $para_genNum -r $para_repeatNum > res_simpleGAplus${filter}_sizelim_${c}_\$SLURM_ARRAY_TASK_ID.txt" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
done

mv res_simpleGAplus* $dir_res/GWAS

# process GEO_Datasets runs

echo "Process GEO_Datasets runs"

# remove old sbatch files
for folder in $dir_res/GEO_Datasets/*
do
    rm -r $folder/res_*.sh
done

para_genNum=50 # number of generations
para_popSize=1000 # size of the population
para_mutRate=0.2 # mutation rate
para_crossRate=0.8 # crossover rate
para_tournSize=6 # tournament size
para_sizelimit_begin=1 # begin size limit
para_sizelimit_end=20 # end size limit (inclusive)
para_step=1 # step size

para_arrSize=15 # size of the sbatch array
para_hrs=100 # number of hours for each sbatch job
para_core=1 # number of cores for each sbatch job
para_mem=4 # memory for each sbatch job (GB)
para_repeatNum=5 # number of repeats of each sbatch job

# iterate through all GEO datasets
for folder in $dir_res/GEO_Datasets/*
do
    name=$(basename $folder) # get the name of the dataset
    echo "Process $name"
    # produce ga runs with LR as the fitness evaluation
    data=${name:0:4}
    filter="LR"
    for (( c=$para_sizelimit_begin; c<=$para_sizelimit_end; c=$c+$para_step ))
    do
        echo "#!/bin/sh" > res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "#SBATCH --array=1-$para_arrSize" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "#SBATCH --job-name=${data}_${filter}_$c" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "#SBATCH --time=$para_hrs:00:00" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "#SBATCH -c $para_core" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "#SBATCH --mem ${para_mem}g" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "$para_env" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "python GeneticAlgorithm_eaSimple_LogisticRegression.py -f train.tsv -m $para_mutRate -c $para_crossRate -t $para_tournSize -p $para_popSize -s $c -g $para_genNum -r $para_repeatNum > res_simpleGAplus${filter}_sizelim_${c}_\$SLURM_ARRAY_TASK_ID.txt" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
    done

    data=${name:0:4}
    filter="DT"
    for (( c=$para_sizelimit_begin; c<=$para_sizelimit_end; c=$c+$para_step ))
    do
        echo "#!/bin/sh" > res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "#SBATCH --array=1-$para_arrSize" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "#SBATCH --job-name=${data}_${filter}_$c" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "#SBATCH --time=$para_hrs:00:00" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "#SBATCH -c $para_core" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "#SBATCH --mem ${para_mem}g" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "$para_env" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "python GeneticAlgorithm_eaSimple_DecisionTree_withFeatureReduction.py -f train.tsv -m $para_mutRate -c $para_crossRate -t $para_tournSize -p $para_popSize -s $c -g $para_genNum -r $para_repeatNum > res_simpleGAplus${filter}_sizelim_${c}_\$SLURM_ARRAY_TASK_ID.txt" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
    done

    mv res_simpleGAplus* $folder
done

# process GAMETES runs

echo "Process GAMETES runs"

# remove old sbatch files
for folder in $dir_res/GAMETES/*
do
    rm -r $folder/res_*.sh
done

para_genNum=50 # number of generations
para_popSize=100 # size of the population
para_mutRate=0.2 # mutation rate
para_crossRate=0.8 # crossover rate
para_tournSize=6 # tournament size
para_sizelimit_begin=1 # begin size limit
para_sizelimit_end=8 # end size limit (inclusive)
para_step=1 # step size

para_arrSize=15 # size of the sbatch array
para_hrs=100 # number of hours for each sbatch job
para_core=1 # number of cores for each sbatch job
para_mem=2 # memory for each sbatch job (GB)
para_repeatNum=5 # number of repeats of each sbatch job

# iterate through all GEO datasets
for folder in $dir_res/GAMETES/*
do
    name=$(basename $folder) # get the name of the dataset
    echo "Process $name"
    # produce ga runs with LR as the fitness evaluation
    data="GAMETES"
    filter="LR"
    for (( c=$para_sizelimit_begin; c<=$para_sizelimit_end; c=$c+$para_step ))
    do
        echo "#!/bin/sh" > res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "#SBATCH --array=1-$para_arrSize" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "#SBATCH --job-name=${data}_${filter}_$c" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "#SBATCH --time=$para_hrs:00:00" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "#SBATCH -c $para_core" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "#SBATCH --mem ${para_mem}g" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "$para_env" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "python GeneticAlgorithm_eaSimple_LogisticRegression.py -f train.tsv -m $para_mutRate -c $para_crossRate -t $para_tournSize -p $para_popSize -s $c -g $para_genNum -r $para_repeatNum > res_simpleGAplus${filter}_sizelim_${c}_\$SLURM_ARRAY_TASK_ID.txt" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
    done


    data="GAMETES"
    filter="DT"
    for (( c=$para_sizelimit_begin; c<=$para_sizelimit_end; c=$c+$para_step ))
    do
        echo "#!/bin/sh" > res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "#SBATCH --array=1-$para_arrSize" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "#SBATCH --job-name=${data}_${filter}_$c" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "#SBATCH --time=$para_hrs:00:00" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "#SBATCH -c $para_core" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "#SBATCH --mem ${para_mem}g" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "$para_env" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
        echo "python GeneticAlgorithm_eaSimple_DecisionTree_withFeatureReduction.py -f train.tsv -m $para_mutRate -c $para_crossRate -t $para_tournSize -p $para_popSize -s $c -g $para_genNum -r $para_repeatNum > res_simpleGAplus${filter}_sizelim_${c}_\$SLURM_ARRAY_TASK_ID.txt" >> res_simpleGAplus"$filter"_sizelim_"$c".sh
    done

    mv res_simpleGAplus* $folder
done