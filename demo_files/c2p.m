function X = c2p( U, T)
% �ʑ��֐� : ���K���W�n����A�ɍ��W�n�֎ʑ�
%   �J�X�^���ϊ��ɂ��摜�ϊ��Ŏg�p
[th,r] = cart2pol(U(:,1),U(:,2));
X(:,1) = th;
X(:,2) = r;


% Copyright 2014 The MathWorks, Inc.

