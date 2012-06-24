""" Routines to get subject <num>'s RL data. """
import os
import pandas

import fmri


def get_rl_params(num, similarity_name, reward_name):
    """ Get RL model parameters (alpha and beta) based on <num>'s data.

    <similarity_name> is the name of the similarity metric you want to 
    use, see fmri.catreward.roi.data.get_similarity_data() for details.
    
    <reward_name> is the name of the data to be used as rewards in the 
    model.  Options are 'acc' ({0,1}, i.e. behavioral accuracy or 
    'gl' ({-1,1}, short for gain/lose) """

    if similarity_name == None:
        similarity_name = 'none'

    table = pandas.read_table(
            os.path.join(fmri.__path__[0],'catreward', 'rl',
                    '101_118_rl_params.txt'), sep=',')
    stable = table[table['sub'] == num]
    stable_r = stable[stable['reward'] == reward_name]
    stable_r_s = stable_r[stable_r['sim'] == similarity_name]
    
    return stable_r_s.ix[:,0:2].values[0].tolist()


def get_rl_data(num):
    """ Get all <num>'s RL data (in a dict). """
    
    reward_names = ['acc', 'gl']
    similarities = [None, 'exp', 'gauss', 'rdis']
    select = ['value', 'rpe', 'sim_reward']
    
    table = pandas.read_table(
            os.path.join(fmri.__path__[0],'catreward', 'rl',
                    '101_118_rl_data.txt'), sep=',')
    stable = table[table['sub'] == num]
    
    rl_data = {}
    for name in reward_names:
        for sim in similarities:
            
            # None is 'none'
            # in 101_118_rl_data.txt
            if sim == None:
                sim = 'none'

            # Filter the data, by name the sim
            stable_r = stable[stable['reward'] == name]
            stable_r_s = stable_r[stable_r['sim'] == sim]
            
            # Generate a key for rl_data
            if sim != 'none':
                key_b = name + '_' + sim
            else:
                key_b = name
            
            # Take the select data from
            # the table and put it into the dict.
            for sel in select:
                if sel != 'sim_reward':
                    key = sel + '_' + key_b
                else:
                    key = key_b

                rl_data[key] = stable_r_s[sel].values

    return rl_data

