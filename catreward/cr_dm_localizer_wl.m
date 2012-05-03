function [names onsets durations] = cr_dm_localizer_wl(num,name),
% Return names,onset,durations (cell arrays) for win/lose data in filename.
%
% [names onsets durations] = cr_dm_localizer_wl(num,name)
% <num> is the subject code (101-118)
% <name> name of the localizaer data ('coaster_localizer' or 'pavlov')
%
% Data is saved to nod_wl_num_name.mat

	names = {'base','win','lose'};

	% Build the filename to load.
	if strcmp(name,'coaster_localizer'),
		filename = [num2str(num) '_54_localizer.dat'];
		wins_losses = cr_coaster_wl_decode(num);
			%% win/loss has to be decoded
			%% for coaster_localizer trial files....
	elseif strcmp(name,'pavlov'),
		filename = [num2str(num) '_54_pavlov_B.dat'];
		fpath = fullfile('behave',filename);	
		datmat = load(fpath);
		wins_losses = datmat(:,5);
			%% win/lose data is in col 5.
	else,
		error('<name> must be coaster_localizer or pavlov.')
	end

	% map lose to 2 (i.e. -1 -> 2)
	for ii=1:numel(wins_losses),
		if wins_losses(ii) == -1,
			wins_losses(ii) = 2;
		end
	end

	% Create onsets and durations.
	[onsets durations] = cr_dm_gen(wins_losses);
		%% in wins_losses -- 0: base, 1:win, 2:lose
		%% but the index must be shifted
		%% so onsets{1}:base, onsets{2}:win and so on.

	% Save the results to a mat file in the 
	% subject's fMRI data dir.
	save_path = fullfile(...
		cr_subdir(num),['nod_wl_' num2str(num) '_' name '.mat'])
	save(save_path,'names','onsets','durations');

end