echo "Processing GWAS folder"

target_folder="res"

cd ${target_folder}/GWAS
for file in *.sh
do
    echo "Submitting job $file"
    sbatch $file
done
cd ..
cd ..

# iterate over folders under /res folder
for folder in ${target_folder}/GAMETES/*
do
    # iterate over files under each folder
    echo "Processing folder $folder"
    cd $folder 
    # submit jobs
    for file in *.sh
    do
        echo "Submitting job $file"
        sbatch $file
    done
    cd ..
    cd ..
    cd ..
done

for folder in ${target_folder}/GEO_Datasets/*
do
    # iterate over files under each folder
    echo "Processing folder $folder"
    cd $folder 
    # submit jobs
    for file in *.sh
    do
        echo "Submitting job $file"
        sbatch $file
    done
    cd ..
    cd ..
    cd ..
done
