function cr_ana(dir_path),
% Segment ana.nii in <dir_path>.
%
% This is designed for command line use only.
%
% This code was modified from:
% This batch script analyses the Face fMRI dataset available from the SPM site:
% http://www.fil.ion.ucl.ac.uk/spm/data/face_rep/face_rep_SPM5.html
% as described in the manual Chapter 29.

	% Get SPM up...
	spm('Defaults','fMRI');
	spm_jobman('initcfg'); 
		%% SPM8 only; what does this do?

	clear jobs
	jobs{1}.util{1}.cdir.directory = cellstr(dir_path);
		%% Change the pwd

	% Get full ana name then SEGMENT
	a = spm_select('ExtList', dir_path, ['^ana.nii$'], 1:1000);
	jobs{2}.spatial{1}.preproc.data = cellstr(a);

	% RUN
	save(fullfile(dir_path,'batch_ana.mat'),'jobs');
	spm_jobman('run',jobs);
	
	exit
end