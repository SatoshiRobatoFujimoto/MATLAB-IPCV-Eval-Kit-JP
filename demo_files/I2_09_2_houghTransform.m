%% �n�t�ϊ� �f��
clear;clc;close all;imtool close all

%% �Ǘ��_�̐���
BW = false(40);
BW(20,15)=1;
figure;imshow(BW);

%% �Ǘ��_�ɑ΂���Hough�ϊ��E�\��
%      H:     �n�t�ϊ��s��
%      theta: x���l : �p�x(��)   -90���`89��  ����X���ɑ΂��Ď��v���ɒ�`
%      rho  : y���l : ���_����̋���
[H,theta,rho] = hough(BW);
figure, imshow(imadjust(mat2gray(H)),[],'XData',theta,'YData',rho,...
        'InitialMagnification','fit');
xlabel('\theta (degrees)'), ylabel('\rho');
axis on; axis normal         % ���W�\��
colormap(hot)

%% 3�_�ɑ΂���Hough�ϊ���\��
BW(22,17)=1;
BW(24,19)=1;
figure;imshow(BW);

%% Hough�ϊ��E�\��
%      H:     �n�t�ϊ��s��
%      theta: x���l : �p�x(��)   -90���`89��  ����X���ɑ΂��Ď��v���ɒ�`
%      rho  : y���l
[H,theta,rho] = hough(BW);
figure, imshow(imadjust(mat2gray(H)),[],'XData',theta,'YData',rho,...
        'InitialMagnification','fit');
xlabel('\theta (degrees)'), ylabel('\rho');
axis on; axis normal         % ���W�\��
colormap(hot)

