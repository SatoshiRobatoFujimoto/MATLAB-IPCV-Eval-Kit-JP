%% �����������܂މ摜����
% ��_�J�����œ����Ă��Ȃ����̂��قȂ�I���x�ŎB�e�����������̉摜����荞��
I1 = imread('car_1.jpg');
I2 = imread('car_2.jpg');
I3 = imread('car_3.jpg');
I4 = imread('car_4.jpg');
montage({I1,I2,I3,I4})
%% 
% blendexposure�֐��ŘI���x���قȂ镡�����̉摜��Z�����Ĉ�̉摜���쐬
E = blendexposure(I1,I2,I3,I4);
% ���������̋��x��}����@�\��OFF�ɂ������ʂ����킹�ĕ\��
F = blendexposure(I1,I2,I3,I4,'ReduceStrongLight',false); 
montage({E,F})
title('Exposure Fusion With (Left) and Without (Right) Strong Light Suppression')

%% 
% Copyright 2018 The MathWorks, Inc.