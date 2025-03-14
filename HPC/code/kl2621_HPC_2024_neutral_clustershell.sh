#!/bin/bash
#PBS -l walltime=12:00:00
#PBS -l select=1:ncpus=1:mem=1gb 

#sftp kl2621@login.hpc.imperial.ac.uk


module load anaconda3/personal

echo "R is about to run"


cp $HOME/Demographic.R $TMPDIR
cp $HOME/kl2621_HPC_2024_neutral_cluster.R $TMPDIR
cp $HOME/kl2621_HPC_2024_main.R $TMPDIR

R --vanilla < $TMPDIR/kl2621_HPC_2024_neutral_cluster.R

mv neutral_output_* $HOME/output_files/

echo "R has finished running"
