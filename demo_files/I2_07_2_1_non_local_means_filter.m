%% ��Ǐ�����(Non-local means)�t�B���^�ɂ��m�C�Y����

%% �摜��ǂݍ��݁A�m�C�Y��t��
im = imread('peppers.png');
imn = imnoise(im, 'gaussian', 0, 0.0015);
figure, imshow(imn);

%% �F��Ԃ�RGB����L*a*b�ɕϊ�
iml = rgb2lab(imn);

%% ����̗̈��؂�o��
rect = [210, 24, 52, 41];
imcl = imcrop(iml, rect);

%% �p�b�`���̕W���΍����v�Z
edist = imcl.^2;
edist = sqrt(sum(edist,3)); % ���_����̃��[�N���b�h����
patchSigma = sqrt(var(edist(:)));

%% �X���[�V���O�̃p�����[�^���w�肵�ăm�C�Y����
imls = imnlmfilt(iml,'DegreeOfSmoothing', 1.5*patchSigma);
ims = lab2rgb(imls,'Out','uint8');
montage({imn, ims});

%%
% Copyright 2018 The MathWorks, Inc.
