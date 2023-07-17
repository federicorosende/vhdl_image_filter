from .environment import Environment
from .utils import parseargs

environment = Environment(parseargs())

__all__ = ["environment"]