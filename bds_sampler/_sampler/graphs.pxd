cdef extern from "DiGSampler.h":
    ctypedef struct digraph:
        int **list;
        double weight;
    digraph  digsam (double (*rng)(), const int stfl);
    void digsamclean()
    void digsaminit (int **seq, const int n)

