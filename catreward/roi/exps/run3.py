""" For Roi set 1 (see runrun.py) I foolished harded coded much of the 
experimental detail in a submodules (i.e. .data and .exps.  For the second 
(see run2.py) and third (this round) I am creating only this top-level script
to run the regressions and extract the scores.  """
import os

from fmri.catreward.roi.data import (get_durations, get_cumrewards,
        get_trials_combined, get_behave_data, get_similarity_data)
from fmri.catreward.roi.misc import subdir
from fmri.catreward.rl.data import get_rl_data
from fmri.catreward.roi.exps import base as bclasses
from roi.io import write_hdf, write_all_scores_as_df


def main(num, roi_names, roi_class_name):
    """ The main worker for run3.py.

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
    sdata.update(get_cumrewards(num))
        ## Add all data to sdata, a dict

    # --
    # The fMRI data is located at:
    sdir = subdir(num)
    
    # --
    results = []
    for name in roi_names:
        print(name)
        spath = os.path.join(sdir, 'bold', name)
    
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
    exp_name = "box_c_run3"
    roi_names = ["wartaskAB_Cingulate Gyrus, anterior division_bold.txt",
            "wartaskAB_Cingulate Gyrus, posterior division_bold.txt",
            "wartaskAB_Cuneal Cortex_bold.txt",
            "wartaskAB_Frontal Medial Cortex_bold.txt",
            "wartaskAB_Left Accumbens_bold.txt",
            "wartaskAB_Left Caudate_bold.txt",
            "wartaskAB_Left Hippocampus_bold.txt",
            "wartaskAB_Left Putamen_bold.txt",
            "wartaskAB_Middle Frontal Gyrus_bold.txt",
            "wartaskAB_Precuneous Cortex_bold.txt",
            "wartaskAB_Right Accumbens_bold.txt",
            "wartaskAB_Right Caudate_bold.txt",
            "wartaskAB_Right Hippocampus_bold.txt",
            "wartaskAB_Right Putamen_bold.txt",
            "wartaskAB_Superior Frontal Gyrus_bold.txt",
            "wartaskAB_Right Amygdala_bold.txt", 
            "wartaskAB_Left Amygdala_bold.txt", 
            "wartaskAB_Insular Cortex_bold.txt", 
            "wartaskAB_Occipital Pole_bold.txt", 
            "wartaskAB_Frontal Orbital Cortex_bold.txt"]
            ## This time do not both with the functional ROI data

    roi_class_name = "CatMean"
    
    #subjects = [101, ] # for debug
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

