%% RGB�F��Ԃ̕␳

%% �摜�ǂݍ���
A = imread('foosballraw.tiff');

%% �f���U�C�N & �Q�C������
% RGGB�̃x�C���[�p�^�[������RGB���)
A = demosaic(A,'rggb');
A = 3*A; % �Q�C������
A_sRGB = lin2rgb(A);
figure
imshow(A_sRGB,'InitialMagnification',25)
title('Original Image')

%% �`�F�b�J�[�{�[�h�̃O���C�̈ʒu���w��
x = 1510;
y = 1250;
hold on;
plot(x,y,'ro');
light_color = [A(y,x,1) A(y,x,2) A(y,x,3)]

%% �F�������␳
B = chromadapt(A,light_color,'ColorSpace','linear-rgb');
B_sRGB = lin2rgb(B);
figure
imshow(B_sRGB,'InitialMagnification',25)
title('White-Balanced Image')

%% �␳��̐F�̊m�F(RGB���������x�ɂȂ��Ă���)
patch_color = [B(y,x,1) B(y,x,2) B(y,x,3)]

%% ���̏���
% 
%% �摜�ǂݍ���
A = imread('foggysf2.jpg');
figure, imshow(A);

%% ���̏���
B = imreducehaze(A, 0.9, 'method', 'approxdcp');
figure, imshow(B);

%% ���ׂĕ\��
figure, imshowpair(A, B, 'montage')

%%
% Copyright 2017 The MathWorks, Inc.