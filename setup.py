# from setuptools import setup

# from distutils.
from distutils.core import setup

from Cython.Build import cythonize
from distutils.extension import Extension
import numpy as np

# mt = Extension(
#     "mt",
#     sources=["bds_sampler/mt/mt19937ar.c"],
#     include_dirs=[np.get_include()],
# )


# ext_modules = cythonize("project/*/*.pyx")
ext = Extension(
    "bds_sampler._sampler",
    [
        "bds_sampler/_sampler/BDS_sampler.pyx",
        "bds_sampler/_sampler/mt19937ar.c",
        "bds_sampler/_sampler/DiGSampler.c",
    ],
    include_dirs=[np.get_include(), "bds_sampler/_sampler"],
)

setup(
    name="bds_sampler",
    use_scm_version={"write_to": "bds_sampler/_version.py"},
    ext_modules=cythonize(
        [ext],
        language_level=3,
        compiler_directives={"embedsignature": True},
    ),
)
