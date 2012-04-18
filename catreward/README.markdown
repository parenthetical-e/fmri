A set of scripts to preprocess and analyze fMRI data for the catreward project.

# Preprocess, the plan:

* (0) Drop first 6 vols from all functional data for all Ss
 - Use fmri.nii.drop_vols(), sub.csv and func.csv

* (1) Realign - adjust for movement
* 'r' gets prefixed.

* (2) Functional slice time correction
 - To middle slice, by 4th degree splines
 - 'a' gets prefixed.

* (3) Functional to anatomical coregistration
 - By normalized mutual information

* (4) Normalize 
 - (4a) Get tranform params for ana.nii to T1.nii ("segment")
 - (4b) With 4a, transform ana.nii
 - (4c) and the functional data.
-  'w' gets prefixed.

* (5) Functional smooth (6mm)
 - 's' gets prefixed.

final anatomical name = wmana.nii 
final functional name = 'swar*.nii'

# THE PLAN IMPLEMENTED -- IN FUNCTIONS, ALSO A TEST

Transfered a fresh copy of 101M80351917/ then ran (in iPython)

	import fmri
	cd ~/Lab/catreward/fmri/data/
	cd 101M80351917/

	# DO (0)  
	fmri.nii.drop_vol(6,'pavlov.nii',True)
	fmri.nii.drop_vol(6,'taskA.nii',True)
	fmri.nii.drop_vol(6,'taskB.nii',True)
	fmri.nii.drop_vol(6,'coaster_localizer.nii',True)
		## Opened each of the files in MRIcron.  
		## The Volumne count was right

	
	cd ..
	from fmri.catreward import spm

	# DO (4a), (4B)
	spm.run(('cr_ana','101M80351917/'))
		## Intially failed.  Fixed by replacing a ExtList call on ana.nii with 
		## FPlist.  Everything now golden.  wmana.nii appears as expected.

	# DO (1)
	spm.run(('cr_realign','101M80351917/'))

	# DO (2), (3), (4c) and (5)
	
		## Repeat this section for all functional data.


	
	