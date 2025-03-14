#!/bin/bash
#PBS -l walltime=00:45:00
#PBS -l select=1:ncpus=1:mem=1gb 

#sftp kl2621@login.hpc.imperial.ac.uk


module load anaconda3/personal

echo "R is about to run"

cp $HOME/Demographic.R $TMPDIR
cp $HOME/kl2621_HPC_2024_demographic_cluster.R $TMPDIR
cp $HOME/kl2621_HPC_2024_main.R $TMPDIR

R --vanilla < kl2621_HPC_2024_demographic_cluster.R

mv output* $HOME/output_files/

echo "R has finished running"
