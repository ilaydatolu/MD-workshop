#!/bin/bash

#======================================================
#
# Job script for running GROMACS on multiple cores (shared) of wee-archie
#
#======================================================

#======================================================
# Propogate environment variables to the compute node
#SBATCH --export=ALL
#
# Run in the standard partition (queue)
#SBATCH --partition=teaching
#
# Specify project account
#SBATCH --account=teaching
#
# No. of tasks required (max. of 16)
#SBATCH --ntasks=16
#
# Specify (hard) runtime (HH:MM:SS)
#SBATCH --time=03:00:00
#
# Job name
#SBATCH --job-name=md-workshop
#
# Output file
#SBATCH --output=slurm-%j.out
#======================================================

module purge
module load gromacs/intel-2022.2/2022.1-single


#======================================================
# Prologue script to record job details
# Do not change the line below
#======================================================
/opt/software/scripts/job_prologue.sh  
#------------------------------------------------------

export OMP_NUM_THREADS=16

# Energy minimization
gmx grompp -f min.mdp -c 3F8F_gromacs.gro -p 3F8F_gromacs.top -o em.tpr

gmx mdrun -deffnm em

# NVT equilibration
gmx grompp -f nvt.mdp -c em.gro -r em.gro -p 3F8F_gromacs.top -o nvt.tpr

gmx mdrun -deffnm nvt

# NPT equilibration
gmx grompp -f npt.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -p 3F8F_gromacs.top -o npt.tpr

gmx mdrun -deffnm npt

# Molecular dynamics simulation
gmx grompp -f md.mdp -c npt.gro -t npt.cpt -p 3F8F_gromacs.top -o md_1ns.tpr

gmx mdrun -deffnm md_1ns

echo "Simulation is finished!"

#======================================================
# Epilogue script to record job endtime and runtime
# Do not change the line below
#======================================================
/opt/software/scripts/job_epilogue.sh 
#------------------------------------------------------
