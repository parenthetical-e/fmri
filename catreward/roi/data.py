""" Routines to get subject <num>'s data. """
import os
import pandas
import numpy as np

import fmri
import roi
from similarity.category import prototype2d

def get_trials():
    """ Return trials for taskA and B (combined) in trial-time 
    (equivilant to 3 TRs). """
    
    return [1,1,4,4,6,0,4,2,4,1,0,0,0,0,5,4,5,1,5,5,3,6,6,0,0,2,2,3,
            3,1,3,2,4,2,2,6,0,5,3,1,2,2,0,4,3,0,0,6,5,6,6,5,1,0,0,
            5,5,2,2,6,2,0,0,0,6,6,5,0,0,0,0,4,6,4,5,6,4,0,0,0,0,3,3,
            4,2,5,5,1,0,3,3,1,1,0,6,1,5,3,3,0,4,6,0,0,0,1,2,2,0,5,0,
            4,4,4,3,3,2,0,1,0,0,0,4,4,0,0,2,1,6,6,2,4,4,1,1,1,5,4,0,6,
            0,3,3,5,5,4,2,1,1,1,6,1,1,0,2,0,0,6,5,6,0,3,4,3,3,6,4,0,6,6,
            6,1,1,3,6,3,0,5,5,3,0,0,0,2,2,2,3,2,6,3,5,5,0,1,0,2,5,2,4,1,
            4,4,4,0,5,5,6,0,3,4,0,5,0,0,6,1,3,5,0,3,0,0,1,6,3,0,2,2,0,5,
            5,2,5,0,1,4,1,2,0,0,3,0,0,1,3,2,1,4,0,3,5,0,0,4,0,5,2,6,
            6,2,1,6,0,2,3,3,6,4,4,2]


def get_durations():
    """ Get the trial durations for  taskA and B (combined) in TRs 
    (i.e. 1.5 second increments)."""

    trials = get_trials()
    durations = []
    for trial in trials:
        if trial == 0:
            durations.append(2)
        else:
            durations.append(3)

    return durations


def get_trials_combined():
    """ Return trials for taskA and B (combined) collapsed across 
    category stimuli, and in trial-time (equivilant to 3 TRs). """

    trials = np.array(get_trials())
    trials[trials > 0] = 1

    return trials.tolist()


def get_coaster_means(num):
    """ Return the coaster parameters mean (M) values for subject <num>
    in the following order:

    [angleM_gain, widthM_gain, angleM_lose, widthM_lose] """

    # Use pandas Dataframe to
    # isolate <num> data, then...
    table = pandas.read_table(
            os.path.join(fmri.__path__[0],'catreward', 'roi',
                    '101_118_coaster_stats.txt'), sep=',')
    stable = table[table['sub'] == num]

    means = []
    for cond in ['g', 'l']:
        row = stable[stable['gl'] == cond]
        angleM = row.ix[:,0].values / 110.
        widthM = row.ix[:,2].values / 100.
            ## width mean is col 0, angle mean is col 2
            ## Also strip off the pandas junk (.values.tolist()), 
            ## just want the values
            ## Also rescale means based on max values 
            ## Max - Width: 100, Angle: 110

        means.extend((angleM.tolist() + widthM.tolist()))
  
    return means


def normalize_coaster_params(data):
    """ Normalize (0-1, inclusive) coaster parameters in <data>. """

    # Normalize (0-1) angle and width params
    # simplyfying similarity calculations
    nangle = np.array(data['angle']) / 100.
    nwidth = np.array(data['width']) / 110.
        ## Max angle 100, max width = 110

    data['angle'] = nangle.tolist()
    data['width'] = nwidth.tolist()
 
    return data

    
def get_behave_data(num):
    """ In a dict, get and return the behavioral data for subject 
    <num>ber.  
    
    Note: Jitter is inserted as 0 or '0' based on get_trials(). """
    
    # Use pandas Dataframe to
    # isolate <num> data, then...
    table = pandas.read_table(
            os.path.join(fmri.__path__[0],'catreward', 'roi',
                    '101-118_regression_NA_AsZero.txt'))
    stable = table[table['sub'] == num]

    # Insert jitter times and
    # convert to a dict.
    trials = get_trials_combined()
    data = {}
    for colname, series in stable.iteritems():
        ldata = series.tolist()
        withjitt = roi.timing.add_empty(ldata, trials)
        data.update({colname:withjitt})

    data = normalize_coaster_params(data)

    return data


def get_similarity_data(num):
    """ Return (in a dict) the similarity measures for subject <num>. """

    behave_data = get_behave_data(num)
    rewards = behave_data['acc']
    angles = behave_data['angle']
    widths = behave_data['width']
        ## Rename for clarity/brevity
    
    # Get distances and similarities (both kinds)
    simil = {'distance':[],
            'distance_opp':[],
            'exp':[],
            'gauss':[],
            'exp_opp':[],
            'gauss_opp':[]}

    # Get caoster means
    angleM_g, widthM_g, angleM_l, widthM_l = get_coaster_means(num)
    
    # Loop over reward and the individual
    # caoster params, calculating adnd saving
    # similarity measures for each.
    for r, a, w in zip(rewards, angles, widths):
        
        # Skip for jitter (when a or w is 0), 
        # filling the appropriate sdata fields with 0
        if (a == 0) or (w == 0):
            [simil[key].append(0) for key in simil.keys()]
            continue

        # Calc similarities and distances for gains
        exp_g, dis_g = prototype2d(a, w, angleM_g, widthM_g, 1)
        gauss_g, dis_g = prototype2d(a, w, angleM_g, widthM_g, 2)

        # then losses.
        exp_l, dis_l = prototype2d(a, w, angleM_l, widthM_l, 1)
        gauss_l, dis_l = prototype2d(a, w, angleM_l, widthM_l, 2)

        # Now update simil based on the
        # current reward (r)
        if r == 1: 
            simil['distance'].append(dis_g)
            simil['exp'].append(exp_g)
            simil['gauss'].append(gauss_g)
            
            simil['distance_opp'].append(dis_l)
            simil['exp_opp'].append(exp_l)
            simil['gauss_opp'].append(gauss_l)
        elif r == 0:
            simil['distance'].append(dis_l)
            simil['exp'].append(exp_l)
            simil['gauss'].append(gauss_l)
            
            simil['distance_opp'].append(dis_g)
            simil['exp_opp'].append(exp_g)
            simil['gauss_opp'].append(gauss_g)

    return simil


