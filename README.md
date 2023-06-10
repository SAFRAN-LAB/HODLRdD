# Hierarchically off-diagonal low-rank matrix in $d$ dimensions (HODLR $d$ D), A black-box fast algorithm for particle simulations in $d$ dimensions

## Edit the following hyperparameters based on your kernel and application.    
1) $NDIM$ = The dimension space of the particles.  
1) Nmax = The maximum number of particles at the leaf level (This decides the depth of the hierarchical tree)  
3) eps_ACA = Accuracy in compression by ACA  
4) SYS_SIZE = Above this size the matrix operations are performed in an memory efficient way   
5) INTERACTION_TYPE_ALLOWED = This represents $d'$ (to decide on which weak admissibility criteria)   
      
The following options are allowed in deciding the hierarchical tree and/or the admissibility criteria   
- In Two dimenstions ($2$ D):  
    * $d' = -1$ $\implies$ $\mathcal{H}$-matrix with standard/strong admissibility criteria $\eta = \sqrt{2}$.
    * $d' = 0$ $\implies$ Interaction list includes Vertex sharing neighbours, HODLR2D matrix structure.
    * $d' = 1$ $\implies$ Interaction list includes all non-self clusters. HODLR with quad tree 
- In Three dimensions ($3$ D):
    * $d' = -1$ $\implies$ $\mathcal{H}$-matrix with standard/strong admissibility criteria $\eta = \sqrt{3}$.
    * $d' = 0$ $\implies$ Interaction list includes Vertex sharing neighbours, HODLR3D matrix structure.
    * $d' = 1$ $\implies$ Interaction list includes Vertex sharing and edge sharing neighbours
    * $d' = 2$ $\implies$ Interaction list includes all non-self clusters. HODLR with oct tree    
- In Higher dimensions:    
    * $d' = -1$ $\implies$ $\mathcal{H}$-matrix with standard/strong admissibility criteria $\eta = \sqrt{NDIM}$.
    * $d' = 0$ $\implies$ Interaction list includes Vertex sharing neighbours, HODLR $d$ D matrix structure.
    * $\vdots$
    * $d' = NDIM-1$ $\implies$ Interaction list includes all non-self clusters. HODLR with $2^{NDIM}$ tree.

## Please follow these simple steps to run the code.
Step 1.
```
git clone https://github.com/SAFRAN-LAB/HODLRdD.git
```
Step 2.
```
cd HODLRdD && cd examples
```
Step 3.
Update the `Eigen` path in `Makefile`

Step 4.
Run the `Makefile` to get the executable

Step 5. 
If you want to get the results for HODLR4D matrix set `atoi(argv[2]) = 0`
```
make clean && make  && ./exe 25 0
```

If everything is fine you will get the following output for HODLR4D matrix.
```c++
HMATRIX START
Root Formed
Tree Formed with depth 3
HMATRIX DONE
Matrix operators formed...
The size of K matrix 390625
GMRES took 310.595 with status 4

Apr 11 2023,17:16:28

Memory (in GB) : 191.754
Number of FLOP : 2.39693e+10
Compression Ratio : 0.157085
Maximum rank across the Tree : 200
Time to Initialize (in s) : 1091.91
Matrix-Vector time (in s) : 62.1719
Time to solution   (in s) : 310.595
The direct mat-vec time is (s): 386.084
Relative Error in matvec   ... 6.29254e-07
Relative Error in solution ... 1.17657e-06
```
If you want to get the results for $\mathcal{H}$ matrix with strong admissibility in 4D set `atoi(argv[2]) = -1`
```
make clean && make  && ./exe 25 -1
```
If everything is fine you will get the following output for $\mathcal{H}$ matrix with strong admissibility in 4D.
```
HMATRIX START
Root Formed
Tree Formed with depth 3
HMATRIX DONE
Matrix operators formed...
The size of K matrix 390625
GMRES took 382.493 with status 5

Apr 11 2023,17:16:28

Memory (in GB) : 199.573
Number of FLOP : 2.49466e+10
Compression Ratio : 0.16349
Maximum rank across the Tree : 189
Time to Initialize (in s) : 1112
Matrix-Vector time (in s) : 63.8459
Time to solution   (in s) : 382.493
The direct mat-vec time is (s): 375.311
Relative Error in matvec   ... 2.38367e-07
Relative Error in solution ... 2.38401e-07
```
The default eps_ACA and GMRES tolerance is $10^{-6}$. It can be modified in the `myHeaders.hpp` file.
