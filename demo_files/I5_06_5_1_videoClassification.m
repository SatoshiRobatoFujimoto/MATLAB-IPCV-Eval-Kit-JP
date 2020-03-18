%% 5.6.5.1 �f�B�[�v���[�j���O�F����̕���

%% �w�K�ς݃��f���̓ǂݍ���
netCNN = googlenet;

%% �f�[�^�̓ǂݍ���
% <http://serre-lab.clps.brown.edu/resource/hmdb-a-large-human-motion-database/ 
% HMDB: a large human motion database>����RAR���_�E�����[�h����(|hmdb51_org)�B
% 51�N���X��7000�̃r�f�I�V�[�P���X�B"����"�A"����","���U��"�ȂǁB|
% 
% �t�@�C�����ƃ��x�����擾���邽�߂̃T�|�[�g�֐����g��
dataFolder = "hmdb51_org";
if ~exist(fullfile(pwd,dataFolder),'dir')
    error("�f�[�^�Z�b�ghmdb51_org���_�E�����[�h���ĉ𓀂��Ă�������" +...
    "http://serre-lab.clps.brown.edu/resource/hmdb-a-large-human-motion-database/");
end
[files,labels] = hmdb51Files(dataFolder);

%% �r�f�I�f�[�^��ǂݍ���
% HxWxCx_S�̔z��A�����A���A�`���l�����A�t���[�����̏���
idx = 1;
filename = files(idx);
video = readVideo(filename);
size(video)

%% �Ή����郉�x�����m�F

labels(idx)

%% imshow�ŕ\��
% double�^�̏ꍇ�͒l��[0 1]�͈̔͂ɂ���K�v������̂�255�Ő��K���B

numFrames = size(video,4);
figure
for i = 1:numFrames
    frame = video(:,:,:,i);
    imshow(frame/255);
    drawnow
end

%% �r�f�I��������x�N�g���̒��o
% ���s�ɂ�30���ȏォ����̂Œ��ӁB

inputSize = netCNN.Layers(1).InputSize(1:2);
layerName = "pool5-7x7_s1";

tempFile = fullfile(tempdir,"hmdb51_org.mat");

if exist(tempFile,'file')
    load(tempFile,"sequences")
else
    numFiles = numel(files);
    sequences = cell(numFiles,1);
    
    for i = 1:numFiles
        fprintf("Reading file %d of %d...\n", i, numFiles)
        
        video = readVideo(files(i));
        video = centerCrop(video,inputSize);
        
        sequences{i,1} = activations(netCNN,video,layerName,'OutputAs','columns');
    end
    
    save(tempFile,"sequences","-v7.3");
end
%% �����x�N�g���̃T�C�Y���m�F
% DxS�̔z��ɂȂ��Ă���BD�͓����x�N�g���̃T�C�Y�BS�̓r�f�I�̃t���[�����B
sequences(1:10)

%% �w�K�f�[�^�̏���
% �w�K�p�ƌ���p�Ƀf�[�^�Z�b�g��9:1�ɕ���

numObservations = numel(sequences);
idx = randperm(numObservations);
N = floor(0.9 * numObservations);

idxTrain = idx(1:N);
sequencesTrain = sequences(idxTrain);
labelsTrain = labels(idxTrain);

idxValidation = idx(N+1:end);
sequencesValidation = sequences(idxValidation);
labelsValidation = labels(idxValidation);

%% ���߂̃r�f�I�͏�������
% �p�f�B���O�ɂ�鈫�e��������邽�߂ɒ�������V�[�P���X�͏�������B

numObservationsTrain = numel(sequencesTrain);
sequenceLengths = zeros(1,numObservationsTrain);

for i = 1:numObservationsTrain
    sequence = sequencesTrain{i};
    sequenceLengths(i) = size(sequence,2);
end

figure
histogram(sequenceLengths)
title("Sequence Lengths")
xlabel("Sequence Length")
ylabel("Frequency")

%% 400�t���[���ȏ�̂��̂͏����h�Ȃ̂ŏ�������B

maxLength = 400;
idx = sequenceLengths > maxLength;
sequencesTrain(idx) = [];
labelsTrain(idx) = [];

%% LSTM�l�b�g���[�N�̍쐬
% BiLSTM���C���[��2000�̉B��w��ݒ�B
% �o�͂�1�̃��x���Ȃ̂�'OutputMode'��'last'�ݒ�B
% fully connected layer�͕��ސ��ɐݒ�B

numFeatures = size(sequencesTrain{1},1);
numClasses = numel(categories(labelsTrain));

layers = [
    sequenceInputLayer(numFeatures,'Name','sequence')
    bilstmLayer(2000,'OutputMode','last','Name','bilstm')
    dropoutLayer(0.5,'Name','drop')
    fullyConnectedLayer(numClasses,'Name','fc')
    softmaxLayer('Name','softmax')
    classificationLayer('Name','classification')];

%% �g���[�j���O�I�v�V�����̐ݒ�
% �~�j�o�b�`���Ƃɍŏ��̃t���[�����Ɠ����ɂȂ�悤�ɐ؂���B
% �G�|�b�N���ƂɃf�[�^���V���b�t���B

miniBatchSize = 16;
numObservations = numel(sequencesTrain);
numIterationsPerEpoch = floor(numObservations / miniBatchSize);

options = trainingOptions('adam', ...
    'MiniBatchSize',miniBatchSize, ...
    'InitialLearnRate',1e-4, ...
    'GradientThreshold',2, ...
    'Shuffle','every-epoch', ...
    'ValidationData',{sequencesValidation,labelsValidation}, ...
    'ValidationFrequency',numIterationsPerEpoch, ...
    'Plots','training-progress', ...
    'Verbose',false);

%% LSTM�l�b�g���[�N�̊w�K
[netLSTM,info] = trainNetwork(sequencesTrain,labelsTrain,layers,options);

%% ���ސ��x�̊m�F�B

YPred = classify(netLSTM,sequencesValidation,'MiniBatchSize',miniBatchSize);
YValidation = labelsValidation;
accuracy = mean(YPred == YValidation)

%% �r�f�I���ރl�b�g���[�N�̑g�ݗ���

% ��ݍ��݃��C���[�̒ǉ�
cnnLayers = layerGraph(netCNN);

% �A�N�e�B�x�[�V�����̑w����̑w�͍폜�B
layerNames = ["data" "pool5-drop_7x7_s1" "loss3-classifier" "prob" "output"];
cnnLayers = removeLayers(cnnLayers,layerNames);

% �V�[�P���X�C���v�b�g���C���[��擪�ɒǉ�
% �C���[�W�V�[�P���X���������߂ɃV�[�P���X�C���v�b�g���C���[���`�B
% 'Normalization'�I�v�V������'zerocenter'�ɂ��A
% 'Mean'�I�v�V������GoogLeNet��averageImage�ɐݒ�B

inputSize = netCNN.Layers(1).InputSize(1:2);
averageImage = netCNN.Layers(1).AverageImage;

inputLayer = sequenceInputLayer([inputSize 3], ...
    'Normalization','zerocenter', ...
    'Mean',averageImage, ...
    'Name','input');

%% ��ݍ��݂��摜�̃V�[�P���X���ꂼ��ɂ����邽�߂�sequence folding layer���g�p����B

layers = [
    inputLayer
    sequenceFoldingLayer('Name','fold')];

lgraph = addLayers(cnnLayers,layers);
lgraph = connectLayers(lgraph,"fold/out","conv1-7x7_s2");

% LSTM���C���[��ǉ�
% LSTM�l�b�g���[�N����sequence input layer�������B
lstmLayers = netLSTM.Layers;
lstmLayers(1) = [];

% sequence folding layer�Aflatten layer�ALSTM layers��ǉ��B
layers = [
    sequenceUnfoldingLayer('Name','unfold')
    flattenLayer('Name','flatten')
    lstmLayers];
lgraph = addLayers(lgraph,layers);

% ��ݍ��ݑw�̍ŏI�w("pool5-7x7_s1")��sequence unfolding layer ("unfold/in")�ɐڑ��B
lgraph = connectLayers(lgraph,"pool5-7x7_s1","unfold/in");

% unfolding layer����V�[�P���X�\���𕜌����邽�߂ɁA
% sequence folding layer��|"miniBatchSize"�o�͂�|sequence 
% unfolding layer�ɐڑ��B
lgraph = connectLayers(lgraph,"fold/miniBatchSize","unfold/miniBatchSize");

%% analyzeNetwork�֐����g���ăl�b�g���[�N�̐������m�F�B
analyzeNetwork(lgraph)

%% assembleNetwork�֐����g���ăl�b�g���[�N��g�ݏグ
net = assembleNetwork(lgraph)

%% �V�����r�f�I�ɑ΂��ĕ��ނ�������
% "pushup.mp4"�r�f�I��ǂݍ���Œ����؂�o���B
filename = "pushup.mp4";
video = readVideo(filename);

%% ����
numFrames = size(video,4);
figure
for i = 1:numFrames
    frame = video(:,:,:,i);
    imshow(frame/255);
    drawnow
end

%% ���ނ����s

% classify�֐��ɂ͓��̓r�f�I����Z���z��Ƃ��ė^����K�v������B|
video = centerCrop(video,inputSize);
YPred = classify(net,{video})

%% �T�|�[�g�֐�
% �r�f�I�f�[�^��ǂݏo���B

function video = readVideo(filename)

vr = VideoReader(filename);
H = vr.Height;
W = vr.Width;
C = 3;

% Preallocate video array
numFrames = floor(vr.Duration * vr.FrameRate);
video = zeros(H,W,C,numFrames);

% Read frames
i = 0;
while hasFrame(vr)
    i = i + 1;
    video(:,:,:,i) = readFrame(vr);
end

% Remove unallocated frames
if size(video,4) > i
    video(:,:,:,i+1:end) = [];
end

end
%% 
% �����؂�o���Ɠ��͉摜�T�C�Y�ɍ��킹�ă��T�C�Y�B

function videoResized = centerCrop(video,inputSize)

sz = size(video);

if sz(1) < sz(2)
    % Video is landscape
    idx = floor((sz(2) - sz(1))/2);
    video(:,1:(idx-1),:,:) = [];
    video(:,(sz(1)+1):end,:,:) = [];
    
elseif sz(2) < sz(1)
    % Video is portrait
    idx = floor((sz(1) - sz(2))/2);
    video(1:(idx-1),:,:,:) = [];
    video((sz(2)+1):end,:,:,:) = [];
end

videoResized = imresize(video,inputSize(1:2));

end
%% 
% _Copyright 2019 The MathWorks, Inc._