function X = p2c( U, T)
% �ʑ��t�֐� : �ɍ��W�n����A���K���W�n�֎ʑ�
%   �J�X�^���ϊ��ɂ��摜�ϊ��Ŏg�p
[x,y] = pol2cart(U(:,1),U(:,2));
X(:,1) = x;
X(:,2) = y;

%  Copyright 2014 The MathWorks, Inc.
