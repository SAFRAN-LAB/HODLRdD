# HODLRdD Developer Documentation

## Table of Contents
1. [Project Overview](#project-overview)
2. [Architecture & Design](#architecture--design)
3. [Core Components](#core-components)
4. [Build System](#build-system)
5. [Configuration](#configuration)
6. [API Reference](#api-reference)
7. [Examples](#examples)
8. [Testing & Validation](#testing--validation)
9. [Performance](#performance)
10. [Contributing](#contributing)

## Project Overview

**HODLRdD** (Hierarchically Off-Diagonal Low-Rank in d Dimensions) is a high-performance C++ library implementing black-box fast algorithms for particle simulations in arbitrary dimensions. The library provides efficient matrix compression and solvers for kernel-based linear systems using hierarchical matrix structures.

### Key Features
- **Multi-dimensional Support**: Works in arbitrary dimensions (2D, 3D, 4D+)
- **Hierarchical Matrix Structures**: Supports both H-matrices and HODLR matrices
- **Adaptive Compression**: Uses Adaptive Cross Approximation (ACA) for low-rank compression
- **Fast Solvers**: Integrated GMRES solver with matrix-vector products
- **Template-based Design**: Generic kernel functions support
- **OpenMP Parallelization**: Multi-threaded execution support

### Mathematical Foundation

The library implements hierarchical matrix approximations for kernel matrices of the form:
```
K[i,j] = κ(x_i, x_j)
```

Where `κ` is a user-defined kernel function and `{x_i}` are particle positions in d-dimensional space.

## Architecture & Design

### High-Level Architecture

```
HODLRdD_matrix<Kernel>
├── Tree<Kernel>
│   ├── Node<Kernel> (hierarchical tree structure)
│   └── cluster (spatial clustering)
├── kernel_function<Kernel> (kernel evaluation)
└── iterSolver<Matrix> (GMRES solver)
```

### Design Patterns
- **Template Metaprogramming**: Generic kernel interface
- **Hierarchical Decomposition**: Binary tree structure for spatial subdivision
- **Strategy Pattern**: Different admissibility criteria
- **RAII**: Automatic resource management

## Core Components

### 1. Matrix Interface (`HDD_matrix.hpp`)

**`HODLRdD_matrix<Kernel>`** is the main user-facing class:

```cpp
template <class Kernel>
class HODLRdD_matrix {
    // Constructor
    HODLRdD_matrix(Kernel*& userkernel, 
                   std::vector<ptsnD>*& gPoints, 
                   Eigen::VectorXd x1, Eigen::VectorXd x2);
    
    // Matrix operations
    Vec operator*(Vec x);               // Matrix-vector product
    Vec solve(Vec& b);                  // Linear system solver
    void Assemble_matrix_operators();   // Build matrix operators
};
```

### 2. Tree Structure (`HDD_tree.hpp`)

**`Tree<Kernel>`** manages the hierarchical decomposition:

- **Spatial Subdivision**: Creates 2^d tree structure
- **Admissibility**: Determines interaction types between clusters
- **Matrix Assembly**: Coordinates low-rank approximations

### 3. Node Management (`HDD_node.hpp`)

**`Node<Kernel>`** represents tree nodes:
- **Leaf Nodes**: Direct matrix storage for small clusters
- **Internal Nodes**: Low-rank approximations for admissible pairs
- **Self Interaction**: Dense storage for non-admissible pairs

### 4. Clustering (`HDD_clusters.hpp`)

**`cluster`** handles spatial partitioning:
- **Bounding Box**: Axis-aligned boxes in d-dimensions  
- **Point Assignment**: Maps particles to clusters
- **Hierarchical Division**: Recursive subdivision

### 5. Kernel Interface (`kernel_function.hpp`)

**`kernel_function<Kernel>`** provides:
```cpp
// Matrix access
Vec getRow(int i, std::vector<size_t>& indices);
Vec getCol(int j, std::vector<size_t>& indices);
Mat getMatrix(std::vector<size_t>& row_indices, 
              std::vector<size_t>& col_indices);

// Low-rank approximation
void ACA_FAST(Mat& L, Mat& R, double eps, 
              std::vector<size_t>& row_indices,
              std::vector<size_t>& col_indices);
```

### 6. Low-Rank Approximation (`LowRank_matrix.hpp`)

**`LowRankMat<Kernel>`** implements ACA:
- **Adaptive Cross Approximation**: Iterative low-rank construction
- **Error Control**: User-specified tolerance
- **Memory Efficiency**: Factored form storage (L × R^T)

### 7. Serialization Support (`lib/cereal/`)

The project includes a complete **Cereal** serialization library for data persistence:

#### Core Components:
- **`cereal.hpp`**: Main header providing serialization interface
- **`access.hpp`**: Friendship declarations for private member serialization  
- **`version.hpp`**: Library version information
- **`macros.hpp`**: Utility macros for serialization
- **`specialize.hpp`**: Template specializations

#### Archive Formats (`archives/`):
- **`binary.hpp`**: Binary archive format (compact storage)
- **`portable_binary.hpp`**: Platform-independent binary format
- **`json.hpp`**: JSON archive format (human-readable)
- **`xml.hpp`**: XML archive format (structured, verbose)
- **`adapters.hpp`**: Archive adapter utilities

#### STL Type Support (`types/`):
Complete serialization support for standard library types:
- **Containers**: `vector.hpp`, `array.hpp`, `deque.hpp`, `list.hpp`, `forward_list.hpp`
- **Associative**: `map.hpp`, `set.hpp`, `unordered_map.hpp`, `unordered_set.hpp`
- **Utilities**: `string.hpp`, `tuple.hpp`, `utility.hpp`, `optional.hpp`
- **Smart Pointers**: `memory.hpp` (shared_ptr, unique_ptr support)
- **Others**: `atomic.hpp`, `chrono.hpp`, `complex.hpp`, `bitset.hpp`, `queue.hpp`, `stack.hpp`

#### External Dependencies (`external/`):
- **RapidJSON**: High-performance JSON parser/generator
  - Complete header-only JSON library
  - Error handling, streaming support
  - Schema validation capabilities
- **RapidXML**: Fast XML parser
  - Lightweight, header-only design
  - DOM-style parsing with utilities
- **Base64**: Encoding/decoding utilities

#### Implementation Details (`details/`):
- **`helpers.hpp`**: Template metaprogramming utilities
- **`traits.hpp`**: Type trait definitions for serialization
- **`util.hpp`**: General utilities and helper functions
- **`static_object.hpp`**: Static object management
- **`polymorphic_impl.hpp`**: Polymorphic serialization support

#### Usage in HODLRdD:
```cpp
#ifdef USE_CEREAL
#include <cereal/archives/portable_binary.hpp>
#include <cereal/types/vector.hpp>

// Save/load vectors in binary format
namespace storedata {
    Eigen::VectorXd load_vec(std::string fname);
    void save_vec(std::string fname, Eigen::VectorXd X);
}
#endif
```

## Build System

### Dependencies
- **Eigen3**: Linear algebra library
- **OpenMP**: Parallel computing
- **C++17**: Modern C++ standard
- **Cereal**: Serialization library (bundled in `lib/cereal/`)

### Compilation
```bash
# Basic compilation (without serialization)
g++ -std=c++17 -I/usr/local/include/eigen3 -fopenmp -O3 -DUSE_DOUBLE test.cpp -o test

# With Cereal serialization support (using bundled library)
g++ -std=c++17 -I/usr/local/include/eigen3 -I./lib -fopenmp -O3 -DUSE_DOUBLE -DUSE_CEREAL test.cpp -o test
```

**Note**: The project includes Cereal as a bundled library in `lib/cereal/`, so no external installation is required.

### Makefile Structure
The provided `Makefile` in `examples/` demonstrates basic compilation:
```makefile
all:
	g++-12 -std=c++17 -I/usr/local/include/eigen3 -fopenmp -O4 -DUSE_DOUBLE -Wall test_hodlrdd.cpp -o exe
```

## Configuration

### Key Parameters (`myHeaders.hpp`)

```cpp
// Spatial dimension
const int NDIM = 4;

// Tree parameters
const int Nmax = 100;                    // Max points per leaf
int numPoints = 10;                      // Points per dimension

// Compression parameters
const double eps_ACA = 1e-10;            // ACA tolerance
const int SYS_SIZE = 1000;               // Memory-efficient threshold

// Interaction control
int INTERACTION_TYPE_ALLOWED = 0;        // Admissibility parameter
```

### Admissibility Criteria

The `INTERACTION_TYPE_ALLOWED` parameter controls the interaction list:

#### 2D Case:
- `d' = -1`: H-matrix with strong admissibility (η = √2)
- `d' = 0`: HODLR2D (vertex-sharing neighbors)
- `d' = 1`: Full HODLR with quadtree

#### 3D Case:
- `d' = -1`: H-matrix with strong admissibility (η = √3)
- `d' = 0`: HODLR3D (vertex-sharing neighbors)
- `d' = 1`: Edge-sharing neighbors
- `d' = 2`: Full HODLR with octree

#### Higher Dimensions:
- `d' = -1`: H-matrix with strong admissibility (η = √NDIM)
- `d' = 0`: Vertex-sharing neighbors
- `d' = NDIM-1`: Full HODLR with 2^NDIM tree

## API Reference

### User Kernel Interface

To use HODLRdD, implement a kernel class:

```cpp
class MyKernel {
public:
    // Constructor - initialize particle positions
    MyKernel() { /* setup gridPoints */ }
    
    // Kernel evaluation
    dtype_base getMatrixEntry(int i, int j) {
        // Return κ(x_i, x_j)
    }
    
    // Provide access to particle positions
    void get_points(std::vector<ptsnD>*& points) {
        points = gridPoints;
    }
    
private:
    std::vector<ptsnD>* gridPoints;
};
```

### Basic Usage Pattern

```cpp
// 1. Create kernel instance
MyKernel* kernel = new MyKernel();

// 2. Get particle positions  
std::vector<ptsnD>* gridPoints;
kernel->get_points(gridPoints);

// 3. Define bounding box
Eigen::VectorXd x_min(NDIM), x_max(NDIM);
// ... set bounds ...

// 4. Create matrix
HODLRdD_matrix<MyKernel> matrix(kernel, gridPoints, x_min, x_max);

// 5. Assemble operators
matrix.Assemble_matrix_operators();

// 6. Solve system
Vec solution = matrix.solve(rhs);
```

### Point Data Structure

```cpp
struct ptsnD {
    double x[NDIM];  // Coordinates
    int id;          // Point identifier
};
```

## Examples

### 1. 4D Kernel Test (`examples/test_hodlrdd.cpp`)

Demonstrates usage with a 4D kernel:
```cpp
// Kernel: 1/r in 4D
class kernel_4d_test {
    dtype_base getMatrixEntry(int i, int j) {
        if (i == j) return 500.0;  // Diagonal regularization
        
        ptsnD a = gridPoints->at(i);
        ptsnD b = gridPoints->at(j);
        double r = euclidean_distance(a, b);
        return -1.0/(4*PI*PI*r);   // Green's function
    }
};
```

### 2. Running Examples

```bash
cd examples
make clean && make

# HODLR4D matrix (d' = 0)
./exe 25 0

# H-matrix with strong admissibility (d' = -1)  
./exe 25 -1
```

### 3. Expected Output
```
HMATRIX START
Root Formed
Tree Formed with depth 3
HMATRIX DONE
Matrix operators formed...
The size of K matrix 390625
GMRES took 310.595 with status 4

Memory (in GB) : 191.754
Number of FLOP : 2.39693e+10
Compression Ratio : 0.157085
Maximum rank across the Tree : 200
Time to Initialize (in s) : 1091.91
Matrix-Vector time (in s) : 62.1719
Time to solution   (in s) : 310.595
Relative Error in matvec   ... 6.29254e-07
Relative Error in solution ... 1.17657e-06
```

## Testing & Validation

### MATLAB Validation Scripts

The `MATLAB_files/` directory contains validation scripts:

#### Bernstein Ellipse Analysis (`Bern_ellipse/`)
- **`main.m`**: Analyzes kernel behavior using Bernstein ellipses
- **`bern_fun.m`**: Computes approximation bounds

#### Rank Analysis (`Rank_plots/`)
- **`test_4d_*.m`**: Numerical rank tests for different cluster configurations
- **`compute_norm.m`**: Computes approximation errors
- **`numerical_rank.m`**: Determines effective rank

### Error Metrics

The library provides several error measures:
- **Matrix-Vector Error**: `|H*x - K*x|/|K*x|`
- **Solution Error**: `|x_computed - x_exact|/|x_exact|`
- **ACA Error**: Controlled by `eps_ACA` parameter

## Performance

### Scalability
- **Memory**: O(N log N) vs O(N²) for dense matrices
- **Matrix-Vector**: O(N log N) complexity
- **Assembly**: Problem-dependent, typically O(N log² N)

### Optimization Tips

1. **Leaf Size**: Adjust `Nmax` based on problem characteristics
2. **ACA Tolerance**: Balance accuracy vs compression with `eps_ACA`
3. **Thread Count**: Set `nThreads` based on available cores
4. **Memory Threshold**: Tune `SYS_SIZE` for memory-constrained systems

### Parallel Performance
- OpenMP parallelization in matrix assembly
- Thread-safe kernel evaluations required
- Memory-bound performance for large systems

## Contributing

### Code Style
- Follow existing naming conventions
- Use template-based design for extensibility
- Include comprehensive error checking
- Document public interfaces

### Adding New Kernels
1. Implement kernel interface
2. Provide particle generation
3. Add validation tests
4. Update documentation

### Directory Structure
```
include/           # Header files
├── myHeaders.hpp  # Global configuration
├── HDD_matrix.hpp # Main matrix class
├── HDD_tree.hpp   # Tree structure
├── HDD_node.hpp   # Node management
├── kernel_function.hpp # Kernel interface
└── ...

examples/          # Example programs
├── test_hodlrdd.cpp # Main test
└── Makefile      # Build script

MATLAB_files/     # Validation scripts
├── Bern_ellipse/ # Theoretical analysis
└── Rank_plots/   # Numerical tests

lib/cereal/       # Bundled Cereal serialization library
├── archives/     # Archive formats (binary, JSON, XML)
├── types/        # Serialization support for STL types
├── details/      # Implementation details
└── external/     # Third-party components (RapidJSON, RapidXML)
docs/            # Auto-generated documentation
```

### Testing Protocol
1. Verify compilation with different compilers
2. Run dimensional scaling tests
3. Check memory usage patterns  
4. Validate against direct methods
5. Benchmark performance improvements

For more details, refer to the [research paper](https://arxiv.org/pdf/2209.05819) and examine the provided examples.