#!/bin/bash
#======================================================
#
# Job script for running GROMACS on multiple cores on a single node
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
#SBATCH --account=tuttle-rmss
#
# No. of tasks required (max of 40), all cores on the same node
#SBATCH --ntasks=1 --nodes=1
#
# Specify (hard) runtime (HH:MM:SS)
#SBATCH --time=06:00:00
#
# Job name
#SBATCH --job-name=md-workshop
#
# Output file
#SBATCH --output=slurm-%j.out
# 
#======================================================

module purge

export OMP_NUM_THREADS=1

module load gromacs/intel-2022.2/2022.1-single

#======================================================
# Prologue script to record job details
# Do not change the line below
#======================================================
/opt/software/scripts/job_prologue.sh
#------------------------------------------------------

# Energy minimization
gmx_mpi grompp -f min.mdp -c 3F8F_gromacs.gro -p 3F8F_gromacs.top -o em.tpr

gmx_mpi mdrun -ntmpi 10 -deffnm em

# NVT equilibration
mpirun -np $SLURM_NTASKS gmx_mpi grompp -f nvt.mdp -c em.gro -r em.gro -p 3F8F_gromacs.top -o nvt.tpr

mpirun -np $SLURM_NTASKS gmx_mpi mdrun -deffnm nvt

# NPT equilibration
mpirun -np $SLURM_NTASKS gmx_mpi grompp -f npt.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -p 3F8F_gromacs.top -o npt.tpr

mpirun -np $SLURM_NTASKS gmx_mpi mdrun -deffnm npt

# Molecular dynamics simulation
mpirun -np $SLURM_NTASKS gmx_mpi grompp -f md.mdp -c npt.gro -t npt.cpt -p 3F8F_gromacs.top -o md_1ns.tpr

mpirun -np $SLURM_NTASKS gmx_mpi mdrun -deffnm md_1ns

echo "Simulation is finished!"

#======================================================
# Epilogue script to record job endtime and runtime
# Do not change the line below
#======================================================
/opt/software/scripts/job_epilogue.sh
#------------------------------------------------------
~
