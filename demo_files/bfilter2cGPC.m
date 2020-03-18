function bimg = bfilter2cGPC(img)
    w = 5; % �J�[�l���T�C�Y / 2
    sigma_d = 3; % large spatial standard deviation(�K�E�V�A���t�B���^�΍�)
    sigma_r = 0.1; % intensity standard deviation(�P�x���̐���)
    norm = 1 / (2*sigma_r^2);
    
    % Compute Gaussian domain weights
    [X,Y] = meshgrid(-w:w,-w:w);
    G = exp(-(X.^2+Y.^2)/(2*sigma_d^2));
    
    coder.gpu.kernelfun();
    % Apply Bilateral Filter
    r = bilateral_kernel(img(:,:,1), G, norm);
    g = bilateral_kernel(img(:,:,2), G, norm);
    b = bilateral_kernel(img(:,:,3), G, norm);
    
    bimg = cat(3, r, g, b);
end
% Copyright 2018 The MathWorks, Inc.