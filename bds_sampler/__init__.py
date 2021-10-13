try:
    from ._version import __version__
except ImportError:
    __version__ = "unknown"

__author__ = "Ian Hunt-Isaak"
__email__ = "ianhuntisaak@gmail.com"

from ._sampler import initialize_cython, sample

__all__ = [
    "initialize_cython",
    "sample",
]
