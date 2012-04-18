A set of scripts to preprocess and analyze fMRI data for the catreward project.

# Preprocess, The Plan:

* (0) Drop first 6 vols from all functional data for all Ss
 - Use fmri.nii.drop_vols(), sub.csv and func.csv

* (1) Realign - adjust for movement
 - 'r' gets prefixed.

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
final functional name = swar*.nii

# The Plan, Implemented -- In Functions, A Test For a Single S.

Transfered a fresh copy of 101M80351917/ then ran (in iPython)

	from fmri.catreward import spm

	cd ~/Lab/catreward/fmri/data/

	# DO (0), all Ss and functional scans
	spm.drop6(subfile='sub.csv',funcfile='func.csv')
		## drop the first 6 volumes, 
		## backing up org data to org<nii>*

	# DO (4a), (4B)
	spm.run(('cr_ana','101M80351917/'))
		## Intially failed.  Fixed by replacing a ExtList call on ana.nii with 
		## FPlist.  Everything now golden.  wmana.nii appears as expected.

	# DO (1)
	spm.run(('cr_realign','101M80351917/'))

	# DO (2), (3), (4c) and (5)
	spm.run(('cr_func','101M80351917/','pavlov'))
	spm.run(('cr_func','101M80351917/','taskA'))
	spm.run(('cr_func','101M80351917/','taskB'))
	spm.run(('cr_func','101M80351917/','coaster_localizer'))
		## As done here, repeat this section for
		## all functional data.

## Testing the Batch Methods

Copied fresh data for both 101M80351917 and 105M80350861.

	cd ~/Lab/catreward/fmri/data/

	# Contents of func and sub.csv were:
	> lordbox-2:data type$ cat sub.csv 
	> 101M80351917,105M80350861
	> lordbox-2:data type$ cat func.csv 
	> pavlov,taskA,taskB,coaster_localizer
	
	from fmri.catreward import spm
	
	# Go!
	spm.drop6(subfile='sub.csv',funcfile='func.csv')

	# Make the 3 batches (cr_ana, cr_realign and cr_func), 
	# run each in turn.
	b1,b2,b2 = spm.make_batch()
	[spm.run(args) for args in b1]
	[spm.run(args) for args in b2]
	[spm.run(args) for args in b3]
		## b1,b2 could have been run in parallel
		## b3 needs b1,2
