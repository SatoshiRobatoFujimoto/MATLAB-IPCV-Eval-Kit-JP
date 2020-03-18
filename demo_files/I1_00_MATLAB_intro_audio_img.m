%% �����g�f��
% ������
clear;clc;close all;imtool close all

%% ���@�̊�{
t = 0:10             % �x�N�g���̍쐬�A�ϐ��錾�s�v�B�X�N���v�g����
a = t+1              % �x�N�g���⑽�����z��̂܂܌v�Z�B
b = sin(t)

%% �����g�̕`�� (��{����)
t = 0:0.1:1          % ���ԃx�N�g��
y = sin(2 * pi * 1 * t)  % �����g�̐��� sin(2��ft): �x�N�g���̂܂܌v�Z
       % �����@�\�F�v���b�g plot(t,y)   �v���b�gTab����

%% ���T���v�����O���g���̐����g�����E�����Đ� %%%%%%%%%%%%%%%%%%%%%%%
Fs = 44100;                   % �T���v�����O���g�� (44.1kHz)
t  = 0 : 1/Fs : 1;            % 1�b�ԕ��̎��ԃx�N�g��

%% 440Hz�̐����g�̐�����Đ�
tone1 = sin(2 * pi * 440  * t);
figure; plot(t, tone1);
xlim([0 0.02]);          
sound(tone1,Fs);                  % �����Đ�

%% 4184Hz�̐����g�̐�����Đ�
tone2 = sin(2 * pi * 4184 * t);   % 4184Hz
figure; plot(t, tone2); xlim([0 0.02]);
sound(tone2,Fs);

%% 2�̐����g�̍���
tone3 = tone1 + tone2;            % 440Hz + 4184Hz 
figure; plot(t, tone3); xlim([0 0.02]);
sound(tone3,Fs);

%% fft : ���g�����v���b�g (�Z�N�V�������s)
nfft    = 2^16;                         % fft�|�C���g
f       = 0 : Fs/nfft : Fs - Fs/nfft;   % ���g���x�N�g��
TONES    = fft(tone3, nfft); % ���Ԏ�������g�����ɕϊ� (2^16 FFT�|�C���g)
TONESpow   = abs(TONES);
figure; plot(f, TONESpow);xlim([0 5000]);

%% �t�B���^�̍쐬
% �E�B���h�E �x�[�X�̗L���C���p���X�����t�B���^�[�̌W���̌v�Z
%   B(z)=b(1) + b(2)z-1 + .... + b(n+1)z-N
[num, den] = fir1(20, 1000/(Fs/2))       % �t�B���^�`�B�֐��݌v  20��   �J�b�g�I�t1000Hz
fvtool(num,den);

%% �t�B���^�����O����ʕ\��
tone3_f  = filter(num, den, tone3);
subplot(2,1,1); plot(t, tone3  ); xlim([0 0.02]); %���g�`�\��
subplot(2,1,2); plot(t, tone3_f); xlim([0 0.02]);

%% �t�B���^�����O�O��̉��̍Đ�
sound(tone3  , Fs);      % �t�B���^���|����O�̉�
sound(tone3_f, Fs);      % �t�B���^���|������̉�

%% �摜����






%% �摜�ϊ� %%%%%%%%%%
load clown                % MAT�t�@�C������A�摜�f�[�^'X'�A�J���[�}�b�vmap�̓Ǎ���
figure;imshow(X,map);     % �\��
[x,y,z]=cylinder;         % �~�����W����
figure;mesh(x,y,z,'edgecolor',[0 0 0]);axis square;  %���W�\��
warp(x,y,z,flipud(X),map);axis square;shg  %�e�N�X�`���}�b�s���O

%% ���̔F�� %%%%%%%%%%%
RGB = imread('tape.png');      %�摜�Ǎ���
figure;imshow(RGB);            %�摜�\��

%% �~���o
[center, radius] = imfindcircles(RGB,[60 100],'Sensitivity',0.9) %�~���o

%% ���ʂ�`��
viscircles(center,radius);
hold on; plot(center(:,1),center(:,2),'yx','LineWidth',4);hold off; % ���S�_�\��
message = sprintf('The estimated radius is %2.1f pixels', radius);
text(15,300,sprintf('radius : %2.1f', radius), 'Color','y','FontSize',20);shg

%%
% Copyright 2014 The MathWorks, Inc.
