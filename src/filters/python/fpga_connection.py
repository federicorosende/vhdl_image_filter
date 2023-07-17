import time
import copy
from .filter import MockedImageFilter, FPGAImageFilter

NEXYS = "nexys2-500"
ATLIS = "atlys"

class Connection(object):

	def __init__(self, args, filter_cls):
		self._board = args.board
		self._vidpid = args.vidpid
		self._ividpid = args.ividpid
		self._justloop = args.justloop
		self._xsvf = args.xsvf
		self._usb_power = self._board == NEXYS
		self._connect()
		self._image_filters = []
		for thread_number in range(self._NUMBER_OF_THREADS):
			self._image_filters.append(filter_cls(thread_number, self._NUMBER_OF_THREADS, self._handle))
			self._image_filters[thread_number].start()

	def _new_image_filter(self):
		raise NotImplementedError

	def _connect(self):
		raise NotImplementedError

	def process_image(self, pixel):
		raise NotImplementedError

	def process_image(self, image):
		new_image = copy.deepcopy(image)
		for image_filter in self._image_filters:
			image_filter.put(image, new_image)
		for image_filter in self._image_filters:
			image_filter.join() 
		return new_image

	def __del__(self):
		for image_filter in self._image_filters:
			image_filter.join() 


class MockedFPGAConnection(Connection):

	_NUMBER_OF_THREADS = 2

	def __init__(self, args):
		super().__init__(args, MockedImageFilter)

	def _connect(self):
		print('Mocked connection')
		self._handle = None

class FPGAConnection(Connection):

	_NUMBER_OF_THREADS = 2

	def __init__(self, args):
		super().__init__(args, FPGAImageFilter)

	def _connect(self):
		print('FPGA connection')
		try:
			self._handle = fl.flOpen(self._vidpid)
		except fl.FLException as ex:
			vidpid = self._ividpid or self._vidpid
			print("Loading firmware into {}...".format(self._vidpid))
			fl.flLoadStandardFirmware(self._vidpid, self._vidpid)
			if self._ividpid == vidpid: 
				print("Awaiting renumeration...")

		if not self._justloop:
			if self._usb_power:
				fl.flMultiBitPortAccess(self._handle, "D7+")

			if self._xsvf != None:
				print("Programming FPGA with " + self._xsvf)
				fl.flProgram(self._handle, "J:D0D2D3D4:" + self._xsvf)
			
			fl.flSelectConduit(self._handle, 1)
		time.sleep(1)


	def __del__(self):
		fl.flClose(self._handle)
		super().__del__()