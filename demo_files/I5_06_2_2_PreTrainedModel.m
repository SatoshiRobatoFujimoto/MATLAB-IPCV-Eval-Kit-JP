%% Pre-Trained ���f���̓Ǎ���
net = alexnet
net = vgg16
net = vgg19
net = squeezenet
net = googlenet
net = inceptionv3
net = densenet201
net = mobilenetv2
net = resnet18
net = resnet50
net = resnet101
net = xception
net = inceptionresnetv2

%% GoogleNet���g�p
net = googlenet

%% �l�b�g���[�N�̑w�\���̕\��
net.Layers

%% �l�b�g���[�N�̑w�\���̕\��(�O���t)
plot(net)

%% ���ނ���摜�̓Ǎ���
I = imread('peppers.png');

%% �l�b�g���[�N�̓��̓T�C�Y�։摜��؏o����\��
sz = net.Layers(1).InputSize 
I = I(1:sz(1),1:sz(2),1:sz(3));
figure; imshow(I);

%% ����(���_)
label = classify(net, I)

%% ���ʂ̉���
I1 = insertText(I, [20 20], char(label));
imshow(I1); shg;

%%
% Copyright 2018 The MathWorks, Inc.