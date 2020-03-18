%% Homomorphic Filtering
%   I1 = I  + N     �̌`�Ńm�C�Y������Ă���̂ł͂Ȃ�
%   I1 = I .* R     �̌`�ŉ摜���e�����󂯂Ă���ꍇ�i�Ɠx�ω����j�ɁAR���揜��
%    N��R�̎��g�����AI �Ɖ����ꍇ
%      Log�ϊ������邱�ƂŁAI������R������a�̌`�ŕ�����
% �ڍׂ�
%   http://blogs.mathworks.com/steve/2013/06/25/homomorphic-filtering-part-1
%   http://blogs.mathworks.com/steve/2013/07/10/homomorphic-filtering-part-2

%% �摜�̓Ǎ���
I = imread('AT3_1m4_01.tif');
figure;imshow(I);

%% Log�ϊ�
Id = im2double(I);      % 0~1
Il = log(Id + 1);        % ���ɂ��邽�߂ɁA1��������

%% �n�C�p�X �t�B���^ �W���̐ݒ�iSpacial Domain�j
filterRadius = 10;
filterSize = 2*filterRadius + 1;
hLowpass = fspecial('average', filterSize);
hImpulse = zeros(filterSize);
hImpulse(filterRadius+1,filterRadius+1) = 1;
hHPF = hImpulse - hLowpass;      % ���v���V�A���^
figure,freqz2(hHPF)              % 2�����t�B���^���g�������\��

%% �n�C�p�X �t�B���^ ����
Ilf = imfilter(Il, hHPF, 'replicate');

%% exp�֐��ŁALog�ϊ���߂��E�\��
If = exp(Ilf) - 1;
imshowpair(I, If, 'montage'); shg;

%% �I��





%% ���g���h���C���ł̃t�B���^�����O�̗�͉��L�Q��
%%    http://blogs.mathworks.com/steve/2013/06/25/homomorphic-filtering-part-1

% Copyright 2016 The MathWorks, Inc.