echo "Processing GWAS folder"

cd res/GWAS
for file in *.sh
do
    echo "Submitting job $file"
    sbatch $file
done
cd ..
cd ..

# iterate over folders under /res folder
for folder in res/GAMETES/*
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

for folder in res/GEO_Datasets/*
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
