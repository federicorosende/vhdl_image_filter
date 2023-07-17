import numpy as np
import cv2
from . import environment

class FilteredImage:

	_IMAGE_NAME = 'lenna.png'

	def __init__(self, apply_filter=True, debug=False):
		self._fpga_connection = environment.fpga_connection()
		self._apply_filter = apply_filter
		self._debug = debug

	def __store_image(self, processed_image):
		height = len(processed_image)
		width = len(processed_image[0])
		print(height, width)
		with open('debug.out', 'w') as f:
			for row in range(height):
				for col in range(width):
					f.write(str(processed_image[row][col]))
					f.write(' ')
				f.write('\n')

	def __process_image(self, image):
		processed_image = self._fpga_connection.process_image(image)
		if self._debug:
			self.__store_image(processed_image)
		return processed_image

	def __show_filtered_image(self):
		image = cv2.imread(self._IMAGE_NAME, cv2.IMREAD_UNCHANGED)
		cv2.imshow('image', self.__process_image(image) if self._apply_filter else image)
		cv2.waitKey(0)
		cv2.destroyAllWindows()

	def show(self):
		try:
			self.__show_filtered_image()
		finally:
			#self.release() UNCOMMENT TO USE WEBCAM
			del self._fpga_connection
