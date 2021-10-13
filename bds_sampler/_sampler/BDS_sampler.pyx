


cimport mt
cimport graphs
import numpy as np
cimport numpy as np
from scipy.stats import pareto
from libc.stdlib cimport calloc, malloc, free


def init_state(unsigned long s):
    mt.init_genrand(s)
def rand():
    return mt.genrand_real1()



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
    graphs.digsamclean();

import cython
@cython.binding(True)
def sample(in_seq,out_seq,N_samples=1):
    """
    input
    -----
    in_seq : 1D np.array castable to np.int32
        the list of in degrees for the nodes
    out_seq : 1D np.array castable to np.int32
        the list of out degrees for the nodes. Must be same shape as in_seq
    N_samples : integer
        number of graph topolgies to generate based on the 
        given degree sequences
    returns
    -------
    adj : np.array
        Arr with shape (N_samples, N,N) where N = in_seq.shape[0]
    """
    N = in_seq.shape[0]
    init_state(np.random.randint(1000000,dtype=np.uint64))

    initialize_cython(in_seq.astype(np.int32),out_seq.astype(np.int32))
    adj = np.zeros([N_samples,N,N])
    for i in range(N_samples):
        adj[i] = _sample(N,out_seq)
    clean()
    return adj

def make_degree_sequence(a=1.0, gamma=2.4, N_nodes=1000):
    """
    Returns a *graphical* degree sequence in *normal order* (See Kim et al 2012).
    
    
    input
    _____
    
    a: float 
        location parameter for scale free distribution
    gamma: float
        shape parameter for scale free distribution 
        
        
    returns
    _______
    bds : np.array
        arr with shape (N_nodes, 2) that contains a graphical BDS. bds[:,0]
	contains the number of ingoing edges for each node and bds[:,1] contains
	the outgoing edges. 
    """
    #convert parameters from Schrier et al. form to that used by scipy.stats.pareto
    b = gamma-1
    p = pareto(b, loc=a)
    
    #Graphical property 1
    D = (p.rvs(size=(N_nodes,2))).astype(np.int)
    while np.any(D>(N_nodes-1)):
        resample = D>(N_nodes-1)
        D[resample] = (p.rvs(size=resample.sum())).astype(np.int)

    #Graphical property 2
    N_in, N_out = D.sum(axis=0)
    if N_in!=N_out:
        diff = np.abs(N_in-N_out)
        sign = ((N_in-N_out)>0).astype(np.int)
        change = np.random.choice(np.arange(N_nodes), size=diff)
        bins, _ = np.histogram(change, bins=N_nodes, range=(0,N_nodes))
        D[:,sign] += bins


    # Normal ordering
    idx = np.lexsort((D[:,1],D[:,0]))
    return np.flip(D[idx],axis=0)

def test_gp3(bds):
    N_nodes = bds.shape[0]
    D_ordered = bds[np.flip(np.argsort(bds[:,0]))]
    lhs = D_ordered[:-1,0].cumsum()
    rhs1 = np.zeros(N_nodes-1)
    rhs2 = np.zeros(N_nodes-1)
    for k in range(1,N_nodes):
        stack1 = np.stack(((k-1)*np.ones(k), D_ordered[:k,1]))
        stack2 = np.stack((k*np.ones(N_nodes-k),D_ordered[k:,1]))
        rhs1[k-1] = np.sum(stack1.min(axis=0))
        rhs2[k-1] = np.sum(stack2.min(axis=0))
    return np.all(lhs<=rhs1+rhs2)
