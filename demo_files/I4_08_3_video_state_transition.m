function x_k = video_state_transition(pf, x_k_1)
% �����x���f��
%   x_k_1 : Nx6�̔z��

% ��ԃx�N�g�� = [x, xd, xdd, y, yd, ydd]

% ��ԑJ�ڃ��f��
stateTransitionModel = ...
    [1     1     0     0     0     0;
     0     1     1     0     0     0;
     0     0     1     0     0     0;
     0     0     0     1     1     0;
     0     0     0     0     1     1;
     0     0     0     0     0     1 ];

% �m�C�Y�i���K���z�̕��U�j
% processNoise = ...
%     [25     0     0     0     0     0;
%      0     10     0     0     0     0;
%      0      0    10     0     0     0;
%      0      0     0    25     0     0;
%      0      0     0     0    10     0;
%      0      0     0     0     0    10];
   
   processNoise = ...
    [1      0     0     0     0     0;
     0      1     0     0     0     0;
     0      0   0.5     0     0     0;
     0      0     0     1     0     0;
     0      0     0     0     1     0;
     0      0     0     0     0   0.5];
   
   
   

N = pf.NumParticles;      % ���q�����擾
R = chol(processNoise);   % �v�f���������l��
noise = randn(N,6) * R';

% �S���q�́A����Ԃ��v�Z�i�K�E�V�A���m�C�Y������j
%    �S���q���ꊇ�v�Z���邽�߂ɁA�s��̐ς̌`�����ւ�
x_k =  x_k_1 * stateTransitionModel' + noise;

end

% Copyright 2018 The MathWorks, Inc.