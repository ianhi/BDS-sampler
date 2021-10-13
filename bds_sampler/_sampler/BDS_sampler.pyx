cimport mt
cimport graphs
import numpy as np
cimport numpy as np
from libc.stdlib cimport calloc, malloc, free


def init_state(unsigned long s):
    mt.init_genrand(s)


def initialize_cython(in_seq, out_seq):#int in_seq, int out_seq, int N):
    """
    build a pointer to the data and pass it to the digsaminit function.
    based on: https://stackoverflow.com/a/42000268/835607

    Parameters
    ----------
    in_seq : 1D np.array of type np.int32
    out_seq : 1D np.array of type np.int32
    N : number of nodes

    Returns
    -------
    None
    """
    cdef int N = in_seq.shape[0]
    arr = np.hstack([in_seq[:,None],out_seq[:,None]])

    cdef np.ndarray[int,ndim=2,mode="c"] seq = np.asarray(arr,dtype=np.int32,order="C")
    cdef int** point_to_seq = <int **>malloc(N*sizeof(int*))
    cdef int k
    if not point_to_seq: raise MemoryError
    try:
        for i in range(N):
            point_to_seq[i] = &seq[i, 0]
        # Call the C function that expects a double**
        graphs.digsaminit(&point_to_seq[0],N)
    finally:
        free(point_to_seq)


cdef _sample(int N,out_seq):
    """
    return a single sample graph from the current sequence """
    g = graphs.digsam(mt.genrand_real1,0)
    adj = np.zeros((N,N))
    cdef int i,j
    for i in range(N):
        for j in range(out_seq[i]):
            adj[i][g.list[i][j]]=1
    return adj

def clean():
    graphs.digsamclean()

def sample(in_seq, out_seq, N_samples=1):
    """
    Parameters
    -----------
    in_seq : 1D np.array castable to np.int32
        the list of in degrees for the nodes
    out_seq : 1D np.array castable to np.int32
        the list of out degrees for the nodes. Must be same shape as in_seq
    N_samples : integer
        number of graph topologies to generate based on the 
        given degree sequences

    Returns
    -------
    adj : np.array
        Arr with shape (N_samples, N, N) where N = in_seq.shape[0]
    """
    N = in_seq.shape[0]
    init_state(np.random.randint(1000000, dtype=np.uint64))

    initialize_cython(in_seq.astype(np.int32), out_seq.astype(np.int32))
    try:
        adj = np.zeros([N_samples, N, N])
        for i in range(N_samples):
            adj[i] = _sample(N, out_seq)
    finally:
        clean()
    return adj
