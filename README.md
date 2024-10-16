# MD-workshop
1. Download pdb Structure (PDB ID:3F8F) from RCSB website. https://www.rcsb.org/ 
2. Visualise protein structure using VMD.
```
module load vmd
vglrun vmd 3F8F.pdb
```
2. Open the PDB using a text editor like vi, nano, pluma, etc.
```
pluma 3F8F.pdb
```
4. Delete waters and hetero groups.
```
grep -v HOH 3F8F.pdb > 3F8F_dry.pdb
grep -v HETATM 3F8F_dry.pdb > 3F8F_dry_clean.pdb
```
5. Run tleap to create dry and solvated systems
```
tleap -s -f tleap.in > tleap.out
```
6. Read tleap.out file, and also check if prmtop and inpcrd files are created.
```
pluma tleap.out
```
7. Load VMD module to visualise solvated protein structure
```
vglrun vmd 3F8F_solv.pdb
```
8. Load Python
```
module load anaconda/python-3.6.5/5.2
```
9. Open Python and use parmed to convert prmtop and inpcrd files to gromacs topology and structure files (.gro and .top files)
```
python3
```
```
parm=pmd.load_file('3f8f_solv.prmtop', '3f8f_solv.inpcrd')
parm.save('3F8F_gromacs.top', format='gromacs')
parm.save('3F8F_gromacs.gro')
quit()
```
10. We need position restrain files for equilibration step. First we need to separate two chains into two text files using pluma etc. (chaina.pdb and chainb.pdb). 
11. Load gromacs module and create posre files using gromacs command. Only heavy atoms are restrained during equilibration step. (Select Protein-H)
```
module load gromacs/intel-2022.2/2022.1-single
gmx_mpi genrestr -f chaina.pdb -o posre-a.itp
gmx_mpi genrestr -f chainb.pdb -o posre-b.itp
```
12. Position restrain files are needed to added 3F8F_gromacs.top topology file. There are 2 systems and solvent molecules are defined in topology file. At the end of each of system, starting with [moleculetype], add the below comment.
; Include Position restraint file
#ifdef POSRES
#include "posre-b.itp"
#endif
```
