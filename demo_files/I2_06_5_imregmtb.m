%% MTB(Median Threshold Bitmap)��p�����摜�̃��W�X�g���[�V����
% �قȂ�I���x�̉摜�̎�荞��
I1 = imread('office_1.jpg');
I2 = imread('office_2.jpg');
I3 = imread('office_3.jpg');
I4 = imread('office_4.jpg');
I5 = imread('office_5.jpg');
I6 = imread('office_6.jpg');
%% �摜�̈ʒu�������_���Ɉړ�
t = randi([-30 30],5,2);
I1 = imtranslate(I1,t(1,:));
I2 = imtranslate(I2,t(2,:));
I3 = imtranslate(I3,t(3,:));
I4 = imtranslate(I4,t(4,:));
I5 = imtranslate(I5,t(5,:));
%% �w�肵��ROI�Ő؂�o���\��
roi = [140 260 200 200];
montage({imcrop(I1,roi),imcrop(I2,roi),imcrop(I3,roi), ...
    imcrop(I4,roi),imcrop(I5,roi),imcrop(I6,roi)})
title('Misaligned Images')
%% MTB��p���ă��W�X�g���[�V����
[R1,R2,R3,R4,R5,shift] = imregmtb(I1,I2,I3,I4,I5,I6);
montage({imcrop(R1,roi),imcrop(R2,roi),imcrop(R3,roi), ...
    imcrop(R4,roi),imcrop(R5,roi),imcrop(I6,roi)})
title('Registered Images')
%% ���W�X�g���[�V�����̍ۂ̈ړ��ʂƗ^�����ړ��ʂ��r
shift % ���W�X�g���[�V�����̈ړ���

-t % �ŏ��ɗ^�����ړ���
% �����悻�����l�ɂȂ��Ă��邩�m�F
%% 
% Copyright 2018 The MathWorks, Inc.
