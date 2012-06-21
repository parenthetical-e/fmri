function cr_realign(dir_path),
% Realign *all* catreward functional data in <dir_path>.
%
% cr_realign(dir_path)
%

	% SPM go!
	spm('Defaults','fMRI');
	spm_jobman('initcfg'); 
		% SPM8 only

	% Set the wd.
	clear jobs
	jobs{1}.util{1}.cdir.directory = cellstr(dir_path);
	
	% REALIGN, do it for all functional data.
	% Get all file names and volumne counts for each
	% of the functional sets, in order.
	func_names = {'pavlov' 'taskA' 'taskB' 'coaster_localizer'};
	allf = {};
	for ii=1:size(func_names,2),
		func_name = func_names{ii};
		cf = cellstr(spm_select( ...
			'ExtList', dir_path, ['^' func_name '.*\.nii$'], 1:10000));
		allf = cat(1,allf,cf);
	end
	jobs{2}.spatial{1}.realign{1}.estwrite.data{1} = allf;

	% RUN
	spm_jobman('run',jobs);
	
	movefile('meanpavlov.nii','meanfunc.nii');
		%% spm uses the first filename for the mean image,
		%% but the mean imag will relfect all the functional data
		%% do we rename it.
	exit
end