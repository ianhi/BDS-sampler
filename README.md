# BDS-sampler

[![License](https://img.shields.io/pypi/l/BDS-sampler.svg?color=green)](https://github.com/ianhi/BDS-sampler/raw/main/LICENSE)
[![PyPI](https://img.shields.io/pypi/v/BDS-sampler.svg?color=green)](https://pypi.org/project/BDS-sampler)
[![Python Version](https://img.shields.io/pypi/pyversions/BDS-sampler.svg?color=green)](https://python.org)

cython bindings for Charo Del Genio's bi-degree sequence generator (https://charodelgenio.weebly.com/directed-graph-sampling.html)

which are an implementation of the paper Constructing and sampling directed graphs with given degree sequences https://doi.org/10.1088/1367-2630/14/2/023012

## Install

```bash
pip install bds-sampler
```

# Usage

```python
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

print(sample(in_seq=seq[:, 0], out_seq=seq[:, 1], N_samples=10))

# or generate a random degree sequence with pareto distributed in and out degrees

seq = make_degree_sequence(N_nodes=15)
print(sample(in_seq=seq[:, 0], out_seq=seq[:, 1], N_samples=1))
```
