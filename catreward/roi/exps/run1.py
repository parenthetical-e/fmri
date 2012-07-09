#! /usr/local/bin

import fmri
# --
# Gen the data
# Run 1
#fmri.catreward.roi.exps.main.run_all('box_c', 'CatMean', 'get_trials_combined')
#fmri.catreward.roi.exps.main.run_all('box_s', 'CatMean', 'get_trials')
#fmri.catreward.roi.exps.main.run_all('nobox_c', 'Nobox', 'get_trials_combined')
#fmri.catreward.roi.exps.main.run_all('nobox_s', 'Nobox', 'get_trials')

# Run 2
fmri.catreward.roi.exps.main.run_all('box_s_fir', 'CatMeanFir', 'get_trials')
fmri.catreward.roi.exps.main.run_all('box_c_subtime', 'Subtime', 'get_trials_combined')


# --
# Now extract scores.
import roi
subjects = [101, 102, 103, 104, 105, 106, 108, 109, 111, 112, 113, 114,115, 116, 117, 118]

# R1
#[roi.io.write_all_scores_as_df(str(num) + '_' + 'box_c' + '_roi_result.hdf5', str(num) + '_box_c') for num in subjects]
#[roi.io.write_all_scores_as_df(str(num) + '_' + 'box_s' + '_roi_result.hdf5', str(num) + '_box_s' ) for num in subjects]
#[roi.io.write_all_scores_as_df(str(num) + '_' + 'nobox_c' + '_roi_result.hdf5', str(num) + '_nobox_c') for num in subjects]
#[roi.io.write_all_scores_as_df(str(num) + '_' + 'nobox_s' + '_roi_result.hdf5', str(num) + '_nobox_s') for num in subjects]

# R2
[roi.io.write_all_scores_as_df(str(num) + '_' + 'box_s_fir' + '_roi_result.hdf5', str(num) + '_box_s_fir') for num in subjects]
[roi.io.write_all_scores_as_df(str(num) + '_' + 'box_c_subtime' + '_roi_result.hdf5', str(num) + '_box_c_subtime' ) for num in subjects]

