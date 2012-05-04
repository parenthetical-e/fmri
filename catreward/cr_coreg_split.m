function cr_coreg_split(num),
% Splits the rp_pavlov.txt in <num>'s fMRI data directory' 
% into its parts (pavlov, coaster_localizaer, taskA and B), 
% saving each.
%
% function cr_coreg_split(num),
% <num> is the subjects code (101-118).
%
% Length of the coreg files
% 101 rp_pavlov.txt 1210
% 102 rp_pavlov.txt 1234
% 103- rp_pavlov.txt 1254

    data_path = fullfile(pwd,cr_subdir(num));

    copyfile(...
        fullfile(data_path, 'rp_pavlov.txt'),fullfile(data_path,'rp_all.txt'));
        %% Move original to rp_all.txt

    rp = load(fullfile(data_path,'rp_pavlov.txt'));

    lpav = 0;
    lcs = 0;
    lA = 0;
    lB = 0;
    if num == 101,
        if size(rp,1) ~= 1210,
            error('the rp_pavlov.txt file is the wrong size');
        end
        % 101 pavlov 229
        % 101 coaster_localizer 229
        % 101 taskA 374
        % 101 taskB 378
        lpav = 229;
        lcs = 229;
        lA = 374;
        lB = 378;
    elseif num == 102,
        if size(rp,1) ~= 1234,
            error('the rp_pavlov.txt file is the wrong size');
        end
        % 102 pavlov 231
        % 102 coaster_localizer 231
        % 102- taskA 384
        % 102- taskB 388
        lpav = 231;
        lcs = 231;
        lA = 384;
        lB = 388;
    elseif num >= 103,
        if size(rp,1) ~= 1254,
            error('the rp_pavlov.txt file is the wrong size');
        end 
        % 103- pavlov 241
        % 103- coaster_localizer 241
        lpav = 241;
        lcs = 241;
        lA = 384;
        lB = 388;
    else,
        error('<num> was invalid');
    end

    pav = rp(1:lpav,:);
    cs = rp(lpav+1:lpav+lcs,:);
    tA = rp(lcs+1:lcs+lA,:);
    tB = rp(lA+1:lA+lB,:);

    % disp(size(pav)); disp(size(cs)); disp(size(tA)); disp(size(tB))
    save(fullfile(data_path,'rp_pavlov.txt'), 'pav', '-ascii');
    save(fullfile(data_path,'rp_coaster_localizer.txt'), 'cs', '-ascii');
    save(fullfile(data_path,'rp_taskA.txt'), 'tA', '-ascii');
    save(fullfile(data_path,'rp_taskB.txt'), 'tB', '-ascii');

end