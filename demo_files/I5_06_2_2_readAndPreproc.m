function Iout = I5_06_2_2_readAndPreproc( inFilename )
    % �摜�̓Ǎ���
    I = imread(inFilename);
    
    % �O���[�X�P�[���̏ꍇ��RGB�֕ϊ�
    if ismatrix(I)          % 1������������2�����̏ꍇ�ɐ^
        I = repmat(I, [1,1,3]);
    end
    
    % �摜�̏c�����A227x227�s�N�Z���� ���T�C�Y �i�c�����ۂj
    if size(I, 1) > size(I, 2)
      I1 = imresize(I, [227, NaN]);
      Iout = padarray(I1, [0, 227-size(I1, 2)], 0, 'pre');
    else
      I1 = imresize(I, [NaN, 227]);
      Iout = padarray(I1, [227-size(I1, 1), 0], 0, 'pre');
    end

end


% Copyright 2018 The MathWorks, Inc.