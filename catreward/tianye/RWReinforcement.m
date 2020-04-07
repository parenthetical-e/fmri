%% Rescorla-Wagner Reinforcement Learning Model
%
% Define the Rescorla-Wagner reinforcement model
% ------------
% Output=RWReinforcement(param, Data, Input)
%
% ## Theory ##
% This model assumed that the reward representation is updated
% according to the reward prediction error of each trial. And the
% actual response follows a logistic choice rule.
%
% ## Input ##
% check the manual for details (BMW('manual'))
%
% - param
% alpha, beta, (drift)
%
% - Data
% Data.distance (geometric distance to the mean stimulus), Data.r (reward value)
% Data.category (correct responses), Data.choice (actual responses)
%
% - Input
% Input.Variant
%   options of model variants
%       Input.Variants.Reward, 1/2/3 no/linear/gaussian reward modulation
%       Input.Variants.Drift, 0/1 to decide whether use the drift of learning rate
% Input.Output
%   string, choose output mode
%       'Prior', only output prior density
%       'LLH', output log likelihood
%       'LP', output log posterior density
% Input.PDF
%   0/1, output pdf or not. default as 0
%   Valid only when Input.Output=='LLH'
%
% ## Output ##
% Output is conditional to Input.Output & Input.PDF
%
% ## References ##
% - Rescorla, R. A., & Wagner, A. R. (1972). "A theory of Pavlovian conditioning: 
% Variations in the effectiveness of reinforcement and nonreinforcement." 
% Classical conditioning II: Current research and theory, 2, 64-99.
%
% ------------
% Programmed by Ma, Tianye
% 4/6/2020
%
% Bug reports or any other feedbacks please contact M.T. (mack_ma2018@outlook.com)
% BMW toolbox: https://github.com/Mack-Ma/Bayesian_Modeling_of_Working_Memory
%


function Output=RWReinforcement(param,Data,Input)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%              ADAPTATION NEEDED              %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Specify parameters
alpha=param(1); % (Initial) Learning rate
beta=param(2); % Inverse temperature parameter
if ~isfield(Input,'Variants') % No Variants
    Input.Variants.Reward=1;
end
switch Input.Variants.Reward
    case 1
        RewardCoef=-Inf;
    case 2
        RewardCoef=1;
    case 3
        RewardCoef=2;
end
if Input.Variants.Drift==1
    drift=param(3);
else
    drift=0;
end

% Configuration
distance=Data.distance;
r=Data.r;
cat=Data.category;
Ncat=length(unique(cat));
act=Data.choice;
Nact=length(unique(act));
Ntrial=length(r);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%                   DO NOT MODIFY                %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(Input.Output,'LP') || strcmp(Input.Output,'Prior')  || strcmp(Input.Output,'All')
    Prior=prior(param, Input); % get prior
elseif strcmp(Input.Output,'LLH') || strcmp(Input.Output,'LPPD')
    Prior=1; % uniform prior
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%              ADAPTATION NEEDED              %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~strcmp(Input.Output,'Prior')
    % LH function
    % set up initial matrix
    ValueRep=zeros(Nact,Ncat); % value representation
    p_LH=zeros(1,Ntrial); % likelihood for each trial
    for i=1:Ntrial
        % logistic choice rule
        p_LH(i)=1/sum(exp(beta*(ValueRep(:,cat(i))-ValueRep(act(i),cat(i)))));
        % update representations
        R=r*exp(distance(i)^RewardCoef); % reward representation
        delta=(alpha*drift^(i-1))*R; % multiplied by the learning rate
        ValueRep(act(i),cat(i))=ValueRep(act(i),cat(i))+delta; % update
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%                   DO NOT MODIFY                %%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % LLH
    if isfield(Input,'PDF') && Input.PDF==1
        LLH.error=p_error; % PDF
    else
        LLH=-sum(log(p_LH)); % Negative LLH
    end
    
    % Posterior
    LP=-log(Prior)+LLH; % likelihood*prior
    
end

% Decide output
if strcmp(Input.Output,'LP')
    Output=LP;
elseif strcmp(Input.Output,'LLH')
    Output=LLH;
elseif strcmp(Input.Output,'Prior')
    Output=Prior;
elseif strcmp(Input.Output,'LPPD')
    Output=log(p_LH);
elseif strcmp(Input.Output,'All')
    Output.LP=LP;
    Output.LLH=LLH;
    Output.Prior=Prior;
    Output.LPPD=log(p_LH);
end

if ~isstruct(Output) && (any(abs(Output)==Inf) || any(isnan(Output)))
    Output=realmax('double'); % Output should be a real value
end

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%              ADAPTATION NEEDED              %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function p=prior(param,Input)
% multivariate-normal-distributed prior
param0=[MCMCConvert_BMW(param(1),1,0,'probit'),param(2)];
mean0=[0,1];
if Input.Variants.Drift==1
    param0=[param0,param(3)];
    mean0=[mean0,0];
end
cov0=ones(1,length(param));
p=mvnpdf(param0,mean0,cov0);
end
