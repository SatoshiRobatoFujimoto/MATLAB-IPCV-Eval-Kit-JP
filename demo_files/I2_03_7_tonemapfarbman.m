%% HDR�摜��ǂݍ���
HDR = hdrread('office.hdr');

%% �g�[���}�b�s���O�����s
LDR = tonemapfarbman(HDR);

%% ���ׂĉ���
figure,montage({HDR,LDR});

% Copyright 2018 The MathWorks, Inc.