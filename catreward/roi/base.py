""" An (master) roi experiment for the catreward project. """
from roi.base import Roi


class Catreward(Roi):
    """ A Roi analysis class, customized for the catreward project. """

    def __init__(self, TR, roi_name, trials, durations, data):
        Roi.__init__(self, TR, roi_name, trials, durations, data)
    
        self.data['meta']['bold'] = self.roi_name

        self.create_bold(preprocess=True)
        self.create_hrf(function_name='double_gamma')
        

    # -- 
    # Responses
    def model_020(self):
        """ Behavoiral/category responses as separate regressors. """

        data_to_use = ['resp1', 'resp6']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, box=False)
        self.fit(norm='zscore') 


    def model_021(self):
        """ The correct category responses as separate regressors. """

        data_to_use = ['cresp1', 'cresp6']
        self.data['meta']['dm'] = data_to_use

        self.create_dm_param(names=data_to_use, box=False)
        self.fit(norm='zscore')


    # --
    # Reaction times
    def model_03(self):
        """ Reaction times. """

        data_to_use = ['rt']        
        self.data['meta']['dm'] = ["box",] + data_to_use

        self.create_dm_param(names=data_to_use)
        self.fit(norm='zscore')

    
    # --
    # Distances
    def model_040(self):
        """ Outcome parameter distances. """

        data_to_use = ['distance']
        self.data['meta']['dm'] = ["box",] + data_to_use

        self.create_dm_param(names=data_to_use)
        self.fit(norm='zscore')

    
    def model_041(self):
        """ Contra-outcome parameter distances. """

        data_to_use = ['distance_opp']
        self.data['meta']['dm'] = ["box",] + data_to_use

        self.create_dm_param(names=data_to_use)
        self.fit(norm='zscore')


    # --
    # Simlarity metrics
    def model_042(self):
        """ Outcome similarity (exponential). """

        data_to_use = ['exp']
        self.data['meta']['dm'] = ["box",] + data_to_use

        self.create_dm_param(names=data_to_use)
        self.fit(norm='zscore')


    def model_043(self):
        """  Outcome similarity (gaussian). """

        data_to_use = ['gauss']
        self.data['meta']['dm'] = ["box",] + data_to_use

        self.create_dm_param(names=data_to_use)
        self.fit(norm='zscore')


    def model_044(self):
        """ Contra-outcome similarity (exponential). """

        data_to_use = ['exp_opp']
        self.data['meta']['dm'] = ["box",] + data_to_use

        self.create_dm_param(names=data_to_use)
        self.fit(norm='zscore')


    def model_045(self):
        """ Contra-outcome similarity (gaussian). """

        data_to_use = ['gauss_opp']
        self.data['meta']['dm'] = ["box",] + data_to_use

        self.create_dm_param(names=data_to_use)
        self.fit(norm='zscore')


    def model_046(self):
        """ Outcome and contra-outcome similarities (exponential),
        as separate regressors. """

        data_to_use = ['exp', 'exp_opp']
        self.data['meta']['dm'] = ["box",] + data_to_use

        self.create_dm_param(names=data_to_use)
        self.fit(norm='zscore')


    def model_046(self):
        """ Outcome and contra-outcome similarities (gaussian),
        as separate regressors. """

        data_to_use = ['gauss', 'gauss_opp']
        self.data['meta']['dm'] = ["box",] + data_to_use

        self.create_dm_param(names=data_to_use)
        self.fit(norm='zscore')
   

    # --
    # Gains and losses
    def model_050(self):
        """ Gains and losses. """

        data_to_use = ['gl']
        self.data['meta']['dm'] = ["box",] + data_to_use

        self.create_dm_param(names=data_to_use)
        self.fit(norm='zscore')


    def model_051(self):
        """ Gains and losses, diminished by (exponential) similarity. """

        data_to_use = ['gl_exp']
        self.data['meta']['dm'] = ["box",] + data_to_use

        self.create_dm_param(names=data_to_use)
        self.fit(norm='zscore') 


    def model_052(self):
        """ Gains and losses, diminished by (gaussian) similarity. """

        data_to_use = ['gl_gauss']
        self.data['meta']['dm'] = ["box",] + data_to_use

        self.create_dm_param(names=data_to_use)
        self.fit(norm='zscore') 


    # --
    # Accuracy
    def model_060(self):
        """ Behavioral accuracy. """

        data_to_use = ['acc']
        self.data['meta']['dm'] = ["box",] +  data_to_use

        self.create_dm_param(names=data_to_use)
        self.fit(norm='zscore')


    def model_061(self):
        """ Behavioral accuracy, diminished by (exponential) similarity. """

        data_to_use = ['acc_exp']
        self.data['meta']['dm'] = ["box",] +  data_to_use

        self.create_dm_param(names=data_to_use)
        self.fit(norm='zscore')


    def model_062(self):
        """ Behavioral accuracy, diminished by (gaussian) similarity. """

        data_to_use = ['acc_gauss']
        self.data['meta']['dm'] = ["box",] +  data_to_use

        self.create_dm_param(names=data_to_use)
        self.fit(norm='zscore')


    # --
    # RL - normal
    def model_070(self):
        """ RPE - derived from accuracy. """

        data_to_use = ['rpe_acc']
        self.data['meta']['dm'] = ["box",] + data_to_use

        self.create_dm_param(names=data_to_use)
        self.fit(norm='zscore')


    def model_071(self):
        """ Value - derived from accuracy. """

        data_to_use = ['value_acc']
        self.data['meta']['dm'] = ["box",] + data_to_use

        self.create_dm_param(names=data_to_use)
        self.fit(norm='zscore')


    def model_073(self):
        """ RPE - derived from gains and loses. """

        data_to_use = ['rpe_gl']
        self.data['meta']['dm'] = ["box",] + data_to_use

        self.create_dm_param(names=data_to_use)
        self.fit(norm='zscore')


    def model_073(self):
        """ Value - derived from gains and losses. """

        data_to_use = ['value_gl']
        self.data['meta']['dm'] = ["box",] + data_to_use

        self.create_dm_param(names=data_to_use)
        self.fit(norm='zscore')
 

    # --
    # RL - similarity diminished
    # Accuracy
    def model_080(self):
        """ RPE - derived from accuracy diminished by (exponential) 
        similarity. """          

        data_to_use = ['rpe_acc_exp']
        self.data['meta']['dm'] = ["box",] + data_to_use

        self.create_dm_param(names=data_to_use)
        self.fit(norm='zscore')


    def model_081(self):
        """ Value - derived from accuracy diminished by (exponential) 
        similarity. """

        data_to_use = ['value_acc_exp']
        self.data['meta']['dm'] = ["box",] + data_to_use

        self.create_dm_param(names=data_to_use)
        self.fit(norm='zscore')

    
    def model_082(self):
        """ RPE - derived from accuracy diminished by (gaussian) 
        similarity. """          

        data_to_use = ['rpe_acc_gauss']
        self.data['meta']['dm'] = ["box",] + data_to_use

        self.create_dm_param(names=data_to_use)
        self.fit(norm='zscore')


    def model_083(self):
        """ Value - derived from accuracy diminished by (gaussian) 
        similarity. """

        data_to_use = ['value_acc_gauss']
        self.data['meta']['dm'] = ["box",] + data_to_use

        self.create_dm_param(names=data_to_use)
        self.fit(norm='zscore')


    # Gains and losses
    def model_084(self):
        """ RPE - derived from gains and losses diminished by (exponential) 
        similarity. """         

        data_to_use = ['rpe_gl_exp']
        self.data['meta']['dm'] = ["box",] + data_to_use

        self.create_dm_param(names=data_to_use)
        self.fit(norm='zscore')


    def model_085(self):
        """ Value - derived from gains and losses diminished by (exponential) 
        similarity. """

        data_to_use = ['value_gl_exp']
        self.data['meta']['dm'] = ["box",] + data_to_use

        self.create_dm_param(names=data_to_use)
        self.fit(norm='zscore')

    
    def model_086(self):
        """ RPE - derived from gains and losses diminished by (gaussian) 
        similarity. """         

        data_to_use = ['rpe_gl_gauss']
        self.data['meta']['dm'] = ["box",] + data_to_use

        self.create_dm_param(names=data_to_use)
        self.fit(norm='zscore')


    def model_087(self):
        """ Value - derived from gains and losses diminished by (gaussian) 
        similarity. """

        data_to_use = ['value_gl_gauss']
        self.data['meta']['dm'] = ["box",] + data_to_use

        self.create_dm_param(names=data_to_use)
        self.fit(norm='zscore')


