function cr_realign(dir_path),
% Realign *all* catreward functional data in <dir_path>.
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
		% SPM8 only

	% Set the wd.
	clear jobs
	jobs{1}.util{1}.cdir.directory = cellstr(fullfile(dir_path));
	
	% REALIGN, do it for all functional data.
	% Get all file names and volumne counts for each
	% of the functional sets, in order.
	func_names = {'pavlov' 'taskA' 'taskB' 'coaster_localizer'}
	allf = {}
	for ii=1:size(func_names,2),
		func_name = func_names{ii}
		cf = cellstr(spm_select( ...
			'ExtList', dir_path, ['^' func_name '.*\.nii$'], 1:10000));
		allf = cat(1,allf,cf);
	end
	jobs{2}.spatial{1}.realign{1}.estwrite.data{1} = allf;
	
	% RUN
	save(['batch_func_realign.mat'],'jobs');
	spm_jobman('run',jobs);
	
	exit
end