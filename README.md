# Hierarchically off-diagonal low-rank matrix in $d$ dimensions (HODLR $d$ D), A black-box fast algorithm for particle simulations in $d$ dimensions

## Edit the following hyperparameters based on your kernel and application.    
1) $NDIM$ = The dimension space of the particles.  
1) Nmax = The maximum number of particles at the leaf level (This decides the depth of the hierarchical tree)  
3) eps_ACA = Accuracy in compression by ACA  
4) SYS_SIZE = Above this size the matrix operations are performed in an memory efficient way   
5) INTERACTION_TYPE_ALLOWED = This represents $d'$ (to decide on which weak admissibility criteria)   
      
The following options are allowed in deciding the hierarchical tree and/or the admissibility criteria   
- In Two dimenstions ($2$ D):  
    * $d' = -1$ $\implies$ $\mathcal{H}$-matrix with standard admissibility criteria $\eta = \sqrt{2}$.
    * $d' = 0$ $\implies$ Interaction list includes Vertex sharing neighbours, HODLR2D matrix structure.
    * $d' = 1$ $\implies$ Interaction list includes all clusters that are not self. HODLR with quad tree 
- In Three dimensions ($3$ D):
    * $d' = -1$ $\implies$ $\mathcal{H}$-matrix with standard/strong admissibility criteria $\eta = \sqrt{3}$.
    * $d' = 0$ $\implies$ Interaction list includes Vertex sharing neighbours, HODLR3D matrix structure.
    * $d' = 1$ $\implies$ Interaction list includes Vertex sharing and edge sharing neighbours
    * $d' = 2$ $\implies$ Interaction list includes all clusters that are not self. HODLR with oct tree    
- In Higher dimensions:    
    * $d' = -1$ $\implies$ $\mathcal{H}$-matrix with standard/strong admissibility criteria $\eta = \sqrt{NDIM}$.
    * $d' = 0$ $\implies$ Interaction list includes Vertex sharing neighbours, HODLR $d$ D matrix structure.
    * $\vdots$
    * $d' = NDIM-1$ $\implies$ Interaction list includes all non-self clusters. HODLR with $2^{NDIM}$ tree.

## Please follow these simple steps to run the code.
Step 1.
```
git clone https://github.com/SAFRAN-LAB/HODLRdD
```
Step 2.
```
cd HODLRdD
```
Step 3.
Update the `Eigen` path in `Makefile`
Step 4.
Run the `Makefile` to get the executable

```
HMATRIX START
Root Formed
Tree Formed with depth 2
HMATRIX DONE
Matrix operators formed...
The size of K matrix 10000
GMRES took 32.8972 with status 4

May 18 2023,10:03:05

Memory (in GB) : 4.57428
Number of FLOP : 5.71785e+08
Compression Ratio : 5.71785
Maximum rank across the Tree : 92
Time to Initialize (in s) : 6.31187
Matrix-Vector time (in s) : 0.188097
Time to solution   (in s) : 32.8972
Relative Error in matvec   ... 1.13781e-09
Relative Error in solution ... 1.1206e-05
```
