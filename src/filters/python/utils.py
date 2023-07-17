import argparse
from threading import Thread
from queue import Queue

class QueuedThread(Thread):
	
	def __init__(self, *args, **kwargs):
		super().__init__(*args, **kwargs)
		self._comm_queue = Queue()

	def put(self, data):
		self._comm_queue.put(data)

	def get(self):
		return self._comm_queue.get()

def parseargs():
	parser = argparse.ArgumentParser(prog='flLoop', description='Host side loop with FPGALink')
	parser.add_argument('-b', '--board', metavar="<board>", help="board: nexys2-500, atlys")                             
	parser.add_argument('-i', '--ividpid', metavar="<VID:PID>", help="initial vendor ID and product ID(e.g 04B4:8613)")                             
	parser.add_argument('-v', '--vidpid', default='1443:0005', metavar="<VID:PID>", help="vendor ID and product ID (default 1443:0005 Nexys2)")
	parser.add_argument('-x', '--xsvf',metavar="<xsvf file>", help="device programming with XVSF file")
	parser.add_argument('-j', '--justloop',action='store_true', help="Solo probar el loop. No programar FPGA")     
	return parser.parse_args()