function cr_L1_contrast_wl_hrfd(num,fname),

    % SPM go!
    spm('Defaults','fMRI');
    spm_jobman('initcfg'); 
        %% SPM8 only
    
    clear jobs
    
    old_path = pwd;
    data_path = cr_subdir(num);
    data_path = fullfile(pwd,data_path);

    jobs{1}.util{1}.cdir.directory = cellstr(data_path);
        %% set wd   

    jobs{1}.util{1}.md.basedir = cellstr(data_path);

    % INFERENCE
    jobs{2}.stats{1}.con.spmmat = cellstr(...
        fullfile(data_path,fname,'SPM.mat'));
    jobs{2}.stats{1}.con.consess{1}.tcon.name = 'gl';
    jobs{2}.stats{1}.con.consess{1}.tcon.convec = [0 0 0, 1 1 1, 1 1 1];
    jobs{2}.stats{1}.con.consess{1}.tcon.sessrep = 'replsc';

    jobs{2}.stats{1}.con.consess{2}.tcon.name = 'g';
    jobs{2}.stats{1}.con.consess{2}.tcon.convec = [0 0 0, 1 1 1, 0 0 0];
    jobs{2}.stats{1}.con.consess{2}.tcon.sessrep = 'replsc';

    jobs{2}.stats{1}.con.consess{3}.tcon.name = 'l';
    jobs{2}.stats{1}.con.consess{3}.tcon.convec = [0 0 0, 0 0 0, 1 1 1];
    jobs{2}.stats{1}.con.consess{3}.tcon.sessrep = 'replsc';

    jobs{2}.stats{1}.con.consess{4}.tcon.name = 'g-l';
    jobs{2}.stats{1}.con.consess{4}.tcon.convec = [0 0 0, 1 1 1, -1 -1 -1];
    jobs{2}.stats{1}.con.consess{4}.tcon.sessrep = 'replsc';


    jobs{2}.stats{2}.results.spmmat = cellstr(...
        fullfile(data_path,fname,'SPM.mat'));
    jobs{2}.stats{2}.results.conspec.titlestr = 'Contrasts - FWE';
    jobs{2}.stats{2}.results.conspec.contrasts = Inf;
    jobs{2}.stats{2}.results.conspec.threshdesc = 'FWE';
    jobs{2}.stats{2}.results.conspec.thresh = 0.05;
    jobs{2}.stats{2}.results.conspec.extent = 4;
    jobs{2}.stats{2}.results.units = 1;
    jobs{2}.stats{2}.results.print = true;

    jobs{2}.stats{3}.results.spmmat = cellstr(...
        fullfile(data_path,fname,'SPM.mat'));
    jobs{2}.stats{3}.results.conspec.titlestr = 'Contrasts - Uncorr 0.001';
    jobs{2}.stats{3}.results.conspec.contrasts = Inf;
    jobs{2}.stats{3}.results.conspec.threshdesc = 'none';
    jobs{2}.stats{3}.results.conspec.thresh = 0.001;
    jobs{2}.stats{3}.results.conspec.extent = 4;
    jobs{2}.stats{3}.results.units = 1;
    jobs{2}.stats{3}.results.print = true;

    jobs{2}.stats{4}.results.spmmat = cellstr(...
        fullfile(data_path,fname,'SPM.mat'));
    jobs{2}.stats{4}.results.conspec.titlestr = 'Contrasts - Uncorr 0.01';
    jobs{2}.stats{4}.results.conspec.contrasts = Inf;
    jobs{2}.stats{4}.results.conspec.threshdesc = 'none';
    jobs{2}.stats{4}.results.conspec.thresh = 0.01;
    jobs{2}.stats{4}.results.conspec.extent = 4;
    jobs{2}.stats{4}.results.units = 1;
    jobs{2}.stats{4}.results.print = true;

    jobs{3}.util{1}.cdir.directory = cellstr(old_path);
        %% set wd

    spm_jobman('run',jobs);
end