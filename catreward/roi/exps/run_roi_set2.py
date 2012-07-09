""" For Roi set 1 (see runrun.py) I foolished harded coded much of the 
experimental detail in a submodules (i.e. .data and .exps.  For the second 
round of ROIs I am creating only this top-level script to run the regressions
and extract the scores.  """
import os

from fmri.catreward.roi.data import (get_durations, 
        get_trials_combined, get_behave_data, get_similarity_data)
from fmri.catreward.roi.misc import subdir
from fmri.catreward.rl.data import get_rl_data
from fmri.catreward.roi.exps import base as bclasses
from roi.io import write_hdf, write_all_scores_as_df


def main(num, roi_names, roi_class_name):
    """ The main worker for roi_set2 'box_c' style regression analysis.

    <num> is a valid subject number code (101-118)
    <roi_names> is the names of the rois you wish to analyze
    <roi_class_name> is the name of the fmri.catreward.roi.exps.base 
    class you want to use for the experiment. 
    
    This script saves each Ss data to seperate files, returning nothing. """

    # --
    # Get that Ss data and trial information.
    trials = get_trials_combined()
    durations = get_durations()

    sdata = get_behave_data(num)
    sdata.update(get_similarity_data(num))
    sdata.update(get_rl_data(num))

    # --
    # The fMRI data is located at:
    sdir = subdir(num)
    
    # --
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


if __name__ == "__main__":

    # --
    # Experimental variables
    exp_name = "box_c_roi_set2"
    roi_names = ["wartaskAB_Right Amygdala.nii.gz", 
            "wartaskAB_Left Amygdala.nii.gz", 
            "wartaskAB_Insular Cortex.nii.gz", 
            "wartaskAB_Occipital Pole.nii.gz", 
            "wartaskAB_Frontal Orbital Cortex.nii.gz"]
    roi_class_name = "Catreward"
    subjects = [101, 102, 103, 104, 105, 106, 108, 109, 111, 112, 113, 114, 
            115, 116, 117, 118]

    # -- 
    # Loop over subjects
    for sub in subjects:
        # main() does all the work, then write results
        print(sub)
        sub_results = main(sub, roi_names, roi_class_name)

        print('Writing results.')  ## into a hdf5
        results_name = str(sub) + '_' + exp_name + '_roi_result.hdf5'
        write_hdf(sub_results, results_name)
        del(sub_results)

        # Now extract the scores from the results 
        # hdf5 file into something that can be easily
        # read into R for analyis.
        print("Getting and saving scores.")
        write_all_scores_as_df(results_name, str(sub) + exp_name)

