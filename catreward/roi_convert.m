% Run inside the directory containing the *_roi.mat
% files you want to convert to .nii files.
for ii=1:size(files,1), 
    ff = files(ii).name; 
    disp(ff); 
    splt = regexp(ff,'\.','split'); 
    disp(splt(1)); 
    oname = strcat(splt(1), '.nii'); 
    disp(oname); 
    mars_rois2img(ff, oname{1}); 
end
