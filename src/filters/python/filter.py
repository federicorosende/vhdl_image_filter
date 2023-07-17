import os
import math
import numpy as np
from queue import Queue
from threading import Thread
from .utils import QueuedThread

class ImageFilter(Thread):

	def __init__(self, thread_number, number_of_threads, handle):
		super().__init__()
		self._origin_images = Queue()
		self._destination_images = Queue()
		self._thread_number = thread_number
		self._number_of_threads = number_of_threads
		self.daemon = True
		self._handle = handle

	def _send_data(self):
		origin_image = self._origin_images.get()
		height = len(origin_image)
		width = len(origin_image[0])
		image_partitions = math.ceil(height/self._number_of_threads)
		first_row = max(1, image_partitions*self._thread_number)
		last_row = min(height-1, image_partitions*(self._thread_number+1))
		for row in range(first_row, last_row):
			for col in range(1, width-1):
				self._send_pixel(origin_image, row, col)

	def _read_data(self):
		destination_image = self._destination_images.get()
		height = len(destination_image)
		width = len(destination_image[0])
		image_partitions = math.ceil(height/self._number_of_threads)
		first_row = max(1, image_partitions*self._thread_number)
		last_row = min(height-1, image_partitions*(self._thread_number+1))
		for row in range(first_row, last_row):
			for col in range(1, width-1):
				self._read_pixel(destination_image, row, col)

	def _send_pixel(self, origin_image, row, col):
		raise NotImplementedError

	def _read_pixel(self, destination_image, row, col):
		raise NotImplementedError

	def put(self, origin_image, destination_image):
		self._origin_images.put(origin_image)
		self._destination_images.put(destination_image)

	def run(self):
		send_thread = Thread(target=self._send_data)
		read_thread = QueuedThread(target=self._read_data)
		send_thread.start()
		read_thread.start()
		send_thread.join()
		read_thread.join()

class FPGAImageFilter(ImageFilter):

	def _send_pixel(self, origin_image, row, col):
		fl.flWriteChannel(self._handle, self._thread_number, bytearray(np.append(origin_image[row][col], 255))) # Add alpha
				
	def _read_pixel(self, destination_image, row, col):
		destination_image[row][col] = np.array(fl.flReadChannel(self._handle, self._thread_number, 24)) # RGB
		fl.flReadChannel(self._handle, self._thread_number, 8) # A

class MockedImageFilter(ImageFilter):

	def __init__(self, thread_number, number_of_threads, handle):
		super().__init__(thread_number, number_of_threads, handle)
		self._comm_queue = Queue()

	def _send_pixel(self, origin_image, row, col):
		new_pixel = (
				origin_image[row][col].astype('int64')		+
				origin_image[row][col-1].astype('int64')	+
				origin_image[row][col+1].astype('int64')	+
				origin_image[row-1][col-1].astype('int64')	+
				origin_image[row-1][col].astype('int64')	+
				origin_image[row-1][col+1].astype('int64')	+
				origin_image[row+1][col-1].astype('int64')	+
				origin_image[row+1][col].astype('int64')	+
				origin_image[row+1][col+1].astype('int64')
			)//9
		self._comm_queue.put(new_pixel.astype('int8'))
	
	def _read_pixel(self, destination_image, row, col):
		destination_image[row][col] = self._comm_queue.get()