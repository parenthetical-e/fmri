""" Run an exp.catreward.base.Catreward() univariate Roi experiment, for all 
(listed) rois in the PWD. """
import os

import roi
import rl
from simfMRI.template import Exp
from similarity.category import prototype2d
from fmri.catreward.roi.data import (get_durations, get_trials, 
        get_trials_combined, get_behave_data, get_coaster_means)
from fmri.catreward.rl.data import get_rl_data
from fmri.catreward.roi.misc import subdir


class Simtest(Exp):
    def __init__(self):

        try: Exp.__init__(self)
        except AttributeError: pass
        
        durations = get_durations()
        tmp_trials = get_trials()

        self.TR = 1.5
        self.ISI = 1.5
        self.trials = roi.timing.dtime(tmp_trials, durations, None, 0)

    
    def model_01(self):
        """ BOLD: condition 1 """
        from simfMRI.dm import construct

        # Add some meta data describing the model...
        self.data['meta']['bold'] = 'condition 1'
        self.data['meta']['dm'] = ('baseline', 'condition 1')

        self.create_dm('boxcar', True)
        self.create_bold(self.dm.mean(1), False)

        self.dm = self.normalize_f(self.dm)
        self.bold = self.normalize_f(self.bold)

        self.fit()
    

def sim():
    """ Test by simulation. """

    # --
    # Get that Ss data and trial information.
    trials = get_trials()
    durations = get_durations()
    sdata = None

    sim = Simtest().run('1')

    roiglm = roi.base.Roi(1.5, '', trials, durations, sdata)

    # Create data for the model
    roiglm.bold = sim['model_01']['bold']
    roiglm.create_hrf('mean_fir', {'window_size':30})
#    roiglm.create_hrf('double_gamma')
    roiglm.create_dm()

    # Get, reformat (extract), and store the results.
    return roiglm.run('simulate')

    
def data(num):
    """ Run a single subjects data. """

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
    sdata.update(get_similartiy_data(num))
    sdata.update(get_rl_data(num))

    trials = get_trials_combined()
    durations = get_durations()

    # --
    # Go!
    roi_results = []
    for name in roi_names:
        print(name)
        spath = os.path.join(sdir, name)
    
        # Init this roi's models
        roiglm = roi.exps.catreward.base.Catreward(
                1.5, spath, trials, durations, sdata)
 
        # Get, reformat (extract), and store the results.
        roi_results.append(roiglm.run(name))

    return roi_results
