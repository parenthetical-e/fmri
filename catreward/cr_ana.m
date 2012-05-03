function cr_ana(dir_path),
% Segment ana.nii in <dir_path>.
%
% cr_ana(dir_path),
%

	% Get SPM up...
	spm('Defaults','fMRI');
	spm_jobman('initcfg'); 
		%% SPM8 only; what does this do?

	clear jobs
	jobs{1}.util{1}.cdir.directory = cellstr(dir_path);
		%% Change the pwd

	% Get full ana name then SEGMENT (which also returns 
	% normalization parameters for ana.nii - 'ana_seg_sn.mat')
	a = spm_select('FPList', dir_path, ['^ana.nii$']);
	%jobs{2}.spatial{1}.preproc.data = cellstr(a);

	% then NORMALIZE and isovoxel ana.nii
	jobs{2}.spatial{1}.normalise{1}.write.subj.matname  = editfilenames( ...
			a,'suffix','_seg_sn','ext','.mat');
	jobs{2}.spatial{1}.normalise{1}.write.subj.resample = editfilenames( ...
			a,'prefix','m');
	jobs{2}.spatial{1}.normalise{1}.write.roptions.vox  = [1 1 1];
	jobs{2}.spatial{1}.normalise{1}.write.roptions.interp = 4;
		%% 4th degree B spline

	% RUN
	spm_jobman('run',jobs);
	
	exit
end