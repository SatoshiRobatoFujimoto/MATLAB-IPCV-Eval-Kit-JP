clc;close all;imtool close all;clear;

%% �z��̎��O���蓖�ĂȂ��i�ᑬ�j
%    ���[�v�̒��ŕϐ�x�̗v�f�̐������񂾂�傫���Ȃ�
clear
tic
for n = 1:1e7
  x(n) = n;
end
toc

%% �z��̎��O���蓖�āi�����j
clear
x = zeros(1e7,1);
tic
for n = 1:10000000
  x(n) = n;
end
toc

%% �v�f���X�L��������:������ �i�ᑬ�j
%    4000x4000�̍s��́A�v�f��0.5�ȏ�̏ꏊ��true�ɂ���
clear
X = rand(4000);
Y = false(4000);
tic
for r = 1:4000 % �s
    for c = 1:4000 % ��
        if X(r, c) > 0.5
            Y(r, c) = true;
        end
    end
end
toc

%% �c�����ɗv�f���X�L��������i�����j
clear
X = rand(4000);
Y = false(4000);
tic
for c = 1:4000 % ��
    for r = 1:4000 % �s
        if X(r, c) > 0.5
            Y(r, c) = true;
        end
    end
end
toc

%% �z��ŏ��� (��荂��)
clear
X = rand(4000);
Y = false(4000);
tic
  Y = X > 0.5;
toc

%% Copyright 2015 The MathWorks, Inc.

