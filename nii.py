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


def basics(nii=''):
	""" Return basic information about <nii>, a nifti file. """

	nf1 = load(nii)

	info = {}
	info[nii] = {'shape':nf1.shape, 'dtype':nf1.get_data_dtype()} 
	return info


def drop_vol(n=6,nii='',backup=True):
	""" 
	Drop <n> vol from the nifti file, <nii>. 

	If True <backup> the orginal nii as org<nii>.
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


def loop(dir='.'):
	""" 
	Recursively loop over <dir>, returning and printing basic info for
	each .nii encountered.
	"""
	import pprint
	
	rootnode = os.path.abspath(dir)
	loopinfo = {}
	for root, subFolders, files in os.walk(rootnode,followlinks=True):
		[loopinfo.update(basics(os.path.join(root,f))) for f in files]

	pprint.pprint(sorted(loopinfo.items()))
	
	return loopinfo

