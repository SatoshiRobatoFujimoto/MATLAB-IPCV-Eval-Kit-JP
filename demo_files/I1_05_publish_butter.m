%% �o�^���[�X�t�B���^�̐݌v�ƃt�B���^�����O
% �{�f���́A�G����������2�g�[�������g�ɑ΂��āA�o�^���[�X���[�p�X�t�B���^��
% ������菇�ƁA�O���t�̉����̎菇�������܂��B��ʓI�ȃf�W�^���t�B���^��
% �`�B�֐��͈ȉ��̕\���ŕ\�킳��܂��B
% 
% $$ H(z) = \frac{\sum^{N}_{k = 0}b_kZ^{-k}}{1 + \sum^{N}_{k = 1}a_kZ^{-k}} $$  
%% ������
clear all, close all, clc

%% �t�B���^�����O�Ώۂ̐M������
Fs = 1000;
t = 0:1/Fs:1;                   % ���ԃx�N�g���̒�`
sig1 = sin(2*pi*15*t + pi/3);   % �����g�M��1�̐���
sig2 = sin(2*pi*42*t + pi/5);   % �����g�M��2�̐���
noise = randn(size(t));         % �G���M���̐���
sig = sig1 + sig2 + noise;      % �t�B���^�����O�ΏېM��

%% �t�B���^�݌v�Ɠ����̉���
% �t�B���^�̎�����7���A�i�C�L�X�g���g���Ő��K�����ꂽ�J�b�g�I�t
% ���g����0.1�Ƃ����t�B���^��݌v���܂��BFs = 1000[Hz]�̏ꍇ�A
% �J�b�g�I�t���g���́A1000/2 * 0.1 = 50[Hz]�ƂȂ�܂��B
[b,a] = butter(7,0.1); % �o�^���[�X�t�B���^�݌v
fvtool(b, a) % �t�B���^�����̉���

%% �t�B���^�����O
out = filter(b,a,sig); % �t�B���^�����O
% ���͐M���Əo�͐M���̎��Ԏ��g�`����
subplot(2,1,1), plot(t,sig), grid
title('���Ԏ��g�`�i�t�B���^�����O�O�j')
subplot(2,1,2), plot(t,out), grid
title('���Ԏ��g�`�i�t�B���^�����O��j')

%% �X�y�N�g������
% ���[�p�X�t�B���^�ɂ��A50[Hz]�ȉ��̐�������������Ă���l�q��
% �m�F�ł��܂��B
figure, periodogram(sig,[],[],Fs)    % ���͐M���̃X�y�N�g��
title('�p���[�X�y�N�g�����x����i�t�B���^�����O�O�j')
figure,periodogram(out,[],[],Fs)    % �o�͐M���̃X�y�N�g��
title('�p���[�X�y�N�g�����x����i�t�B���^�����O��j')


% Copyright 2014 The MathWorks, Inc.
