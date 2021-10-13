# BDS-sampler

[![License](https://img.shields.io/pypi/l/BDS-sampler.svg?color=green)](https://github.com/ianhi/BDS-sampler/raw/main/LICENSE)
[![PyPI](https://img.shields.io/pypi/v/BDS-sampler.svg?color=green)](https://pypi.org/project/BDS-sampler)
[![Python Version](https://img.shields.io/pypi/pyversions/BDS-sampler.svg?color=green)](https://python.org)
[![CI](https://github.com/ianhi/BDS-sampler/workflows/ci/badge.svg)](https://github.com/ianhi/BDS-sampler/actions)
[![codecov](https://codecov.io/gh/ianhi/BDS-sampler/branch/master/graph/badge.svg)](https://codecov.io/gh/ianhi/BDS-sampler)

cython bindings for Charo Del Genio's bi-degree sequence generator (https://charodelgenio.weebly.com/directed-graph-sampling.html)

which are an implementation of the paper Constructing and sampling directed graphs with given degree sequences https://doi.org/10.1088/1367-2630/14/2/023012

## Install

```bash
python setup.py build_ext -i
pip install .
```

# Usage

```python
from bds_sampler import sample
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

```

