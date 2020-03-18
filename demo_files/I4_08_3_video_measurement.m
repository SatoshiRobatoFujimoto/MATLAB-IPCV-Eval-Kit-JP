function lhood = video_measurement(pf, x_k_hat, z_k)
% �e���q�̖ޓx��Ԃ�
%   x_k_hat (N-by-6) : �\���X�e�b�v�ŗ\�����ꂽ�A�e���q�̏�ԃx�N�g��
%   z_k (1-by-2) : correct�̑�2���� => ���o���ꂽ�{�[���̈ʒu

% ��ԃx�N�g�� = [x, xd, xdd, y, yd, ydd]
N = pf.NumParticles;    % ���q��

% �ϑ��G���[
measurementNoise = ...
    [25  0; 
      0 25];
  
% �ϑ��s��F���Wx��y�𑪒�
measurementModel = ...
    [1 0 0 0 0 0;
     0 0 0 1 0 0];

% �\�����ꂽ�S���q�̏�ԃx�N�g������A�\�������ϑ����W�ʒu���v�Z
z_hat = x_k_hat * measurementModel';      % �T�C�Y�FNx2

% ���肳�ꂽ�{�[���ʒu�ƁA�\�����ꂽ�S���q�ʒu�̍����v�Z
z_error = abs(repmat(z_k, N, 1) - z_hat); % �T�C�Y�FNx2

% ���������֕ϊ��ierror norm�j
z_norm = sqrt(sum(z_error.^2, 2));        % �T�C�Y�FNx1

% �ޓx���Z�o
%�i���ϗʐ��K���z�Fmultivariate normal distribution�̊m�����x�֐����g���v�Z�j
lhood = 1/sqrt((2*pi).^3 * det(measurementNoise)) * exp(-0.5 * z_norm);
end


% Copyright 2018 The MathWorks, Inc.