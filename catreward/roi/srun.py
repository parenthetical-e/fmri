""" Run an exp.catreward.base.Catreward() univariate Roi experiment, for all 
(listed) rois in the PWD. """
import roi

def main(num):
    """ Does all the work. """

    roi_names = ["wartaskAB_Right Accumbens_str2.nii.gz"]

    # --
    # Get that Ss data and trial information.
    sdata = roi.exps.catreward.misc.get_behave_data(num)
    trials = roi.exps.catreward.misc.get_trials()
    durations = roi.exps.catreward.misc.get_durations()

    # --
    # Convert trials and data to TR time
    trials_tr = roi.timing.dtime(trials, durations, drop=None)
    sdata_tr = {}
    for key, val in sdata.items():
        sdata_tr[key] = roi.timing.dtime(val, durations, drop=None)

    # Go!
    roi_results = []
    for name in roi_names:
        # Init this roi's models
        roiglm = roi.base.Roi(
                TR=1.5, roi_name=name, trials=trials_tr, data=data_tr)

        # Create data for the model
        roiglm.create_bold()
        roiglm.create_hrf()
        roiglm.create_dm()

        # Run the regression
        roiglm.fit()

        # Get, reformat (extract), and store the results.
        roiglm.extract_results()
        roi_results.append(roiglm.results)

    return roi_results
