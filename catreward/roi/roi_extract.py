#! /usr/local/bin/python
""" Extracts task A and B functional data from the PWD. """
import re
import roi

def main():
    """ It does everything, mostly. """
    
    # Set up needed data structures...
    # i.e. the file names of data and roi
    
    # --
    # LOCALIZER ROIs:
    # These files must be placed in 
    # $roi.__path__/atlases/Custom/
    frontal_roi = [
            "all.nii",
            "fron1.nii",
            "fron2.nii",
            "fron3.nii",
            "fron4.nii"]

    cing_roi = ["all.nii"]

    str_roi = [
            "str1.nii",
            "str2.nii",
            "strL4.nii",
            "strL5.nii",
            "strL6.nii",
            "strL7.nii"]

    hipp_roi = ["all.nii"]
        # All are rois from the localizer
        # grouped so not all anatomical rois
        # must be compared to all localizer
        # derived rois

    # --
    # Create a dict keys of the anatomical
    # with values matching localizer rois
    # to be used in stage 2.
    ana_to_local_map = {
        #"Frontal Orbital Cortex.nii":frontal_roi, # None found
        "Frontal Medial Cortex.nii":cing_roi,
        "Middle Frontal Gyrus.nii":frontal_roi, 
        "Superior Frontal Gyrus.nii":frontal_roi, 
        "Cingulate Gyrus, posterior division.nii":cing_roi,
        "Cingulate Gyrus, anterior division.nii":cing_roi,
        "Cuneal Cortex.nii":cing_roi,
        "Precuneous Cortex.nii":cing_roi,
        "Right Putamen.nii":str_roi,
        "Left Putamen.nii":str_roi,
        "Right Caudate.nii":str_roi,
        "Left Caudate.nii":str_roi,
        "Right Accumbens.nii":str_roi,
        "Left Accumbens.nii":str_roi,
        "Left Hippocampus.nii":hipp_roi,
        "Right Hippocampus.nii":hipp_roi}
            ## anatomical roi are from the HarvardOxford atlas
            ## and we assume that both
            ## roi.atlas.create_rois(
            ## 'HarvardOxford', 
            ## 'HarvardOxford-cort-maxprob-thr50-1mm.nii.gz',
            ## 'HarvardOxford-Cortical.txt')
            ## and 
            ## roi.atlas.create_rois(
            ## 'HarvardOxford',
            ## 'HarvardOxford-sub-maxprob-thr50-1mm.nii.gz',
            ## 'HarvardOxford-Subcortical.txt')
            ## were run already.

    # --
    # fMRI data:
    print("Reading in task A and B.")
    func1 = roi.io.read_nifti("wartaskA.nii") 
    func2 = roi.io.read_nifti("wartaskB.nii")
    func = roi.pre.join_time(func1, func2)

    for ana, local_list in ana_to_local_map.items():
        print(ana)

        # Stage 1. Load the anatomical 
        # roi and filter func by it
        ana_roi = roi.atlas.get_roi("HarvardOxford", ana)
        func_ana = roi.pre.mask(func, ana_roi) 
            ## a nibabel nifti object

        print("Writing...")
        roi.io.write_nifti(func_ana, 'wartaskAB_' + ana + '.gz')

        for loc in local_list: 
            print('\t' + loc)

            # Stage 2. Now filter with loc
            loc_roi = roi.atlas.get_roi("Custom", loc)
            func_ana_loc = roi.pre.mask(func_ana, loc_roi)

            if roi.pre.num_active_voxels(func_ana_loc) < 6:
                print("\tSkipping...")
            else:
                print("\tWriting....")
                fname = 'wartaskAB_' + re.split('\.', ana)[0] + '_' + loc + '.gz'
                    ## the re.split gets everything 
                    ## before the extension,
                    ## which is then cat'ed with loc
            
                roi.io.write_nifti(func_ana_loc, fname)


if __name__ == "__main__":
    main()

