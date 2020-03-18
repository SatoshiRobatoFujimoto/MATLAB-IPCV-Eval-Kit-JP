% �X�N���v�g���J���A���s�BGUI��Next�{�^���������Ď���
clear;close all;clc

addpath('.\I1_02_grademo')

%% 2�������C���v���b�g
line2d
ft=figure('units','normalized','position',[0.0381 0.6969 0.2871 0.2276], ...
       'menubar','none','numbertitle','off');
at=axes('visible','off');
text(0.5,0.5,{'2�������C���v���b�g','(plot)'},'fontname','�l�r �S�V�b�N', ...
        'fontsize',12,'FontWeight','bold','tag','titletext','parent',at, ...
        'VerticalAlignment','middle','HorizontalAlignment','center');
uicontrol('Style', 'pushbutton', 'String', 'Next',...
        'Position', [20 20 100 40],'parent',ft,...
        'Callback', 'a=false;');
a=true; while (a); drawnow; end;

%%  2�������C���v���b�g(�}�[�J�[��)
figure(1)
h=findobj(gca,'type','line');
set(h(1),'marker','o')
set(h(2),'marker','*')
set(h(3),'marker','d')
grid on
a=true; while (a); drawnow; end

%% �ɍ��W�v���b�g (polar)
clear
polarplot
ht=findobj('tag','titletext');
set(ht,'string','�ɍ��W�v���b�g (polar)')
a=true; while (a); drawnow; end

%% �R���p�X�v���b�g
clear
compassplot
ht=findobj('tag','titletext');
set(ht,'string',{'�R���p�X�v���b�g','(compass)'})
a=true; while (a); drawnow; end

%% �̈�̓h��Ԃ� (fill)
clear
fill2d
ht=findobj('tag','titletext');
set(ht,'string','�̈�̓h��Ԃ� (fill)')
a=true; while (a); drawnow; end

%% 2�������U�v���b�g (stem)
clear
stem2d
ht=findobj('tag','titletext');
set(ht,'string','2�������U�v���b�g (stem)')
a=true; while (a); drawnow; end

%% �K�i��v���b�g (stairs)
clear
stair2d
ht=findobj('tag','titletext');
set(ht,'string','�K�i��v���b�g (stairs)')
a=true; while (a); drawnow; end

%% 3�������C���v���b�g
clear
line3d
ht=findobj('tag','titletext');
set(ht,'string',{'3�������C���v���b�g','(plot3)'})
a=true; while (a); drawnow; end

%% ���b�V���v���b�g (mesh)
clear
meshdemo
ht=findobj('tag','titletext');
set(ht,'string','���b�V���v���b�g (mesh)')
a=true; while (a); drawnow; end

%% �\�ʃv���b�g (surf)
clear
surfdemo
ht=findobj('tag','titletext');
set(ht,'string','�\�ʃv���b�g (surf)')
a=true; while (a); drawnow; end

%% 3�����f�ʃv���b�g (slice)
clear
slicedemo
ht=findobj('tag','titletext');
set(ht,'string','3�����f�ʃv���b�g (slice)')
a=true; while (a) drawnow; end

%% 3�����I�u�W�F�N�g (surf)
clear
obj3d1
ht=findobj('tag','titletext');
set(ht,'string','3�����I�u�W�F�N�g (surf)')
a=true; while (a) drawnow; end

%% 2�����������} (contour)
clear
cont2d
ht=findobj('tag','titletext');
set(ht,'string','2�����������} (contour)')
a=true; while (a) drawnow; end

%% �h��Ԃ�2�����������}
clear
cont2df
ht=findobj('tag','titletext');
set(ht,'string',{'�h��Ԃ�2�����������}','(contour)'})
a=true; while (a); drawnow; end

%% 3�����������} (contour3)
clear
cont3d
ht=findobj('tag','titletext');
set(ht,'string','3�����������} (contour3)')
a=true; while (a) drawnow; end

%% �~�O���t (pie)
clear
piedemo
ht=findobj('tag','titletext');
set(ht,'string','�~�O���t (pie)')
a=true; while (a); drawnow; end
 
%% �_�O���t
% clear
% bargraph
% ht=findobj('tag','titletext');
% set(ht,'string','�_�O���t')
%a=true; while (a) drawnow; end

%% �q�X�g�O���� (hist)
clear
histplot
ht=findobj('tag','titletext');
set(ht,'string','�q�X�g�O���� (hist)')
a=true; while (a); drawnow; end

%% �摜�\�� (imshow)
clear
implot
ht=findobj('tag','titletext');
set(ht,'string','�摜�\�� (imshow)')
a=true; while (a); drawnow; end

%% warp
clear
warpdemo
ht=findobj('tag','titletext');
set(ht,'string',{'�T�[�t�F�[�X�ւ�','�摜�̓\��t�� (warp)'})
a=true; while (a); drawnow; end

%% �A�j���[�V����
%clear
%anim
%ht=findobj('tag','titletext');
%set(ht,'string','�A�j���[�V����')
% a=true; while (a) drawnow; end

%% Delaunay�̎O�p���b�V��
% clear
% close all
% tridemo
% ft=figure('units','normalized','position',[0.6367 0.7279 0.2871 0.1276], ...
%        'menubar','none','numbertitle','off');
% at=axes('visible','off');
% ht=text(0.5,0.5,'Delaunay�̎O�p���b�V��','fontname','�l�r �S�V�b�N', ...
%         'fontsize',17,'FontWeight','bold','tag','titletext1','parent',at, ...
%         'VerticalAlignment','middle','HorizontalAlignment','center');
% a=true; while (a) drawnow; end

%% ���b�V���A�R���^�[
% clear
% meshcontour
% ht=findobj('tag','titletext1');
% set(ht,'string',{'���b�V���A�R���^�[�A','�x�N�g���ɂ��\��'})
% a=true; while (a) drawnow; end


% clear
% close all
% mixplot
% ft=figure('units','normalized','position',[0.0381 0.7969 0.2871 0.1276], ...
%        'menubar','none','numbertitle','off');
% at=axes('visible','off');
% ht=text(0.5,0.5,{'���̓����̉~���v���b�g','�X�g���[�����C��','���l��'},'fontname','�l�r �S�V�b�N', ...
%         'fontsize',14,'FontWeight','bold','tag','titletext','parent',at, ...
%         'VerticalAlignment','middle','HorizontalAlignment','center');
%a=true; while (a) drawnow; end

%% �����̓��l��
clear
flowiso2
ht=findobj('tag','titletext');
set(ht,'string',{'�����̓��l��', '(patch, isosurface)'})
a=true; while (a); drawnow; end

%% �X���C�X���ʏ�ɓ�����
clear
cslice
ht=findobj('tag','titletext');
set(ht,'string',{'�X���C�X���ʏ�ɓ�����','(contourslice)'})
a=true; while (a); drawnow; end

%% �����̒f�ʐ}
clear
headiso_h
ht=findobj('tag','titletext');
set(ht,'string',{'�����̒f�ʐ}','(patch, isosurface)','(patch, isocaps)'})
a=true; while (a); drawnow; end

%% movie
clear
ht=findobj('tag','titletext');
set(ht,'string',{'�A�j���[�V����','(movie)'})
animdemo

%% �I��
clear
ht=findobj('tag','titletext');
set(ht,'string','�I��')

rmpath('.\I1_02_grademo')

%% Copyright 2014 The MathWorks, Inc.
