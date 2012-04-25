function [onsets durations] = cr_dm_gen(trials),
%  <trials>, a 1d array trial event, get mapped to onsets and durations in TR time.

	trial_duration = 3;
	jitter_duration = 2;
	
	% Init onsets and durations
	onsets = {};
	durations = {};
	conds = unique(trials);
	for ii=1:numel(conds)
		c = conds(ii)+1;
			%% cell arrays are 1 indexed not 0...
		onsets{c} = [];
		durations{c} = [];
	end

	% Construct them...
	last = 0;
	for ii=1:numel(trials),
		c = trials(ii)+1;
			%% Again, correcting the index

		onsets{c} = [onsets{c} ii+last];
		if c == 1,
			durations{c} = [jitter_duration durations{c}];
			last = last + jitter_duration-1;
		else,
			durations{c} = [trial_duration durations{c}];
			last = last + trial_duration-1;
		end
	end
end