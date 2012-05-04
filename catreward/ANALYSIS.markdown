All code is available on [github](https://github.com/andsoandso/fmri).

# DICOM to NIFIT

Delete any .nii already present.  The MIND databse pre-create some oddly size ones I am discarding.  Then for each set of dicoms run:

dm2niigui in 'FSL (4D Nifti nii)' mode.    
Note: a full copy of the dcm2niigui config files was saved in dcm2nii_config.txt.

	dir : name
	ANATOMICAL_TASK_235_v01_r01_0011 : pavlov.nii
	LOCALIZER_235_v01_r01_0014 : coaster_localizer.nii
	mprage_5e_RMS_0003: ana.nii
	gre_field_mapping_0010 : field.nii
	PD_tra_MT_PULSE_0011 : mt_ana.nii
	TASK_1_380_v01_r01_0008 : taskA.nii
	TASK_2_384_v01_r01_0013 : taskB.nii

Then just in case (I am nor sure what to with these data types yet), copy over and rename the following dicom dirs
	
	PD_tra_MT_PULSE_0011 : mt
	gre_field_mapping_0010 : field

Now copy all of the above to the top level dir for that subject and delete the Study* folder.  The above is all that is needed for analyses, I hope.

## NOTES: 

On conversion 'mprage_5e_RMS_0003' from 

	M80351917, M80350861, M80355734, M80357327, M80358136, M80359344, M80368842, ... (all the rest) 

yielded 3 nii files.  I have no idea why.  They each had different prefixs and all were copied over as below. Prefix became suffix.  Just using ana.nii.

	ana.nii
	ana_co.nii
	ana_o.nii

There were two MT for 

	M80355734, 013 and 014.  

Use 014, 013 errored out during acquisition; it apperared fine but to be safe 014 was acquired too.  013 was deleted.

For task1/A of M80358136 there were three restarts - 

	TASK_1_380_v01_r01_0013 

is the good set.

On conversion for 

	117M80354305, LOCALIZER_235_v01_r01_0011, 

produced .bval and .bvec files in addtion to the nii file that was expected.  The unexpected files were discarded.  Followup with Kevin, what were these?

Renamed datafiles to reflect both the database code and my subject code numbers, i.e.

	101M80351917
	102M80359344
	103M80358136
	104M80368842
	105M80350861
	106M80381623
	108M80357327
	109M80328568
	111M80343408
	112M80364602
	113M80380288
	114M80371580
	115M80364638
	116M80363397
	117M80354305
	118M80330684

is the total set of names for this project.

# Preprocessing in SPM8

Used SpmBatchMode.m as an example to write 
	
	cr_ana.m - segments the anatomical data.
	cr_realign.m - realigns all the functional datasets
	cr_func.m - finish functional preprocessing (slicetime, coreg, normalization, and smooth)

	cr_ana and cr_realign are indepedent of each other (and form batch1.py) while cr_func require the first two (thus forms batch2.py).

which I then wrapped in some python 

	spm.py

to allow for easy parallelization in iPython/StarCluster.  Parallelization happend as below, using the 3 batchs above.

The three batches were created by (in iPython; the fmri module was on the PYTHONPATH):

	import fmri
	batch1, batch2, batch3 = fmri.catreward.spm.make_batch()

The initial goal was to run b1,b2 then b3 as batch jobs over a set of EC2 16 nodes. However a impossible to resolve BUS ERROR (likely in numpy) made this impractical.  As such, thet were run over the 2 cores of my laptop.  See the 'Testing iPython parallelization' section of the README to details.

	# at the commandline
	pcluster start --n=2 
	ipython

	# with iPython running
	cd ~/Lab/catreward/fmri/data/

	from IPython.parallel import Client
	rc = Client(); view = rc[:]

	b1,b2,b3 = spm.make_batch()
	res_b1 = view.map_async(spm.run,b1)
	res_b2 = view.map_async(spm.run,b2)
	res_b3 = view.map_async(spm.run,b3)
		## total run time was ~14 hours.

Local data was then coppied up to an EBS volume (vol-a4ff85ce) for backup.  It took 3 or so days.  See .../catreward/preprocessed.

After automoated processing the aligment and registration for each suject was examined by hand using the '' feature of SPM.  All appeared acceptable.  Likewise the swar* verions of the anatomical sets were visually examined (using the, superior to SPM, FLSview.app).  Again, everything appeared ok.

Code used for preprocessing was tagged as "preprocessing" (Commit: c39dfe6e0f30b0c902573e2434e6d55e3650911a)

# Analysis in SPM (1)

The primary goal was to use the pavlov and coaster_localizer scans to define frontal, strial, and brainstem ROIs for model-based analysis of taskA and taskB data (extracting average timecourses for each subject for each individual ROI).

## Functional number of vols (from swar*):

101 pavlov 229
102 pavlov 231
103- pavlov 241

101 coaster_localizer 229
102 coaster_localizer 231
103- coaster_localizer 241

101 taskA 374
102- taskA 384

101 taskB 378
102- taskB 388

Predicted lsength of the coreg file
101 rp_pavlov.txt 1210 (checks)
102 rp_pavlov.txt 1234 (checks)
103- rp_pavlov.txt 1254 (checks)

## pre-run order

Ran (by hand) for 101:118, excluding 107, 110.  (tagged as "c1ana", Commit: 5a5649583bf24807cc23fcd026142de9b7ffe99e)
	
	cr_c1ana(cr_subdir(<num>))

Which puts the c1ana.nii file for each subject into MNI space.  c1ana is the white matter segments resulting from cr_ana().

Then created and ran

	function cr_dm_batch(),
		% A batch file crating dms for all Ss.
    
	    sub_codes = [101:106 108:109 111:118]
	    for ii=1:numel(sub_codes),
	        num = sub_codes(ii)

	        cr_dm_localizer_wl(num,'pavlov')
	        cr_dm_localizer_wl(num,'coaster_localizer')
	        
	        cr_dm_task_wl(num,'A')
	        cr_dm_task_wl(num,'B')
	        
	        cr_coreg_split(num)
	    end
	end

	cr_dm_localizer_wl(num,name)
	cr_dm_task_wl(num,task)
	cr_coreg_split(num)

Then finally

	cr_L1(num,cond_code,func_names,cond_names,event)

Or fully specified for 101

	cr_L1('spm_task',101,'wl',{'taskA','taskB'},{'base', 'win', 'lose'},1)
	cr_L1('spm_local',101,'wl',{'pavlov','coaster_localizer'},{'base', 'win', 'lose'},1)

	cr_L1_contrast_wl(101,'spm_task')
	cr_L1_contrast_wl(101,'spm_local')

Did the development on 101, then pulled a copy of 102 and 108 for confirmation.  




