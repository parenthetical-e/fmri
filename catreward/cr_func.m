function cr_func(dir_path,func_name),
% Preprocess <func_name> in <dir_path>, using ana.nii to coregister.
% 
% This is designed for command line use only.
%
% This code was modified from:
% This batch script analyses the Face fMRI dataset available from the SPM site:
% http://www.fil.ion.ucl.ac.uk/spm/data/face_rep/face_rep_SPM5.html
% as described in the manual Chapter 29.

	% SPM go!
	spm('Defaults','fMRI');
	spm_jobman('initcfg'); 
		%% SPM8 only

	clear jobs
	jobs{1}.util{1}.cdir.directory = cellstr(fullfile(dir_path));
		%% Set wd	

	f = spm_select('ExtList', dir_path, ['^' func_name '.nii$'],1:1000);
	a = spm_select('FPList', dir_path, ['^ana.nii$'])
		%% This returns absolute path of every volumne in func_name or 
		%% ana_name which we assume is a 4d nifti file
	
	% SLICE TIMING CORRECTION
	tr = 1.5;
	nslice = 26;
	jobs{2}.temporal{1}.st.scans{1} = editfilenames(f,'prefix','r');
	jobs{2}.temporal{1}.st.nslices = nslice;
	jobs{2}.temporal{1}.st.tr = tr;
	jobs{2}.temporal{1}.st.ta = tr-tr/nslice;
	jobs{2}.temporal{1}.st.so = nslice:-1:1;
	jobs{2}.temporal{1}.st.refslice = nslice/2;

	% COREGISTRATION
	jobs{3}.spatial{1}.coreg{1}.estimate.ref = editfilenames( ...
			f(1,:),'prefix','mean');
	jobs{3}.spatial{1}.coreg{1}.estimate.source = cellstr(a);

	% NORMALIZE
	jobs{3}.spatial{2}.normalise{1}.write.subj.matname  = editfilenames( ...
			a,'suffix','_seg_sn','ext','.mat')
	ff = editfilenames(f(1,:),'prefix','mean')
	jobs{3}.spatial{2}.normalise{1}.write.subj.resample = [editfilenames( ...
			f,'prefix','ar'); {ff{1}}]
	jobs{3}.spatial{2}.normalise{1}.write.roptions.vox  = [3 3 4]

	jobs{3}.spatial{2}.normalise{2}.write.subj.matname  = editfilenames( ...
			a,'suffix','_seg_sn','ext','.mat')
	jobs{3}.spatial{2}.normalise{2}.write.subj.resample = editfilenames( ...
			a,'prefix','m')
	jobs{3}.spatial{2}.normalise{2}.write.roptions.vox  = [1 1 1]

	% SMOOTHING
	jobs{3}.spatial{3}.smooth.data = editfilenames(f,'prefix','war');
	matlabbatch{1}.spm.spatial.smooth.fwhm = [6 6 6];
		%% Use 6 mm smoothing in place of the 8 default

	% Go!
	save(['batch_func_' func_name '.mat'],'jobs');
	spm_jobman('run',jobs);
	
	exit
end