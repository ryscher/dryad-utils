import sys
from PIL import Image, ImageColor
from os.path import basename, splitext

__author__ = 'dan.leehr@nescent.org'


FRONT_COVER_DIMS = (100, 130)
PKG_COVER_DIMS = (160, 200)

FRONT_OUTPUT_DIR = "/Users/dan/Code/dryad-repo/dspace/modules/xmlui/src/main/webapp/themes/Mirage/images/"
PKG_OUTPUT_DIR = "/Users/dan/Code/dryad-repo/dspace/modules/xmlui/src/main/webapp/themes/Dryad/images/coverimages/"

class CoverGenerator(object):
	def __init__(self, filename):
		self.filename = filename
		self.image = None
		self.dims = None
		self.output_filename = None
		self.bgcolor = "rgba(255,255,255,255)"

	def read_image(self):
		if self.image is None:
			self.image = Image.open(self.filename)
		return

	def generate_front_cover(self):
		self.read_image()
		""" Generate a cover image sized for the dryad homepage """
		self.dims = FRONT_COVER_DIMS
		return self.generate_cover()

	def generate_pkg_cover(self):
		""" Generate a cover image sized for the data package page """
		self.dims = PKG_COVER_DIMS
		return self.generate_cover()

	def generate_cover(self):
		""" Generate a cover image with the specified size """
		thumb = self.image.copy()
		thumb.thumbnail(self.dims, Image.ANTIALIAS)
		color = ImageColor.getrgb(self.bgcolor)
		frame = Image.new(thumb.mode, self.dims, color=color)
		box = ((self.dims[0] - thumb.size[0])/2, (self.dims[1] - thumb.size[1])/2)
		if thumb.mode == 'RGBA':
			frame.paste(thumb, box, thumb)
		else:
			frame.paste(thumb, box)
		self.image = frame

	def write_cover(self):
		self.image.save(self.output_filename, "PNG")

	def write_front_cover(self, output_filename):
		self.generate_front_cover()
		self.output_filename = output_filename
		self.write_cover()

	def write_pkg_cover(self, output_filename):
		self.generate_pkg_cover()
		self.output_filename = output_filename
		self.write_cover()

if __name__ == '__main__':
	filename = sys.argv[1]
	generator = CoverGenerator(filename)
	if len(sys.argv) > 2:
		generator.bgcolor = sys.argv[2]
	base = splitext(basename(filename))[0]
	generator.write_front_cover(FRONT_OUTPUT_DIR + "recentlyIntegrated-" + base + ".png")
	generator.write_pkg_cover(PKG_OUTPUT_DIR + base + ".png")

