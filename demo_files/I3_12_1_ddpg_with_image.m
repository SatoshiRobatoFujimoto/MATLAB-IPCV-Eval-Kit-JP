%% �摜���͂�DDPG�G�[�W�F���g�ɂ��U��q�̐U��グ
% ���̗�ł�MATLAB�Ń��f�������ꂽ�U��q��Deep Deterministic Policy Gradient
% (DDPG)�G�[�W�F���g���g���Ăǂ̂悤�Ɋw�K�����邩���Љ�܂��B
% ���s�ɂ�Reinforcement Learning Toolbox��Deep Learning Toolbox���K�v�ł��B

%% ���Ƃ̃C���^�[�t�F�[�X���쐬
% �U�q�̂��߂̎��O��`���ꂽ�����쐬
env = rlPredefinedEnv('SimplePendulumWithImage-Continuous')

%% �ϑ��ƍs���̎d�l�����C���^�[�t�F�[�X����擾�B
obsInfo = getObservationInfo(env);
actInfo = getActionInfo(env);

%% �Č����̂��߂ɗ����̃V�[�h���Œ肷��B
rng(0)

%% DDPG�G�[�W�F���g�̒�`
hiddenLayerSize1 = 400;
hiddenLayerSize2 = 300;

imgPath = [
    imageInputLayer(obsInfo(1).Dimension,'Normalization','none','Name',obsInfo(1).Name)
    convolution2dLayer(10,2,'Name','conv1','Stride',5,'Padding',0)
    reluLayer('Name','relu1')
    fullyConnectedLayer(2,'Name','fc1')
    concatenationLayer(3,2,'Name','cat1')
    fullyConnectedLayer(hiddenLayerSize1,'Name','fc2')
    reluLayer('Name','relu2')
    fullyConnectedLayer(hiddenLayerSize2,'Name','fc3')
    additionLayer(2,'Name','add')
    reluLayer('Name','relu3')
    fullyConnectedLayer(1,'Name','fc4')
    ];
dthetaPath = [
    imageInputLayer(obsInfo(2).Dimension,'Normalization','none','Name',obsInfo(2).Name)
    fullyConnectedLayer(1,'Name','fc5','BiasLearnRateFactor',0,'Bias',0)
    ];
actPath =[
    imageInputLayer(actInfo(1).Dimension,'Normalization','none','Name','action')
    fullyConnectedLayer(hiddenLayerSize2,'Name','fc6','BiasLearnRateFactor',0,'Bias',zeros(hiddenLayerSize2,1))
    ];

criticNetwork = layerGraph(imgPath);
criticNetwork = addLayers(criticNetwork,dthetaPath);
criticNetwork = addLayers(criticNetwork,actPath);
criticNetwork = connectLayers(criticNetwork,'fc5','cat1/in2');
criticNetwork = connectLayers(criticNetwork,'fc6','add/in2');

%% Critic�l�b�g���[�N�̍\�����������܂��B
figure
plot(criticNetwork)

%% critic�̃I�v�V����
criticOptions = rlRepresentationOptions('LearnRate',1e-03,'GradientThreshold',1);
% GPU���g����CNN���w�K����ꍇ�͉��L���R�����g���O���Ă��Ă��������B
% criticOptions.UseDevice = 'gpu';

%% Critic�\�����쐬
critic = rlRepresentation(criticNetwork,criticOptions,'Observation',{'pendImage','angularRate'},obsInfo,'Action',{'action'},actInfo);

%% Actor�̂��߂̃l�b�g���[�N���`
imgPath = [
    imageInputLayer(obsInfo(1).Dimension,'Normalization','none','Name',obsInfo(1).Name)
    convolution2dLayer(10,2,'Name','conv1','Stride',5,'Padding',0)
    reluLayer('Name','relu1')
    fullyConnectedLayer(2,'Name','fc1')
    concatenationLayer(3,2,'Name','cat1')
    fullyConnectedLayer(hiddenLayerSize1,'Name','fc2')
    reluLayer('Name','relu2')
    fullyConnectedLayer(hiddenLayerSize2,'Name','fc3')
    reluLayer('Name','relu3')
    fullyConnectedLayer(1,'Name','fc4')
    tanhLayer('Name','tanh1')
    scalingLayer('Name','scale1','Scale',max(actInfo.UpperLimit))
    ];
dthetaPath = [
    imageInputLayer(obsInfo(2).Dimension,'Normalization','none','Name',obsInfo(2).Name)
    fullyConnectedLayer(1,'Name','fc5','BiasLearnRateFactor',0,'Bias',0)
    ];

actorNetwork = layerGraph(imgPath);
actorNetwork = addLayers(actorNetwork,dthetaPath);
actorNetwork = connectLayers(actorNetwork,'fc5','cat1/in2');

actorOptions = rlRepresentationOptions('LearnRate',1e-04,'GradientThreshold',1);
% GPU���g���ꍇ�͉��L�̃R�����g���O���Ă��������B
% criticOptions.UseDevice = 'gpu';

%% Actor�\�����쐬
actor = rlRepresentation(actorNetwork,actorOptions,'Observation',{'pendImage','angularRate'},obsInfo,'Action',{'scale1'},actInfo);

%% Actor�l�b�g���[�N�̍\��������
figure
plot(actorNetwork)

%% DDPG�G�[�W�F���g���쐬
agentOptions = rlDDPGAgentOptions(...
    'SampleTime',env.Ts,...
    'TargetSmoothFactor',1e-3,...
    'ExperienceBufferLength',1e6,...
    'DiscountFactor',0.99,...
    'MiniBatchSize',128);
agentOptions.NoiseOptions.Variance = 0.6;
agentOptions.NoiseOptions.VarianceDecayRate = 1e-6;
agent = rlDDPGAgent(actor,critic,agentOptions);

%% �G�[�W�F���g�̊w�K�I�v�V�����ݒ�
maxepisodes = 5000;
maxsteps = 400;
trainingOptions = rlTrainingOptions(...
    'MaxEpisodes',maxepisodes,...
    'MaxStepsPerEpisode',maxsteps,...
    'Plots','training-progress',...
    'StopTrainingCriteria','AverageReward',...
    'StopTrainingValue',-740);

%% �U��q�̏�Ԃ�����
plot(env);

%% �w�K�����s
doTraining = false;
if doTraining    
    % Train the agent.
    trainingStats = train(agent,env,trainingOptions);
else
    % Load pretrained agent for the example.
    load(fullfile(matlabroot,'examples','rl','SimplePendulumWithImageDDPG.mat'),...
        'agent'); 
end
%% �w�K�ς�DDPG�G�[�W�F���g�̎��s
simOptions = rlSimulationOptions('MaxSteps',500);
experience = sim(env,agent,simOptions);

%% 
% _Copyright 2019 The MathWorks, Inc._