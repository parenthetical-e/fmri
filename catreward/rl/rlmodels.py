""" For subject <num> run RL models """
import pandas
import numpy as np
from copy import deepcopy

import rl
import fmri
from fmri.catreward.roi.data import (get_trials, 
        get_behave_data, get_similarity_data)
from fmri.catreward.rl.data import get_rl_params

def fit(num, similarity_name=None, reward_name='acc', res=0.05):
    """ Fit <model_name> on <num>'s data, returning first the 
    model fit score (liklihood) and fit parameters - alpha and beta.
    
    <res> is the parameter resolution (0-1).

    For available <model_name>s see rl.fit. """

    # --
    # Get subject's data
    sdata = get_behave_data(num)
    sdata.update(get_similarity_data(num))
    
    responses = np.array(sdata['resp'])

    rewards = None
    if reward_name == 'acc':
        rewards = np.array(sdata['acc'],dtype=np.float32)
    elif reward_name == 'gl':
        rewards = np.array(sdata['gl'],dtype=np.float32)

    trials = np.array(fmri.catreward.roi.data.get_trials())
    conds = list(set(trials))
        ## conds are the uniqu entries in trials
 
    # Each cond has n states, 
    # matching the number of 
    # responses (approx 2: {1,6}).
    #
    # Wrong button presses 
    # are included, however these
    # are never rewarded so stay at 0.
    params = None
    log_L = 0
    for cond in conds:
        print(cond)

        if cond == 0: continue
            ## Drop jitter.

        # Create states and their rewards.
        mask = trials == cond
        states_c = responses[mask]
        rewards_c = rewards[mask]       ## _c for cond...

        # Get the RL alg we want to run.
        # based on similarity_name
        params_c = None
        log_L_c = None
        if similarity_name == None:
            # No similarity, so just fit:
            params_c, log_L_c = rl.fit.ml_delta(rewards_c, states_c, res)
        else:
            # Get the similarity data, filter it by mask, and fit.
            similarity_c = np.array(sdata[similarity_name])[mask]
            params_c, log_L_c = rl.fit.ml_delta_similarity(
                    rewards_c, states_c, similarity_c, res)
        
        # Add cond log_L_c to the overall log_L score
        log_L += log_L_c

        # params is the average for all conds
        if params == None: 
            params = deepcopy(params_c)
        params = (np.array(params_c) + np.array(params)) / 2.
    
    return tuple(params), log_L
            
        
def run(num, similarity_name=None, reward_name='acc', alpha=0.3): 
    """ Run a RL model based on <num>'s data, <similarity_name> is
    the of the similarity metric data you want to use, see 
    fmri.catreward.roi.data.get_similarity_data() for details.
    
    <reward_name> is the name of the data to be used as rewards in the 
    model.  Options are 'acc' ({0,1}, i.e. behavioral accuracy or 
    'gl' ({-1,1}, short for gain/lose).

    Returns:
    -------
    values, rpes, and sim_rewards (as a list) tied to the trial 
    structure returned by fmri.catreward.roi.data.get_trials() """
  
    # --
    # Get subject's data
    sdata = get_behave_data(num)
    sdata.update(get_similarity_data(num))
    
    responses = np.array(sdata['resp'])

    rewards = None
    if reward_name == 'acc':
        rewards = np.array(sdata['acc'],dtype=np.float32)
    elif reward_name == 'gl':
        rewards = np.array(sdata['gl'],dtype=np.float32)

    trials = np.array(fmri.catreward.roi.data.get_trials())
    conds = list(set(trials))
        ## conds are the unqie entries in trials
 
    values = np.zeros_like(trials,dtype=np.float32)
    rpes = np.zeros_like(trials,dtype=np.float32)
    sim_rewards = np.zeros_like(trials,dtype=np.float32)
        ## Returned....

    # Each cond has n states, 
    # matching the number of 
    # responses (approx 2: {1,6}).
    #
    # Wrong button presses 
    # are included, however these
    # are never rewarded so stay at 0.
    for cond in conds:
        if cond == 0: continue
            ## Drop jitter.

        # Create states and their rewards.
        mask = trials == cond
        states_c = responses[mask]
        rewards_c = rewards[mask]       ## _c for cond...

        # Get the RL alg we want to run.
        # based on similarity_name
        if similarity_name == None:
            # No similarity:
            values_c, rpes_c = rl.reinforce.b_delta(
                    rewards_c, states_c, alpha)
            sim_rewards_c = rewards_c
                ## To give a consistent return
                ## just map rewards to sim_rewards
        else:
            # Get the similarity data, filter it by mask, and run RL.
            similarity_c = np.array(sdata[similarity_name])[mask]
            values_c, rpes_c, sim_rewards_c = rl.reinforce.b_delta_similarity(
                    rewards_c, states_c, similarity_c, alpha)
            
            # sim_rewards_c does not need to be
            # unpacked when similarity_name is None
            sim_rewards_c = rl.misc.unpack(sim_rewards_c, states_c)

        # Unpack values and rpes 
        # based on states_c
        values_c = rl.misc.unpack(values_c, states_c)
        rpes_c = rl.misc.unpack(rpes_c, states_c)
        
        # Now use the mask to map values_c, etc,
        # into trials space
        values[mask] = values_c
        rpes[mask] = rpes_c
        sim_rewards[mask] = sim_rewards_c
        
    return values.tolist(), rpes.tolist(), sim_rewards.tolist()


def fit_all(res=0.05, write=False):
    """ Fit all models for all subjects, with a parameter resolution of
    <res>.  If <write>, write the data to csv file. """

    subjects = [101, 102, 103, 104, 105, 106, 108, 109, 111, 112, 113, 114, 
            115, 116, 117, 118]

    fitted = []
    reward_names = ['acc', 'gl']
    similarities = [None, 'exp', 'gauss']
    for num in subjects:
        for name in reward_names:
            for sim in similarities:
                params, log_L = fit(num, sim, name, res)
                fitted.append(
                        params + (log_L, ) + (num, ) + (name, ) + (sim, ))
    
    if write:
        # Ease writing and None substitution
        # with pandas
        ftable = pandas.DataFrame(
                fitted, 
                columns=['alpha', 'beta', 'logL', 'sub','reward', 'sim'])
        ftable.to_csv('101_118_rl_params.txt', 
                header=True, index=False, na_rep='none')

    return fitted


def run_all(write=True):
    """ Run all RL models for all subjects. If <write>, write the data 
    to a csv file. """

    subjects = [101, 102, 103, 104, 105, 106, 108, 109, 111, 112, 113, 114, 
            115, 116, 117, 118]

    reward_names = ['acc', 'gl']
    similarities = [None, 'exp', 'gauss']

    rl_data = []
    for num in subjects:
        for name in reward_names:
            for sim in similarities:
                # Get the parameters the run the rl model:
                stimindex = get_behave_data(num)['stimindex']
                alpha, beta = get_rl_params(num, sim, name)
                vals, rpes, rews = run(num, sim, name, alpha)

                # Save the results, row wise, with metadata.
                for val, rpe, rew, idx in zip(vals, rpes, rews, stimindex):
                    row = (idx, val, rpe, rew, num, name, sim)
                    rl_data.append(row)
    
    if write:
        # Ease writing and None substitution
        # with pandas
        ftable = pandas.DataFrame(
                rl_data, columns=['stimindex', 'value', 'rpe', 'sim_reward', 
                    'sub', 'reward', 'sim'])
        ftable.to_csv('101_118_rl_data.txt', header=True, index=False,
                na_rep='none')
    
    return rl_data
