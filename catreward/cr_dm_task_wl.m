function [names onsets durations] = cr_dm_task_wl(filename,task),
% Return names,onsets,durations (cell arrays) for task ('A' or 'B') data in filename.

	trials = [1 1 4 4 6 0 4 2 4 1 0 0 0 0 5 4 5 1 5 5 3 6 6 0 0 2 2 3 3 1 3 2 4 2 2 6 0 5 3 1 2 2 0 4 3 0 0 6 5 6 6 5 1 0 0 5 5 2 2 6 2 0 0 0 6 6 5 0 0 0 0 4 6 4 5 6 4 0 0 0 0 3 3 4 2 5 5 1 0 3 3 1 1 0 6 1 5 3 3 0 4 6 0 0 0 1 2 2 0 5 0 4 4 4 3 3 2 0 1 0 0 0 4 4 0 0 2 1 6 6 2 4 4 1 1 1 5 4 0 6 0 3 3 5 5 4 2 1 1 1 6 1 1 0 2 0 0 6 5 6 0 3 4 3 3 6 4 0 6 6 6 1 1 3 6 3 0 5 5 3 0 0 0 2 2 2 3 2 6 3 5 5 0 1 0 2 5 2 4 1 4 4 4 0 5 5 6 0 3 4 0 5 0 0 6 1 3 5 0 3 0 0 1 6 3 0 2 2 0 5 5 2 5 0 1 4 1 2 0 0 3 0 0 1 3 2 1 4 0 3 5 0 0 4 0 5 2 6 6 2 1 6 0 2 3 3 6 4 4 2];

	if task == 'A',
		trials = trials(1:135);
	elseif task == 'B',
		trials = trials(136:end);
	else,
		error('<task> must be A or B.');
	end

	names = {'base','win','lose'};
	
	% load the filename
	[idx stim resp acc rt cresp cate wid ang unk wl] = textread( ...
		filename,'%u %s %u %u %f %u %f %f %f %f %f ');

	% map lose to 2 (i.e. -1 -> 2)
	for ii=1:numel(wl),
		if wl(ii) == -1,
			wl(ii) = 2;
		end
	end

	% Loop over trials
	% If it is baseline (0), leave that
	% element in wl_trials alone
	% if it is greater then 0
	% replace it with the matching wl
	% then update the wl counter
	% (wl_cnt).
	wl_trials = trials;
	wl_cnt = 1;
	for ii=1:numel(trials),
		t = trials(ii);
		if t > 0,
			wl_trials(ii) = wl(wl_cnt);
			wl_cnt = wl_cnt + 1;
		end
	end

	% Create the offsets, durations
	% with wl_trials.
	[onsets durations] = cr_dm_gen(wl_trials);
	save(['nod_wl_' filename '.mat'],'names','onsets','durations');
end