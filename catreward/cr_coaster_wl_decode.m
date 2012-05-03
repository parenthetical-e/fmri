function [wl] = cr_coaster_wl_decode(num),
% Use data in pavlov to recode category distribution codes (1,2) in coaster_pavlov to gains and losses.
% 
% [wl] = cr_coaster_wl_decode(num)
%
% <num> subject code (101-118).
	
	% Load trial data for both
	% pavlov and coaster_localizer.
	cname = [num2str(num) '_54_localizer.dat'];
	cpath = fullfile('behave',cname);
	cdat = load(cpath);
	
	pname = [num2str(num) '_54_pavlov_B.dat'];
	ppath = fullfile('behave',pname);
	pdat = load(ppath);

	% Decode using pavlov...
	% col 1 is the cat code, 
	% 5 is gains or losses
	recode = [0 0];
		%% element 1 is cat 1, 2 is 2.
	for ii=1:size(pdat,1),
		cat_code = pdat(ii,1);
		wl_code = pdat(ii,5);
		if cat_code == 1,
			recode(1) = wl_code;
		elseif cat_code == 2,
			recode(2) = wl_code;
		end

		% Die once win/lose assigments 
		% are complete.
		if (min(recode) == -1) & (max(recode) == 1), break; end
	end

	% Create a null vector
	% then fill it with win/loss
	% codes using the cat_code from
	% cdat and recode (created above).
	wl = zeros(size(cdat,1),1);
	for jj=1:numel(wl),
		cat_code = pdat(jj,1);
		if cat_code == 0, continue; end
			%% 0 means fixation, skip it.
		wl(jj) = recode(cat_code);
	end
end