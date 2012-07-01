""" Run an exp.catreward.base.Catreward() univariate Roi experiment, for all 
(listed) rois in the PWD. """
import os

from roi.io import write_hdf
import fmri
from fmri.catreward.roi.exps import base as bclasses
from fmri.catreward.roi.data import (get_durations, get_trials, 
        get_trials_combined, get_behave_data, get_similarity_data,
        get_roi_names)
from fmri.catreward.roi.misc import subdir
from fmri.catreward.rl.data import get_rl_data


def run(num, roi_class_name, trials_name):
    """ For subject <num>, run all models for all ROIs.

    Note: Must be run from the parent folder of all the fMRI datasets."""

    sdir = subdir(num)
    roi_class_path = roi_class_name.split('.')
    txt_classes = ['CatMean', 'Nobox', 'CatMeanFir', 'Subtime']
    if roi_class_name == 'Catreward':
        roi_names = get_roi_names(kind='nii')
    elif roi_class_name in txt_classes:
        roi_names = get_roi_names(kind='txt')
        sdir = os.path.join(sdir, 'bold')
            ## Swich to the bold dir too
    else:
        raise ValueError("Could not find suitable ROI names.")

    # --
    # Get that Ss data and trial information.
    sdata = get_behave_data(num)
    sdata.update(get_similarity_data(num))
    sdata.update(get_rl_data(num))

    durations = get_durations()
    trials = None
    if trials_name == 'get_trials':
        trials = get_trials()
    elif trials_name == 'get_trials_combined':
        trials = get_trials_combined()
    else:
        raise ValueError("trials_name was unkown.")

    # --
    # Go!
    results = []
    for name in roi_names:
        print(name)
        spath = os.path.join(sdir, name)
    
        # Init this roi's models
        Roiclass = getattr(bclasses, roi_class_name)
        roiglm = Roiclass(1.5, spath, trials, durations, sdata)

        # Get, reformat (extract), and store the results.
        # And del it to keep memory reasonable
        results.append(roiglm.run(name))

    return results


def run_all(code, roi_class_name, trials_name):
    """ Run sub() for all subjects, writing each Ss results separately.

    Note: Must be run from the parent folder of all the fMRI datasets."""

    subjects = [101, 102, 103, 104, 105, 106, 108, 109, 111, 112, 113, 114, 
            115, 116, 117, 118]

    all_results = {}
    for sub in subjects:
        print(sub)
        results = run(sub, roi_class_name, trials_name) 

        print('Writing...')
        write_hdf(results, str(sub) + '_' + str(code) + '_roi_result.hdf5')

        del(results)
            ## Stops mem leak?

