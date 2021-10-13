#cdef extern from "DiGSampler.h":
#    ctypedef struct digraph{
#        int **list;
#        double weight;
#    }
#    int**  digsam (double (*rng)(void), const int stfl);
#    void digsamclean(void);
#    void digsaminit (int **seq, const int n)
cdef extern from "mt19937ar.h":
    void init_genrand(unsigned long s)
    double genrand_real1()
