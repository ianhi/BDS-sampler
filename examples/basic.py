from bds_sampler import sample, make_degree_sequence
import numpy as np

seq = np.array(
    [
        [1, 2],
        [3, 2],
        [4, 6],
        [3, 3],
        [5, 3],
        [4, 4],
    ]
)

print(sample(in_seq=seq[:, 0], out_seq=seq[:, 1], N_samples=1))

# or generate a random degree sequence with pareto distributed in and out degrees

seq = make_degree_sequence(N_nodes=15)
print(sample(in_seq=seq[:, 0], out_seq=seq[:, 1], N_samples=1))
