""" Another (sub)set of models, this one contains only those with literature
driven RL (or related) terms.  Prior analyses were more exploratory.  

In this set we allow for seperate regressors matching behavoiral accuracy,
as well as inverted and positive-value-only coding schemes. """
from roi.base import Mean

class Rewardrecode(Mean):
    """ A Roi analysis class, customized for the catreward project. 
    
    Unlike Catreward, this reads in the average bold data from a 
    text file. """

    def __init__(self, TR, roi_name, trials, durations, data):
        Mean.__init__(self, TR, roi_name, trials, durations, data)
    
        self.data['meta']['bold'] = self.roi_name

        self.create_bold(preprocess=True)
        self.create_hrf(function_name='double_gamma')


    # --
    # Accuracy
    def model_0101(self):
        """ Behavioral accuracy. """

        data_to_use = ['acc']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    def model_0102(self):
        """ Behavioral accuracy, diminished by (exponential) similarity. """

        data_to_use = ['acc_exp']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    def model_0103(self):
        """ Behavioral accuracy, diminished by (gaussian) similarity. """

        data_to_use = ['acc_gauss']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    # --
    # Gains and losses
    def model_0201(self):
        """ Gains and losses. """

        data_to_use = ['gl']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    def model_0202(self):
        """ Gains and losses, diminished by (exponential) similarity. """

        data_to_use = ['gl_exp']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore') 


    def model_0203(self):
        """ Gains and losses, diminished by (gaussian) similarity. """

        data_to_use = ['gl_gauss']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore') 

    # -- 
    # g/l into 2 regressors
    def model_0301(self):
        """ Gains and losses, in 2 regressors. """

        data_to_use = ['gl_1', 'gl_0']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    def model_0302(self):
        """ Gains and losses, diminished by (exponential) similarity,
        in 2 regressors. """

        data_to_use = ['gl_exp_1', 'gl_exp_0']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore') 


    def model_0303(self):
        """ Gains and losses, diminished by (gaussian) similarity,
        in 2 regressors. """

        data_to_use = ['gl_gauss_1', 'gl_gauss_0']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    # --
    # Acc coding
    # RPE
    def model_0401(self):
        """ RPE - derived from accuracy. """

        data_to_use = ['rpe_acc']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    def model_0402(self):
        """ RPE - derived from accuracy diminished by (exponential) 
        similarity. """          

        data_to_use = ['rpe_acc_exp']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')

    def model_0403(self):
        """ RPE - derived from accuracy diminished by (gaussian) 
        similarity. """          

        data_to_use = ['rpe_acc_gauss']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    # --
    # Acc coding
    ## VALUE
    def model_0501(self):
        """ Value - derived from accuracy. """

        data_to_use = ['value_acc']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')

    def model_0502(self):
        """ Value - derived from accuracy diminished by (exponential) 
        similarity. """          

        data_to_use = ['value_acc_exp']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')

    def model_0503(self):
        """ Value - derived from accuracy diminished by (gaussian) 
        similarity. """          

        data_to_use = ['value_acc_gauss']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')

    # --
    # g/l coding
    ## RPE
    def model_0701(self):
        """ RPE - derived from gains and loses. """

        data_to_use = ['rpe_gl']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    def model_0702(self):
        """ RPE - derived from gains and losses diminished by (exponential) 
        similarity. """         

        data_to_use = ['rpe_gl_exp']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    def model_0703(self):
        """ RPE - derived from gains and losses diminished by (gaussian) 
        similarity. """         

        data_to_use = ['rpe_gl_gauss']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    # --
    # g/l coding
    ## VALUE 
    def model_0801(self):
        """ Value - derived from gains and losses. """

        data_to_use = ['value_gl']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')

    def model_0802(self):
        """ Value - derived from gains and losses diminished by (exponential) 
        similarity. """

        data_to_use = ['value_gl_exp']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')  
    
    def model_0803(self):
        """ Value - derived from gains and losses diminished by (gaussian) 
        similarity. """

        data_to_use = ['value_gl_gauss']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    # --
    # g/l coding, into 2 regressors
    ## RPE
    def model_0901(self):
        """ RPE - derived from gains and loses. """

        data_to_use = ['rpe_gl_1', 'rpe_gl_0']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')

    def model_0902(self):
        """ RPE - derived from gains and losses diminished by (exponential) 
        similarity. """         

        data_to_use = ['rpe_gl_exp_1', 'rpe_gl_exp_0']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')

    def model_0903(self):
        """ RPE - derived from gains and losses diminished by (gaussian) 
        similarity. """         

        data_to_use = ['rpe_gl_gauss_1', 'rpe_gl_gauss_0']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    # --
    # g/l coding, into 2 regressors
    ## VALUE
    def model_1001(self):
        """ Value - derived from gains and losses. """

        data_to_use = ['value_gl_1', 'value_gl_0']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')

    def model_1002(self):
        """ Value - derived from gains and losses diminished by (exponential) 
        similarity. """

        data_to_use = ['value_gl_exp_1', 'value_gl_exp_0']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')  
    
    def model_1003(self):
        """ Value - derived from gains and losses diminished by (gaussian) 
        similarity. """

        data_to_use = ['value_gl_gauss_1', 'value_gl_gauss_0']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')

    # --
    # INVERTED VALUES
    # --
    # Gains and losses INVERTED
    def model_1101(self):
        """ Gains and losses.  Reward coding inversed. """

        data_to_use = ['gl_invert']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    def model_1102(self):
        """ Gains and losses, diminished by (exponential) similarity.
        Reward coding inversed. """

        data_to_use = ['gl_exp_invert']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore') 


    def model_1103(self):
        """ Gains and losses, diminished by (gaussian) similarity. 
        Reward coding inversed. """

        data_to_use = ['gl_gauss_invert']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore') 

    # -- 
    # g/l into 2 regressors INVERTED
    def model_1201(self):
        """ Gains and losses, in 2 regressors. 
        Reward coding inversed. """

        data_to_use = ['gl_invert_1', 'gl_invert_0']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    def model_1202(self):
        """ Gains and losses, diminished by (exponential) similarity,
        in 2 regressors. Reward coding inversed. """

        data_to_use = ['gl_exp_invert_1', 'gl_exp_invert_0']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore') 


    def model_1203(self):
        """ Gains and losses, diminished by (gaussian) similarity,
        in 2 regressors. Reward coding inversed. """

        data_to_use = ['gl_gauss_invert_1', 'gl_gauss_invert_0']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')

    
    # --
    # Acc coding INVERTED
    # RPE
    def model_1301(self):
        """ RPE - derived from accuracy. Reward coding inversed."""

        data_to_use = ['rpe_acc_invert']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    def model_1302(self):
        """ RPE - derived from accuracy diminished by (exponential) 
        similarity. Reward coding inversed. """          

        data_to_use = ['rpe_acc_exp_invert']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    def model_1303(self):
        """ RPE - derived from accuracy diminished by (gaussian) 
        similarity. Reward coding inversed. """          

        data_to_use = ['rpe_acc_gauss_invert']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    # --
    # Acc coding
    ## VALUE
    def model_1401(self):
        """ Value - derived from accuracy. Reward coding inversed."""

        data_to_use = ['value_acc_invert']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    def model_1402(self):
        """ Value - derived from accuracy diminished by (exponential) 
        similarity.  Reward coding inversed. """          

        data_to_use = ['value_acc_exp_invert']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    def model_1403(self):
        """ Value - derived from accuracy diminished by (gaussian) 
        similarity. Reward coding inversed. """          

        data_to_use = ['value_acc_gauss_invert']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    # --
    # g/l coding
    ## RPE
    def model_1601(self):
        """ RPE - derived from gains and loses. Reward coding inversed. """

        data_to_use = ['rpe_gl_invert']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    def model_1602(self):
        """ RPE - derived from gains and losses diminished by (exponential) 
        similarity. Reward coding inversed. """         

        data_to_use = ['rpe_gl_exp_invert']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    def model_1603(self):
        """ RPE - derived from gains and losses diminished by (gaussian) 
        similarity. Reward coding inversed. """         

        data_to_use = ['rpe_gl_gauss_invert']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    # --
    # g/l coding
    ## VALUE 
    def model_1701(self):
        """ Value - derived from gains and losses. Reward coding inversed. """

        data_to_use = ['value_gl_invert']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')

    def model_1702(self):
        """ Value - derived from gains and losses diminished by (exponential) 
        similarity. Reward coding inversed. """

        data_to_use = ['value_gl_exp_invert']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')  
    
    def model_1703(self):
        """ Value - derived from gains and losses diminished by (gaussian) 
        similarity. Reward coding inversed. """

        data_to_use = ['value_gl_gauss_invert']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    # --
    # g/l coding, into 2 regressors
    ## RPE
    def model_1801(self):
        """ RPE - derived from gains and loses. Reward coding inversed. """

        data_to_use = ['rpe_gl_invert_1', 'rpe_gl_invert_0']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')

    def model_1802(self):
        """ RPE - derived from gains and losses diminished by (exponential) 
        similarity. Reward coding inversed. """         

        data_to_use = ['rpe_gl_exp_invert_1', 'rpe_gl_exp_invert_0']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')

    def model_1803(self):
        """ RPE - derived from gains and losses diminished by (gaussian) 
        similarity. Reward coding inversed. """         

        data_to_use = ['rpe_gl_gauss_invert_1', 'rpe_gl_gauss_invert_0']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    # --
    # g/l coding, into 2 regressors
    ## VALUE
    def model_1901(self):
        """ Value - derived from gains and losses. Reward coding inversed. """

        data_to_use = ['value_gl_invert_1', 'value_gl_invert_0']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    def model_1902(self):
        """ Value - derived from gains and losses diminished by (exponential) 
        similarity. Reward coding inversed. """

        data_to_use = ['value_gl_exp_invert_1', 'value_gl_exp_invert_0']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')  
   

    def model_1903(self):
        """ Value - derived from gains and losses diminished by (gaussian) 
        similarity. Reward coding inversed. """

        data_to_use = ['value_gl_gauss_invert_1', 'value_gl_gauss_invert_0']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    # POSTIVE CODING
    # --
    # Gains and losses INVERTED
    def model_2001(self):
        """ Gains and losses.  Reward coding was positive only. """

        data_to_use = ['gl_pos']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    def model_2002(self):
        """ Gains and losses, diminished by (exponential) similarity.
        Reward coding was positive only. """

        data_to_use = ['gl_exp_pos']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore') 


    def model_2003(self):
        """ Gains and losses, diminished by (gaussian) similarity. 
        Reward coding was positive only. """

        data_to_use = ['gl_gauss_pos']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore') 

    # -- 
    # g/l into 2 regressors pos only
    def model_2101(self):
        """ Gains and losses, in 2 regressors. 
        Reward coding was positive only. """

        data_to_use = ['gl_pos_1', 'gl_pos_0']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    def model_2102(self):
        """ Gains and losses, diminished by (exponential) similarity,
        in 2 regressors. Reward coding was positive only. """

        data_to_use = ['gl_exp_pos_1', 'gl_exp_pos_0']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore') 


    def model_2103(self):
        """ Gains and losses, diminished by (gaussian) similarity,
        in 2 regressors. Reward coding was positive only. """

        data_to_use = ['gl_gauss_pos_1', 'gl_gauss_pos_0']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')

    
    # --
    # g/l coding
    ## RPE
    def model_2501(self):
        """ RPE - derived from gains and loses. 
        Reward coding was positive only. """

        data_to_use = ['rpe_gl_pos']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    def model_2502(self):
        """ RPE - derived from gains and losses diminished by (exponential) 
        similarity. Reward coding was positive only. """         

        data_to_use = ['rpe_gl_exp_pos']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    def model_2503(self):
        """ RPE - derived from gains and losses diminished by (gaussian) 
        similarity. Reward coding was positive only. """         

        data_to_use = ['rpe_gl_gauss_pos']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    # --
    # g/l coding
    ## VALUE 
    def model_2601(self):
        """ Value - derived from gains and losses. 
        Reward coding was positive only. """

        data_to_use = ['value_gl_pos']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    def model_2602(self):
        """ Value - derived from gains and losses diminished by (exponential) 
        similarity. Reward coding was positive only. """

        data_to_use = ['value_gl_exp_pos']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')  
    

    def model_2603(self):
        """ Value - derived from gains and losses diminished by (gaussian) 
        similarity. Reward coding was positive only. """

        data_to_use = ['value_gl_gauss_pos']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    # --
    # g/l coding, into 2 regressors
    ## RPE
    def model_2701(self):
        """ RPE - derived from gains and loses. 
        Reward coding was positive only. """

        data_to_use = ['rpe_gl_pos_1', 'rpe_gl_pos_0']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    def model_2702(self):
        """ RPE - derived from gains and losses diminished by (exponential) 
        similarity. Reward coding was positive only. """         

        data_to_use = ['rpe_gl_exp_pos_1', 'rpe_gl_exp_pos_0']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    def model_2703(self):
        """ RPE - derived from gains and losses diminished by (gaussian) 
        similarity. Reward coding was positive only. """         

        data_to_use = ['rpe_gl_gauss_pos_1', 'rpe_gl_gauss_pos_0']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    # --
    # g/l coding, into 2 regressors
    ## VALUE
    def model_2801(self):
        """ Value - derived from gains and losses. 
        Reward coding was positive only. """

        data_to_use = ['value_gl_pos_1', 'value_gl_pos_0']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    def model_2802(self):
        """ Value - derived from gains and losses diminished by (exponential) 
        similarity. Reward coding was positive only. """

        data_to_use = ['value_gl_exp_pos_1', 'value_gl_exp_pos_0']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')  
   

    def model_2803(self):
        """ Value - derived from gains and losses diminished by (gaussian) 
        similarity. Reward coding was positive only. """

        data_to_use = ['value_gl_gauss_pos_1', 'value_gl_gauss_pos_0']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    # --
    # CONTROL MODELS
    def model_29(self):
        """  Outcome similarity (exponential). """

        data_to_use = ['exp']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    def model_30(self):
        """ Outcome similarity (gaussian). """

        data_to_use = ['gauss']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore') 


    def model_31(self):
        """ Behavoiral/category responses as separate regressors. """

        data_to_use = ['resp1', 'resp6']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    def model_32(self):
        """ Outcome and contra-outcome similarities (exponential),
        as separate regressors. """

        data_to_use = ['exp', 'exp_opp']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    def model_33(self):
        """ Outcome and contra-outcome similarities (gaussian),
        as separate regressors. """

        data_to_use = ['gauss', 'gauss_opp']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    def model_34(self):
        """ Gabor angle parameter. """

        data_to_use = ['angle']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')


    def model_35(self):
        """ Gabor width parameter. """

        data_to_use = ['width']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, orth=False, box=False)
        self.fit(norm='zscore')
