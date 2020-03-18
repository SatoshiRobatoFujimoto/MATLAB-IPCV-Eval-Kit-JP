%% �A�ˉ摜���獂�𑜓x�摜����(����)

%% ��𑜓x�̘A�ˉ摜��ǂݍ��݁A����
setDir = fullfile(toolboxdir('images'),'imdata','notebook');
imds = imageDatastore(setDir,'FileExtensions',{'.png'});
montage(imds)
title('Set of Low-Resolution Burst Mode Images')

%% �u�����������邽�߂ɉ摜�̈ʒu���킹
imdsTransformed = transform(imds,@(x) rgb2lightness(x));
refImg = read(imdsTransformed);
[optimizer,metric] = imregconfig('monomodal');
numImages = numpartitions(imds);
tforms = repmat(affine2d(),numImages-1,1);
idx = 1;
while hasdata(imdsTransformed)
    movingImg = read(imdsTransformed);
    tforms(idx) = imregtform(refImg,movingImg,'rigid',optimizer,metric);
    idx = idx + 1;
end

%% ���𑜓x�摜�̐���
scale = 4; % ���{�̉𑜓x�ŏo�͂��邩
B = burstinterpolant(imds,tforms,scale);
figure('WindowState','maximized')
imshow(B)
title ('High-Resolution Image')

%% ���͉摜�T�C�Y�Əo�͉摜�T�C�Y���r
Img = read(imds);
inputDim = [size(Img,1) size(Img,2)]
outputDim = [size(B,1) size(B,2)]

%% 
% Copyright 2019 The MathWorks, Inc.