import os
import sys
from .fpga_connection import MockedFPGAConnection, FPGAConnection

class EnvironmentMetaclass(type):
	def __call__(cls, *args, **kwargs):
		scope = os.environ.get('TARGET', 'LOCAL')
		subclasses = cls.__subclasses__()
		try:
			subclass = next(filter(lambda subclass : subclass.handles(scope), subclasses))
		except Exception as e:
			print('Please set the environment variable TARGET with LOCAL or FPGA')
			sys.exit(1)
		instance = subclass.__new__(subclass, *args, **kwargs)
		subclass.__init__(instance, *args, **kwargs)
		return instance

class Environment(metaclass=EnvironmentMetaclass):

	def fpga_connection(self):
		return self._fpga_connection

class LocalEnvironment(Environment):

	def __init__(self, parsed_args):
		self._fpga_connection = MockedFPGAConnection(parsed_args)

	@classmethod
	def handles(cls, scope):
		return scope == 'LOCAL'


class FPGAEnvironment(Environment):

	def __init__(self, parsed_args):
		self._fpga_connection = FPGAConnection(parsed_args)

	@classmethod
	def handles(cls, scope):
		return scope == 'FPGA'