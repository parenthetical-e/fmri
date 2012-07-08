""" Extract functional data from all Ss for the list of anatomical ROIs """
import os
import roi
from fmri.catreward.roi.misc import subdir


def main(num, ana_roi_names):
    """ For each entry in <ana_roi_names> extract subject <num>'s data. """

    # Remember where we started then
    # Get dir for num, and change to dir
    start_dir = os.getcwd()
    new_dir = subdir(num)

    print("Changing to {0}".format(new_dir))
    os.chdir(new_dir)

    # Join the A/B data
    print("Joining task A and B.")
    func1 = roi.io.read_nifti("wartaskA.nii")
    func2 = roi.io.read_nifti("wartaskB.nii")
    func = roi.pre.join_time(func1, func2)
    
    # Loop over ana_roi_names
    for ana in ana_roi_names:
        print(ana)
        
        # Get the roi mask
        # and apply it to func
        print("Masking.")
        anaroi = roi.atlas.get_roi("HarvardOxford", ana)
        masked_func = roi.pre.mask(func, anaroi) 

        # Store the result
        print("Writing.")
        roi.io.write_nifti(masked_func, 'wartaskAB_' + ana + '.gz')

    os.chdir(start_dir)


if __name__ == "__main__":
    ana_to_use = ["Right Amygdala.nii", "Left Amygdala.nii", 
            "Insular Cortex.nii", "Occipital Pole.nii", 
            "Frontal Orbital Cortex.nii"]

    subjects = [101, 102, 103, 104, 105, 106, 108, 109, 111, 112, 113, 114, 
            115, 116, 117, 118]

    [main(sub, ana_to_use) for sub in subjects]
        
