%% �f�o�b�O�@�\�̏Љ�
% �G�f�B�^�[�c�[���X�g���b�v�́A"���s����ю��Ԃ̌v��" �����s
% �v���t�@�C���[�̊֐��̖��O���N���b�N���ăJ�o���b�W���m�F


function profilerTest()

  I = magic(1000);
  a = 0;
  for i=1:10
      I = myMult(I, 1.1);
      a = a + max(I(:));
  end
  
  if  numel(I) == 20       % I�̗v�f��
      I=magic(1000);       % ���s����Ȃ��s
  end
end

function c = myMult(a, b)
  d = a + 1;
  c = d * b;
end




% ���݂̃t�H���_�[��"�����" => ���|�[�g => �J�o���b�W���|�[�g �ł��\����

% Copyright 2014 The MathWorks, Inc.