%% �֐� houghpeaks ���g���ăn�t�ϊ��s�� H ���̃s�[�N�_�����o�E�v���b�g
peak = houghpeaks(H)
hold on
   % �s�[�N��theta��rho�l���擾���Ďl�p��Plot
plot(theta(peak(:,2)), rho(peak(:,1)), 's','color','red','MarkerFaceColor','red');
hold off

%% �֐� houghlines ���g���ăC���[�W���̐������o�B
%    lines�F point1, point2, theta, rho
%    ���꒼����ŁA�����Ԃ̋������w��l(5)�����������ꍇ2�̐������P�Ɍ���
lines = houghlines(BW, theta, rho, peak, 'FillGap', 5, 'MinLength', 3);
% ���̃C���[�W�ɏd�˂Đ����v���b�g���܂��B
xy = [reshape([lines.point1],2,[]); reshape([lines.point2],2,[])]';
BW1 = insertShape(uint8(BW), 'line', xy,'SmoothEdges',false);
imtool(BW1);

[lines.rho]          % ���_���璼���܂ł̋���
[lines.theta]        % �����̊p�x (��)



%% LSI�̎ʐ^�̉�� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;clc;close all;imtool close all            % ������

I  = imread('circuit.tif');
rotI = imrotate(I,33,'crop');
figure; imshow(rotI);

%% �G�b�W���o
BW = edge(rotI,'canny');
figure, imshow(BW);

%% Hough�ϊ��E�\��
%      H:     �n�t�ϊ��s��
%      theta: x���l : �p�x(��)   -90���`89��  ����X���ɑ΂��Ď��v���ɒ�`
%      rho  : y���l
[H,theta,rho] = hough(BW);

figure, imshow(imadjust(mat2gray(H)),[],'XData',theta,'YData',rho,...
        'InitialMagnification','fit');
xlabel('\theta (degrees)'), ylabel('\rho');
axis on; axis normal         % ���W�\��
colormap(hot)

%% �֐� houghpeaks ���g���ăn�t�ϊ��s�� H ���̃s�[�N�_�����o(5��)�E�v���b�g
%    �ő�l��0.3�ɖ����Ȃ����̂̓s�[�N�Ƃ��Ȃ�
%    �s�[�N�̓_��theta��rho�̔ԍ��g(�������؂�Ă���\�� => 5�Ƃ͌���Ȃ�)
hold on
peak = houghpeaks(H, 5, 'threshold', ceil(0.3*max(H(:))));
plot(theta(peak(:,2)), rho(peak(:,1)), 's','color','black','MarkerFaceColor','green');   % theta��rho�̔ԍ�����l���擾���Ďl�p��Plot
hold off

%% �֐� houghlines ���g���ăC���[�W���̐������o���܂��B
%    lines�F point1, point2, theta, rho
%    ���꒼����ŁA�����Ԃ̋������w��l(5)�����������ꍇ2�̐������P�Ɍ���
lines = houghlines(BW, theta, rho, peak, 'FillGap', 5, 'MinLength', 7);

% ���̃C���[�W�ɏd�˂Đ����v���b�g���܂��B
figure, imshow(rotI), hold on
for k = 1:length(lines)
   %   xy : [x1 y1; x2 y2]
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
end
[lines.theta]
hold off

%% �I��






% 
% 
%    % �n�_�I�_�Ƀ}�[�N�K�v�ȂƂ��Ffor���Ɉȉ�������
%    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
% 
%    % ��Ԓ�������Ԃ��\���K�v�ȂƂ�
%     %for�̑O��
%          max_len = 0;
%    % ���L��for��
%          len = norm(lines(k).point1 - lines(k).point2);
%          if ( len > max_len)
%            max_len = len;
%            xy_long = xy;
%          end
%   %  for �̌��
%          % ��Ԓ��������A�Ԃŕ\��
%          plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');
   
   


%% LSI�̎ʐ^�̉�� (�傫���摜�F�֐��ŏ��������ꍇ)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;clc;close all;imtool close all            % ������

I  = imread('circuit.tif');
rotI = imrotate(I,33,'crop');
figure; imshow(rotI);

%% �G�b�W���o
BW = edge(rotI,'canny');
BW = imresize(BW,10,'bicubic');
figure, imshow(BW);

%% Hough�ϊ��E�\�� %%%%%%%%%%%%%%
%      H:     �n�t�ϊ��s��
%      theta: x���l : �p�x(��)   -90���`89��  ����X���ɑ΂��Ď��v���ɒ�`
%      rho  : y���l
[H,theta,rho] = hough(BW);

figure, imshow(imadjust(mat2gray(H)),[],'XData',theta,'YData',rho,...
        'InitialMagnification','fit');
xlabel('\theta (degrees)'), ylabel('\rho');
axis on; axis normal         % ���W�\��
colormap(hot)

%% �֐� houghpeaks ���g���ăn�t�ϊ��s�� H ���̃s�[�N�_�����o(5��)�E�v���b�g
%    �ő�l��0.3�ɖ����Ȃ����̂̓s�[�N�Ƃ��Ȃ�
%    �s�[�N�̓_��theta��rho�̔ԍ��g(�������؂�Ă���\�� => 5�Ƃ͌���Ȃ�)
hold on
peak = houghpeaks(H, 5, 'threshold', ceil(0.3*max(H(:))));
plot(theta(peak(:,2)), rho(peak(:,1)), 's','color','black','MarkerFaceColor','green');   % theta��rho�̔ԍ�����l���擾���Ďl�p��Plot
hold off

%% �֐� houghlines ���g���ăC���[�W���̐������o���܂��B
%    lines�F point1, point2, theta, rho
%    ���꒼����ŁA�����Ԃ̋������w��l(5)�����������ꍇ2�̐������P�Ɍ���
lines = houghlines(BW, theta, rho, peak, 'FillGap', 5, 'MinLength', 7);

% ���̃C���[�W�ɏd�˂Đ����v���b�g���܂��B
figure, imshow(BW), hold on
for k = 1:length(lines)
   %   xy : [x1 y1; x2 y2]
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
end
[lines.theta]
hold off

%% �I��

% Copyright 2014 The MathWorks, Inc.