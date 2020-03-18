function out = myfilter(imWaterMask)
%#codegen
coder.gpu.kernelfun

%% �K�E�V�A���t�B���^�ŉ摜���ڂ���
blurH = fspecial('gaussian',20,5);
out = imfilter(single(imWaterMask)*10, blurH);

end

%% 
% Copyright 2019 The MathWorks, Inc.