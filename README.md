
# Data Complexity Analysis Using Genetic Algorithms

This repository contains all the necessary scripts and data files for conducting an in-depth analysis of data complexity using genetic algorithms.

## Getting Started

Before you can run the experiments, you need to set up the project. Follow the steps below to get started:

1. Navigate to the `data/GEO\ datasets` directory.
2. Run the `unzip_csv.sh` script to unzip the GEO datasets. This will extract all the necessary data files required for the experiments.

## Running the Experiments

All experiments in this study can be replicated using the shell files listed in the home directory. Here is a brief overview of what each shell file does:

1. `S1_DataSetPreparetion.sh`: # The pipeline specified in this script is used to prepare the data for the analysis.
2. `S2_PrepareHPC.sh`: # The pipeline specified in this script is used to prepare for HPC computation. After running this script, you will need to upload the enrire repo to your HPC cluster.
3. `S2-1_SubmitJobs.sh`: Job submission to HPC cluster.
4. `S3-1_DepthPlot.sh`: # The pipeline specified in this script is used to generate the results for generating linear and non-linear depth plot.
5. `S3-2_DrawDepthPlot.sh`: # This sh file generates a depth plot for each dataset based on the result from S3-1_DepthPlot.sh. The result is saved in the folder "PredictivePerformance"
6. `S4_DatasetComplexityAnalysis.sh`: # This sh file determines the depth for each dataset based on the result of S3-1_DepthPlot.sh. The result is saved in the folder "PredictivePerformance"
7. `S5_problexityAnalysis.sh`: # This pipeline perform complexity analysis for all dataset using the existing metrics.

Enjoy exploring the complexity of data with genetic algorithms!
