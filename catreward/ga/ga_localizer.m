function [Inp Out] = ga_localizer(),
% This a run file for Kao et al fMRI sequence optimization code.
%
% [Inp Out] = ga_run_trial();
%
% OUT
%  Inp: the intial parameters
%  Out: the final sequence(s) and their F values
%
% For complete details see:
% Kao et al. Multi-objective optimal experimental designs for event-related
% fMRI studies. Neuroimage (2009) vol. 44 (3) pp. 849-56
%
% Key (but not complete) parameters for the categorical_reward optimization
% part 1 (stimuli):
% 
% Inp.nSTYPE = 6;	% The number of stimui, want to max(F_c), 
% 			    	% the unpreidtablility of each stims appearance
%
% Inp.ISI = 3;	% 3 is an slight underestimate (3.5 is the truth) 
% 				% but as ISI is also the jitter unit length
% 				% I want to minimize it.
% 
% Inp.TR = 1.5; % Is approximate, scanning sequence is not yet defined.
% Inp.dT = 1.5; % The greatest value dividing both the ISI and TR
% 
% Inp.nEvents = 6*30 + 90;	% num_stim * num_trial	+ 0.5*num_trial (the last
% 							% term is set so that 50% of ISIs will be 
% 							% baseline; this, in Dale's work was shown to
% 							% maximized power).

% Particularly this code is taken from section 3 of their template, i.e.:
%
% % 3) Finding the best design for multi-objective studies

% ------------ %
% NOTES (EJP):
% - For MO designs you need to numerically approximate max(Fe) and max(Fd)
% see the methods section of Kao *et al* and section 5., below.
%
% - Finally as the Matlab docs suggest functions are faster (i.e. JIT 
% optimized: http://www.mathworks.com/help/techdoc/matlab_prog/f8-784135.html)
% I converted their run script into a function.  If this has any real 
% impact on performance is unclear; I did not check.
% ------------ %

clear;

%***** Assign values to the paramters Inp.xxxxx

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%****  Name of output file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
date = clock;
date = [num2str(date(2))  num2str(date(3))  num2str(date(1)) '-' ...
 	num2str(date(4))  num2str(date(5))];

run_name = 'localizer';
Inp.filename = [num2str(run_name) '_MO_design_' date '.mat']
	% <-- filename for output

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%**** Experimental conditions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Inp.nSTYPE = 2; % The number of stimui, want to max(F_c), 
			    % the unpreidtablility of each stims appearance
Inp.ISI = 3;	% 3 is an slight underestimate (3.5 is the truth) 
				% but as ISI is also the jitter unit length
				% I want to minimize it.
				
Inp.TR = 1.5; % Is approximate, scanning sequence is not yet defined.
Inp.dT = 1.5; % The greatest value dividing both the ISI and TR

Inp.nEvents = 2*30 + 30;	% num_stim * num_trial	+ 0.5*num_trial (the last
							% term is set so that 50% of ISIs will be 
							% baseline; this, in Dale's work was shown to
							% maximized power).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%**** Model Assumptions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. nuisance terms
PolyOrder = 2; % degree of the polynomial drift;
numScan = floor(Inp.nEvents*Inp.ISI/Inp.TR); % number of scans / length of data

Inp.Smat = Polydrift(numScan, PolyOrder); % <-- nuisance term

% 2. whitening matrix
rho = 0.3; % correlation coefficient of AR(1) process
base = [1+rho^2, -1*rho, zeros(1, numScan-2)]; 
V = toeplitz(base);
V(1,1) = 1;
V(end,end) = 1;

Inp.V2 = V; % <-- square of whitening matrix

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%**** criteria of interest
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1. Optimality criterion
Inp.Opt = 0; % <-- 0=A-optimality; 1=D-optimality

% 2. weights for MO-criterion
%Inp.MOweight = [0 0 1 0];	% for setting MaxFe
%Inp.MOweight = [0 1 0 0];  % For settinf MaxFd, see 5. below.
% 						
Inp.MOweight = [0.25 0.375 0.125 0.25]; 
							% For equal weighting use equal fractions.
							% %w_i in the order of [w_c, w_d, w_e, w_f]; 
							% note. w_c and w_f should be zero if there is
							%  only one stimulus type; i.e. Inp.nSTYPE = 1

% 3. basis for the HRF
% Assumed HRF (canonical HRF from SPM2)
% Parameters:                                             default
%	p(1) - delay of response (relative to onset)	    6
%	p(2) - delay of undershoot (relative to onset)      16
%	p(3) - dispersion of response			    1
%	p(4) - dispersion of undershoot			    1
%	p(5) - ratio of response to undershoot		    6
%	p(6) - onset (seconds)				    0
%	p(7) - length of kernel (seconds)		    32

p = [6 16 1 1 6 0 32]; % default parameter values for HRF 
defHRF = spm_hrf(0.1, p);	% SPM HRF sampled at .1 s
defHRF = defHRF / max(defHRF);  % scale to have a max of 1

Inp.basisHRF = defHRF(1:Inp.dT*10:end); % <-- assinging the basis for the HRF

% 4. linear combinations of parameters
Inp.durHRF = 32.0; % <-- duration of the HRF

lagHRF = Inp.nSTYPE*(1+floor(Inp.durHRF/Inp.dT)); 
% length of the HRF paramters times the number of stimulus types

Inp.CX = eye(lagHRF); % <-- linear combinations for h
Inp.CZ = eye(Inp.nSTYPE); % <-- linear combinations for theta

% 5. max(Fe) and Max(Fd)
Inp.MaxFe = 13.9599; %<-- numerical approximation of Max(Fe)
	% 13.9599 from 'set_MaxFe_localizer_MO_design_1102012-1955.mat'
Inp.MaxFd = 43.2201; %<-- numerical approximation of Max(Fd)
	% 43.2201 from 'set_MaxFd_localizer_MO_design_1102012-2120.mat'
	
% % % to get numerical approximation for Max(Fe):
% % %   set Inp.MaxFe = 1; and Inp.MOweight = [0 0 1 0];
% % %   after the search the approximate is in Out.bestOVF
% % % to get numerical approximation for Max(Fd):
% % %   set Inp.MaxFd = 1; and Inp.MOweight = [0 1 0 0];
% % %   after the search the approximate is in Out.bestOVF

% 6. psychological confounds
Inp.cbalR = 3; % <-- order of counterbalancing

% 7. desired stimulus frequency
Inp.stimFREQ = ones(1,Inp.nSTYPE)./Inp.nSTYPE; %<-- desired stimulus frequency
% % % use equal frequency if no preference

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%**** Algorithmic parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Inp.StopRule = 1; % 1=maximal generations; 2=accumulated improvement
Inp.numITR = 10000;
% when StopRule = 1, total number of GA generations for each loop
% when StopRule = 2, check the stopping rule every Inp.numITR generation

Inp.improve = 10^(-7);
% useful only when Inp.StopRule = 2;

Inp.sizeGen = 20; %<-- size of each generation
Inp.qMutate = 0.01; %<-- rate of mutation
Inp.nImmigrant = 4; %<-- number of immigrant

Inp.SaveEvery = 0;
 % save the result every Inp.SaveEvery generations; 
 % 0 = save the result only at the end of the search

Inp.Nonlinear = 0;
 % taking into account the nonlinear effect of BOLD signals
 % 0=assume linearity; 1=incorporating nonlinear effects
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%**** Performing the search
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Out = fMRIMOD(Inp); %% calling the main subroutine
save(Inp.filename, 'Inp', 'Out'); %% save the outcome; 

end