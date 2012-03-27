#! /usr/local/bin/python
""" 
A module for the display of nifti metadata.  

If called from the CL, basic nifti info is printed recusivly for all files 
in the pwd.
"""
import os
import nibabel as nb

def basics(nii=''):
	""" Return basic information about <nii>, a nifti file. """

	info = {}
	try:
		# Duck loading....
		nf1 = nb.nifti1.load(nii)
		info[nii] = {'shape':nf1.shape, 'dtype':nf1.get_data_dtype()} 
	except IOError:
		pass
	# Catches and ignores files that are not nifti.
	except nb.spatialimages.ImageFileError:
		pass # print('{0} is not nii.'.format(nii))

	return info


def loop(dir='.'):
	""" 
	Recursivly loop over <dir>, printing out basic info for each .nii
	encountered.
	"""

	rootnode = os.path.abspath(dir)
	loopinfo = {}
	for root, subFolders, files in os.walk(rootnode,followlinks=True):
		[loopinfo.update(basics(os.path.join(root,f))) for f in files]

	return loopinfo


if __name__ == '__main__':
	import pprint

	niiinfo = loop()
	pprint.pprint(sorted(niiinfo.items()))
