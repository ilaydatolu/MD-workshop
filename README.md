# MD-workshop
1. Download pdb Structure (PDB ID:3F8F) from RCSB website. https://www.rcsb.org/ 
2. Visualise protein structure using VMD.
```
module load vmd
vmd 3F8F.pdb
```
2. Open the PDB using a text editor like vi, nano, pluma, etc.
3. Delete waters and hetero groups.
grep -v HOH 3F8F.pdb > 3F8F_dry.pdb
grep -v HETATM 3F8F_dry.pdb > 3F8F_dry_clean.pdb
4. Run tleap to create dry and solvated systems
tleap -s -f tleap.in > tleap.out
Read tleap.out file, and check if prmtop and inpcrd files are created.
5. Load VMD module to visualise solvated protein structure
