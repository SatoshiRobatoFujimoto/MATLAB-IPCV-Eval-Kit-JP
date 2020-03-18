%% �J���������֐�(CRF)�𐄒�

%% 6��LDR(Low Dynamic Range)�摜������(F�l�������ŘI�����Ԃ������قȂ�)
files = ["office_1.jpg","office_2.jpg","office_3.jpg",...
         "office_4.jpg","office_5.jpg","office_6.jpg"];

%% �J���������֐��𐄒�
crf = camresponse(files);

%% ���͉摜�̋P�x���x�����w��
range = 0:length(crf)-1;

%% RGB���ꂼ��̐����ł̃J���������֐����v���b�g
figure,
hold on
plot(crf(:,1),range,'--r','LineWidth',2);
plot(crf(:,2),range,'-.g','LineWidth',2);
plot(crf(:,3),range,'-.b','LineWidth',2);
xlabel('Log-Exposure');
ylabel('Image Intensity');
title('Camera Response Function');
grid on
axis('tight')
legend('R-component','G-component','B-component','Location','southeast')

% Copyright 2019 The MathWorks, Inc.