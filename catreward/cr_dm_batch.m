function cr_dm_batch(),
% A batch file crating dms for all Ss.
    
    sub_codes = [101:106 108:109 111:118]
    for ii=1:numel(sub_codes),
        num = sub_codes(ii)

        cr_dm_localizer_wl(num,'pavlov')
        cr_dm_localizer_wl(num,'coaster_localizer')
        
        cr_dm_task_wl(num,'A')
        cr_dm_task_wl(num,'B')
        
        cr_coreg_split(num)
    end
end
