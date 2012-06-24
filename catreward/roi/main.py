""" Run an exp.catreward.base.Catreward() univariate Roi experiment, for all 
(listed) rois in the PWD. """
import os

import roi
import fmri
from fmri.catreward.roi.data import (get_durations, get_trials_combined, 
        get_behave_data, get_similarity_data)
from fmri.catreward.rl.data import get_rl_data
from fmri.catreward.roi.misc import subdir


def run(num):
    """ For subject <num>, run all models for all ROIs.

    Note: Must be run from the parent folder of all the fMRI datasets."""

    sdir = subdir(num)
    roi_names = [
            "wartaskAB_Cingulate Gyrus, anterior division_all.nii.gz",
            "wartaskAB_Cingulate Gyrus, anterior division.nii.gz",
            "wartaskAB_Cingulate Gyrus, posterior division_all.nii.gz",
            "wartaskAB_Cingulate Gyrus, posterior division.nii.gz",
            "wartaskAB_Cuneal Cortex_all.nii.gz",
            "wartaskAB_Cuneal Cortex.nii.gz",
            "wartaskAB_Frontal Medial Cortex_all.nii.gz",
            "wartaskAB_Frontal Medial Cortex.nii.gz",
            "wartaskAB_Left Accumbens_str1.nii.gz",
            "wartaskAB_Left Accumbens_strL4.nii.gz",
            "wartaskAB_Left Accumbens_strL5.nii.gz",
            "wartaskAB_Left Accumbens.nii.gz",
            "wartaskAB_Left Caudate_str1.nii.gz",
            "wartaskAB_Left Caudate_strL4.nii.gz",
            "wartaskAB_Left Caudate_strL5.nii.gz",
            "wartaskAB_Left Caudate.nii.gz",
            "wartaskAB_Left Hippocampus_all.nii.gz",
            "wartaskAB_Left Hippocampus.nii.gz",
            "wartaskAB_Left Putamen_str1.nii.gz",
            "wartaskAB_Left Putamen_strL4.nii.gz",
            "wartaskAB_Left Putamen_strL5.nii.gz",
            "wartaskAB_Left Putamen.nii.gz",
            "wartaskAB_Middle Frontal Gyrus_fron2.nii.gz",
            "wartaskAB_Middle Frontal Gyrus_fron4.nii.gz",
            "wartaskAB_Middle Frontal Gyrus.nii.gz",
            "wartaskAB_Precuneous Cortex_all.nii.gz",
            "wartaskAB_Precuneous Cortex.nii.gz",
            "wartaskAB_Right Accumbens_str2.nii.gz",
            "wartaskAB_Right Accumbens_strL6.nii.gz",
            "wartaskAB_Right Accumbens_strL7.nii.gz",
            "wartaskAB_Right Accumbens.nii.gz",
            "wartaskAB_Right Caudate_str2.nii.gz",
            "wartaskAB_Right Caudate_strL6.nii.gz",
            "wartaskAB_Right Caudate.nii.gz",
            "wartaskAB_Right Hippocampus_all.nii.gz",
            "wartaskAB_Right Hippocampus.nii.gz",
            "wartaskAB_Right Putamen_str2.nii.gz",
            "wartaskAB_Right Putamen_strL6.nii.gz",
            "wartaskAB_Right Putamen_strL7.nii.gz",
            "wartaskAB_Right Putamen.nii.gz",
            "wartaskAB_Superior Frontal Gyrus_all.nii.gz",
            "wartaskAB_Superior Frontal Gyrus_fron1.nii.gz",
            "wartaskAB_Superior Frontal Gyrus_fron2.nii.gz",
            "wartaskAB_Superior Frontal Gyrus_fron3.nii.gz",
            "wartaskAB_Superior Frontal Gyrus_fron4.nii.gz",
            "wartaskAB_Superior Frontal Gyrus.nii.gz"]

    # --
    # Get that Ss data and trial information.
    sdata = get_behave_data(num)
    sdata.update(get_similarity_data(num))
    sdata.update(get_rl_data(num))
    
    trials = get_trials_combined()
    durations = get_durations()

    # --
    # Go!
    results = []
    for name in roi_names:
        print(name)
        spath = os.path.join(sdir, name)
    
        # Init this roi's models
        roiglm = fmri.catreward.roi.base.Catreward(
                1.5, spath, trials, durations, sdata)
        
        # Get, reformat (extract), and store the results.
        results.append(roiglm.run(name))

    return results


def run_all(write=True):
    """ Run sub() for all subjects.  If <write> each as a seperate hdf5 file.

    Note: Must be run from the parent folder of all the fMRI datasets."""

    subjects = [101, 102, 103, 104, 105, 106, 108, 109, 111, 112, 113, 114, 
            115, 116, 117, 118]

    all_results = {}
    for sub in subjects:
        print(sub)
        results = run(sub)
        all_results[sub] = results

        if write:
            print('Writing...')
            roi.io.write_hdf(results, str(sub) + '_roi_result.hdf5')
        
    return all_results

