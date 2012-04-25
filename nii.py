""" 
A module for manipulating and analysis of nifti files.
"""
import os
import nibabel as nb


def _load(nii=''):
	""" A simple nifti loader suitable for recursively looping.... 
	Most failures are silent. """

	try:
		# Duck loading....
		nf1 = nb.nifti1.load(nii)	
	except IOError:
		pass
	# Catches and ignores files that are not nifti.
	except nb.spatialimages.ImageFileError:
		pass # print('{0} is not nii.'.format(nii))

	return nf1


def info(nii='',):
	""" Return file info about <nii>, a nifti file. """

	info = {}
	try:
		nf1 = nb.load(nii)
		## what info?
	except nb.spatialimages.ImageFileError, e:
		print('Could not read {0}. {1}'.format(nii,e))

	shape = nf1.shape
	# ... size, affline, ?

	pass


def drop_vol(n=6,nii='',backup=True):
	""" 
	Drop <n> vol from the nifti file, <nii>. 

	If True, <backup> the orginal nii as org<nii>.
	"""

	# Load nii, get its data 
	# the header and the affline params
	nf1 = nb.load(nii)
	
	data = nf1.get_data()
	header = nf1.get_header()
	affline = nf1.get_affine()

	dropped = data[...,n:]
		## dropping the first n time volumes
		## (x,y,z,t)

	nii_dropped = nb.Nifti1Image(dropped,affline,header)
		## Create a mew Nifti1Image with 
		## the dropped data.
	
	if backup:
		nb.save(nf1,'org'+nii)

	nb.save(nii_dropped,nii)


def aggregate_info(dir='.',write=True):
	""" 
	Recursively loop over <dir>, returning shape info for each
	.nii encountered.  Group that info by nii fies name

	If <write> is True, the data is written to a set of csv files 
	named <nii>_info.csv.
	"""
	import csv
	
	# rootnode = os.path.abspath(dir)
	# loopinfo = {}
	# for root, subFolders, files in os.walk(rootnode,followlinks=True):
	# 	[loopinfo.update((f,shape(os.path.join(root,f)))) for f in files]

	# if write:
	# 	f = open('nii_info.csv','w')
	# 	w = csv.writer(f)
	# 	niifiles = sorted(loopinfo.keys())
	# 	for nii in niifiles:
	# 		w.writerow(niifiles[nii].items())
			
	# 	f.flush()
	# 	f.close()

	# return loopinfo

