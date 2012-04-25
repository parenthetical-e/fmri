function [names onsets durations] = cr_dm_localizer_wl(filename),
% Return names,onset,durations (cell arrays) for the localizer data in filename

	names = {'base','win','lose'};

	datmat = load(filename);
	wins_losses = datmat(:,5);

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

	% Save the results to mat file.
	save(['nod_wl_' filename '.mat'],'names','onsets','durations');

end