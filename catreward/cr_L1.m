function cr_L1(fname,num,cond_code,func_names,cond_names,event),
% Run a Level 1 analysis.
%
% cr_L1(num,func_names,cond_name,num_levels,event)
%
% <fname> where all the SPM files will end up
% <num> subject number, an int
% <func_names> should be a cell array of strings (name of the functional data)
% <cond_name> the name of the experimental conditions (e.g. wl)
% <num_levels> the number of levels for the condition
% If <event> is 1, set durations to 0. If 0, use nod_* durations.

	% Intial var setup
	tr = 1.5;
	nslice = 26;
	num_levels = numel(cond_names);

	nod = {};
	for ii=1:numel(func_names),
		fpath = fullfile(cr_subdir(num),['nod_' cond_code '_' num2str(num) '_' func_names{ii} '.mat']);
		nod{ii} = load(fpath);
	end

	data_path = cr_subdir(num);
	data_path = fullfile(pwd,data_path)

	% Create the dir for the model files, if necessary.
	if exist(fullfile(data_path,fname),'dir') ~= 7,
		mkdir(fullfile(data_path,fname));
	end

	% SPM go!
	spm('Defaults','fMRI');
	spm_jobman('initcfg'); 
		%% SPM8 only
	
	clear jobs
	
	jobs{1}.util{1}.cdir.directory = cellstr(data_path);
		%% set wd	

	 jobs{1}.util{1}.md.basedir = cellstr(data_path);
	% jobs{1}.util{1}.md.name = fname;
		%% Output lives here

	% MODEL SPECIFICATION
	jobs{2}.stats{1}.fmri_spec.dir = cellstr(fullfile(data_path,fname));
	jobs{2}.stats{1}.fmri_spec.timing.units = 'scans';
	jobs{2}.stats{1}.fmri_spec.timing.RT = tr;
	jobs{2}.stats{1}.fmri_spec.timing.fmri_t = nslice;
	jobs{2}.stats{1}.fmri_spec.timing.fmri_t0 = nslice/2;
	
	% loop over func_names, setting model data
	% for each.
	for ii=1:numel(func_names),
		% Set data locations
			f = spm_select(...
				'ExtFPListRec', data_path, ['^' func_names{ii} '.nii$'],Inf);
			
			jobs{2}.stats{1}.fmri_spec.sess(ii).scans = editfilenames(...
				f,'prefix','swar');
			f
			% Movement regressor, hardcoded
			jobs{2}.stats{1}.fmri_spec.sess(ii).multi_reg = cellstr(...
				fullfile(data_path,['rp_' func_names{ii} '.txt']));

		for jj=1:numel(cond_names),
			% Set design info
		    jobs{2}.stats{1}.fmri_spec.sess(ii).cond(jj).name = nod{ii}.names{jj};
		    jobs{2}.stats{1}.fmri_spec.sess(ii).cond(jj).onset = nod{ii}.onsets{jj};

		    if event == 1,
		    	jobs{2}.stats{1}.fmri_spec.sess(ii).cond(jj).duration = 0;
		    elseif event == 0,
		    	jobs{2}.stats{1}.fmri_spec.sess(ii).cond(jj).duration = nod{ii}.durations{jj};
		    else,
		    	error('<event> must be 0 or 1.');
		    end
		end
	end

	% Factorial info
	% jobs{2}.stats{1}.fmri_spec.fact.name = cond_code
	% jobs{2}.stats{1}.fmri_spec.fact.levels = num_levels
	
	% HRF choice and params
	% jobs{2}.stats{1}.fmri_spec.bases.hrf.derivs = [1 1];
		%% the [1 1] adds time and 
		%% dispersion to the canonical HRF.

	% % MODEL ESTIMATION
	jobs{2}.stats{2}.fmri_est.spmmat = cellstr(fullfile(data_path,fname,'SPM.mat'));

	% % INFERENCE
	% jobs{2}.stats{3}.results.spmmat = cellstr(fullfile(data_path,fname,'SPM.mat'));
	% jobs{2}.stats{3}.results.conspec(1).contrasts = Inf;
	% jobs{2}.stats{3}.results.conspec(1).threshdesc = 'FWE';

	% jobs{2}.stats{4}.results.spmmat = cellstr(fullfile(data_path,fname,'SPM.mat'));
	% jobs{2}.stats{4}.results.conspec(1).titlestr = 'main effects';
	% jobs{2}.stats{4}.results.conspec(1).contrasts = 3;
	% jobs{2}.stats{4}.results.conspec(1).threshdesc = 'none';
	% jobs{2}.stats{4}.results.conspec(1).thresh = 0.001;
	% jobs{2}.stats{4}.results.conspec(1).extent = 0;
	% jobs{2}.stats{4}.results.conspec(1).mask.contrasts = 5;
	% jobs{2}.stats{4}.results.conspec(1).mask.thresh = 0.001;
	% jobs{2}.stats{4}.results.conspec(1).mask.mtype = 0;

	% jobs{2}.stats{5}.con.spmmat = cellstr(fullfile(data_path,fname,'SPM.mat'));
	% jobs{2}.stats{5}.con.consess{1}.fcon.name = 'Movement-related effects';
	% fcont = [zeros(6,3*4) eye(6)]; 
	% for i=1:size(fcont,1)
	% 	jobs{2}.stats{5}.con.consess{1}.fcon.convec{1,i} = fcont(i,:);
	% end
	% jobs{2}.stats{6}.results.spmmat = cellstr(fullfile(data_path,fname,'SPM.mat'));
	% jobs{2}.stats{6}.results.conspec(1).contrasts = 17;
	% jobs{2}.stats{6}.results.conspec(1).threshdesc = 'FWE';
	
	% RUN
	spm_jobman('run',jobs);

end