function cr_L1_batch(),
% A batch function for running L1 scripts for all Ss
    
    sub_codes = [101:106 108:109 111:118]
    for ii=1:numel(sub_codes),
        num = sub_codes(ii)
        cr_L1('spm_task_hrfd',num,'wl',{'taskA','taskB'},{'base','win','lose'},1)
        cr_L1('spm_local_hrfd',num,'wl',{'pavlov','coaster_localizer'},{'base','win','lose'},1)

        % cr_L1_contrast_wl(num,'spm_task')
        % cr_L1_contrast_wl(num,'spm_local')
    end
end