%% �摜�̓Ǎ���
I = imread('mri.tif');

%% �摜�̉�]
J = imrotate(I,-30);

%% ���ׂĕ\��
figure; imshowpair(I, J, 'montage');

%% ���W�X�g���[�V����������N��
registrationEstimator(J, I)


% Copyright 2014 The MathWorks, Inc.