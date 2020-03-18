%% ���w�j���[�����l�b�g���[�N�FDeep Neural Network(NN)�̊w�K�ɂ�鐔������
%  Autoencoder�̎�@�Ŋw�K����Encoder�𑽒i�d�˂����ʊ�F Stacked Autoencoder
%  GPU����񏈗��̃I�v�V�������g���ɂ́AParallel Computing Toolbox �̃��C�Z���X���K�v
clc;clear;close all;imtool close all;rng('default')

%% �w�K�p�摜�̓Ǎ���  �i�����������_���ȃA�t�B���ϊ��ŕό`�������̂��g�p�j
%     xTrainImages�F�w�K�p�摜�F28x28�s�N�Z���̉摜��5003��    (�Z���z��)
%     tTrain      �F���x���i���t�f�[�^�j10x5003
[xTrainImages, tTrain] = digitTrainCellArrayData;

%% �w�K�p�摜�̈ꕔ(80��)��\��
figure; montage(reshape([xTrainImages{1:80}], [28 28 1 80]), 'Size', [8,10]);

%% ���x��(���t�f�[�^)�̊m�F
openvar('tTrain')     % 10�s�ڂ́A����0�ɑΉ�

%% [���B��w]: Autoencoder�ɂ��1��ڂ̊w�K %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Autoencoder�ɂ��NN�̊w�K�F�o�͒l�����͒l�Ɠ����ɂȂ�悤�ɁA���t�Ȃ��w�K
%                            �B��w�̃T�C�Y�����͂�菭�Ȃ��Ȃ邱�ƂŁA���͏������k
% Autoencoder�N���X���g�p
% GPU�ɂ�鍂�������\
hiddenSize1 = 100;    % Encoder�̐�(�j���[�����̐�)
autoenc1 = trainAutoencoder(xTrainImages, hiddenSize1, ...
                                'MaxEpochs',400, ...      % �w�K�񐔁i����j
                                'L2WeightRegularization',0.004, ...        % impact of an L2 regularizer for the weights of the network (and not the biases). This should typically be quite small.
                                'SparsityRegularization',4, ...            % impact of a sparsity regularizer, which attempts to enforce a constraint on the sparsity of the output from the hidden layer
                                'SparsityProportion',0.15, ...
                                'ScaleData', false);
%% �E�F�C�g�̉����FEncoder���w�K��������
%    �T�C�Y�F����28x28=784�s�N�Z��(�m�[�h)�A���w(�B��/���ԑw)100�A���w�̏o��100�A �o��28x28=784�s�N�Z���A�B��(����)�w100
%    �m�[�h���ɁA784���̃E�F�C�gw�ƒ萔�o�C�A�Xb������B
%      (100�̃j���[���������ꂼ�ꊈ����������̓p�^�[���F���ꂼ��Ȃ�Ⓖ���p�^�[����\��)
b1 = autoenc1.EncoderBiases             % ���w�̃o�C�A�X
w1 = autoenc1.EncoderWeights;           % ���w�̃E�F�C�g
figure; plotWeights(autoenc1);          % �E�F�C�g�̉���


%% [���B��w]�F1��ڂ̊w�K�ō����Encoder�̏o�͂�p���A2�ڂ�Autoencoder�w�K %%%%%%%%%
% ��i�ڂ�Encoder�́A�w�K�摜�ɑ΂���o��(����)���v�Z => �w�K2�̊w�K�p�摜
feat1 = encode(autoenc1, xTrainImages);
%% �B��w�̃T�C�Y50�Ŋw�K
hiddenSize2 = 50;
autoenc2 = trainAutoencoder(feat1, hiddenSize2, ...
                              'MaxEpochs',100, ...
                              'L2WeightRegularization',0.002, ...
                              'SparsityRegularization',4, ...
                              'SparsityProportion',0.1, ...
                              'ScaleData', false);

%% [�ŏI�w]�F ��i�ڂ̏o��50����A10�N���X�֎��ʂ���ŏI�i��Softmax�w���w�K %%%%%%%%
% ��i�ڂ�Encoder�̏o�͂��v�Z
%   ���͂́A�w�K���ɗp�����A"�w�K�摜(784x5000��)�ɑ΂����i�ڂ�Encoder�o��"���g�p(100x5000��)
feat2 = encode(autoenc2, feat1);     % ���ʂ� 50x5000
%% �ŏI�w�̊w�K�F5000��50���w�K�f�[�^�ɑΉ����鋳�t�f�[�^(tTrain)���g�p
softnet = trainSoftmaxLayer(feat2, tTrain, 'MaxEpochs',400);

%% [����]�F�w�K����3�̑w��������\��
deepnet = stack(autoenc1, autoenc2, softnet)           % network object
view(deepnet);

%% [�e�X�g�p�摜�𕪗�]
% �e�X�g�摜~5000���̓Ǎ��݁F �e�X�g�摜:xTestImages�A���x��:tTest(10x4997)
[xTestImages, tTest] = digitTestCellArrayData;
% �Z���`����~5000�̃e�X�g�p�摜���A�e�񂪈�̉摜�f�[�^(28x28=784)�̍s��ɕϊ�
xTestMatrix = reshape([xTestImages{:}], [28*28 4997]);   % 784�s4997��̍s��

%% ����
result1 = deepnet(xTestMatrix);        % 10x4997

%% ~5000�摜�̔F�����ʂ̂����A�ŏ���100�𕪗ޥ���ʂ�\��(�Ԃ���F��)
Ir = zeros([28,28,3,100]);      % ���ʂ��i�[����z��
for k = 1:100
  img = xTestImages{k};
  [~, maxI] = max(result1(:,k));
  if maxI == find(tTest(:,k))
      colorN = 'green';
  else
      colorN = 'red';
  end
  img = insertText(img, [0 0], mod(maxI,10), 'TextColor',colorN, 'FontSize',14, 'BoxOpacity',0, 'Font','Lucida Sans Typewriter Bold');
  Ir(:,:,:,k)=img;
end
figure;montage(Ir);

%% �����s��̕\��
figure;plotconfusion(tTest, result1);

%% [������] �덷�t�`���@�ɂ��E�F�C�g�̔��������A�e�X�g�p�摜���ĕ���
% �Z���`����~5000�̊w�K�p�摜���A�e�񂪈�̉摜�f�[�^(28x28=784)�̍s��ɕϊ�
xTrain = reshape([xTrainImages{:}], [28*28 5003]);   % 784�s5003��̍s��
% ������
deepnet = train(deepnet, xTrain, tTrain);

%% �ĕ���
result2 = deepnet(xTestMatrix);        % 10x4997
Ir = zeros([28,28,3,100]);      % ���ʂ��i�[����z��
for k = 1:100
  img = xTestImages{k};
  [~, maxI] = max(result2(:,k));
  if maxI == find(tTest(:,k))
      colorN = 'green';
  else
      colorN = 'red';
  end
  img = insertText(img, [0 0], mod(maxI,10), 'TextColor',colorN, 'FontSize',14, 'BoxOpacity',0, 'Font','Lucida Sans Typewriter Bold');
  Ir(:,:,:,k)=img;
end
figure;montage(Ir);

%% �����s��̕\��
figure;plotconfusion(tTest, result2);

%% Copyright 2015 The MathWorks, Inc.

