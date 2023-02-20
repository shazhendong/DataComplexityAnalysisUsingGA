cd ..
cd ..

target_folder=res_epistasis

cd ${target_folder}

# iterate over folders under /res folder
for folder in SimulationStudy/*
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
done