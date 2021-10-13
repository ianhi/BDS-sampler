try:
    from ._version import __version__
except ImportError:
    __version__ = "unknown"

__author__ = "Ian Hunt-Isaak"
__email__ = "ianhuntisaak@gmail.com"

from ._sampler import sample
import numpy as np
from scipy.stats import pareto

def make_degree_sequence(a=1.0, gamma=2.4, N_nodes=1000):
    """
    Returns a *graphical* degree sequence in *normal order* (See Kim et al 2012).
    
    Parameters
    ----------
    a : float 
        location parameter for scale free distribution
    gamma : float
        shape parameter for scale free distribution 
    N_nodes : int
        number of nodes to generate
        
    Returns
    -------

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

__all__ = [
    "make_degree_sequence",
    "sample",
]
