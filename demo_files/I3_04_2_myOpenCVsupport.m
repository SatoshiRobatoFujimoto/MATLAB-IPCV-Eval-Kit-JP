%% OpenCV �� �C���^�[�t�F�[�X�������� C�̊֐����A
%     MATLAB����R�[�����邽�߂̃T�|�[�g�p�b�P�[�W
%   �iR2014b�FComputer Vision System Toolbox�̐V�@�\�j
%  �����r�f�I�Fhttp://jp.mathworks.com/videos/using-opencv-with-matlab-106409.html

%% �T�|�[�g�p�b�P�[�W�̃C���X�g�[��
% ���L�R�}���h�����s���AOpenCV Interface    ���C���X�g�[��
visionSupportPackages

%% �T�|�[�g�p�b�P�[�W���C���X�g�[�����ꂽ�f�B���N�g�����m�F
fileLoc = which('mexOpenCV.m')
winopen(fileLoc(1:end-12));    % �f�B���N�g�����J��

% �f�B���N�g�����́AREADME.txt  ���m�F
% ���ɁA�K�v��C�R���p�C���ɒ���
% ���́Aexample �f�B���N�g����

%% C++�p�̃R���p�C���̐ݒ�̊m�F
%  ���ꂽ�I������A��L��README.txt�ɏ�����Ă���R���p�C����I��
mex -setup c++

%% ���݂̃t�H���_��example�t�H���_���R�s�[
copyfile([fileLoc(1:end-12) '\example'], 'OpenCV_example_copy')

%% TemplateMatching �̗��t�H���_�ֈړ�
cd OpenCV_example_copy\TemplateMatching

%% �p�ӂ���Ă���AmatchTemplateOCV.cpp �����b�p�[�Ƃ��āAMEX�t�@�C���փR���p�C��
edit matchTemplateOCV.cpp        % ���b�p�[�̓��e���m�F
%% mexOpenCV �֐���p���R���p�C���iC++���R���p�C�����AOpenCV�̃��C�u�����ƃ����N�j
mexOpenCV matchTemplateOCV.cpp   %  matchTemplateOCV.mexw64 �������� .mexw32 �����������

%% �������ꂽMEX�t�@�C���̓�����m�F
%     ���b�p�[�t�@�C���̖��O�ŌĂяo��
edit testMatchTemplate           % �e�X�g�x���`���m�F�imatchTemplateOCV �Ƃ��ăR�[���j

%%
% TemplateMatching�̗��F�i����������MEX���łǂ̂悤�Ɏ�舵�����̗�
cd ..\ForegroundDetector

%% �p�ӂ���Ă��� API�̈ꗗ���m�F
edit([matlabroot '\extern\include\opencvmex.hpp']);

%% �I��




% ���b�p�[�t�@�C���̓��e�ɂ���
%    #include "opencvmex.hpp"      �F���̃T�|�[�g�p�b�P�[�W�Œ񋟂����SAPI��錾
%    ���b�p�[�̊֐���������͒�^�̂��̂��g�p�F�֐��̖��O�� mexFunction
%    mxArray ��MATLAB�Ŏg����g����f�[�^�^�Acv::MAT�́AOpenCV�Ŏg����f�[�^�^

%% Copyright 2015 The MathWorks, Inc.

