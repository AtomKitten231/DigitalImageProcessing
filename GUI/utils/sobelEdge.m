function edgeImg = sobelEdge(img)
    grayImg = double(rgb2gray(img));
    kernelX = [-1 0 1; -2 0 2; -1 0 1];
    kernelY = [-1 -2 -1; 0 0 0; 1 2 1];
    edgeX = conv2(grayImg, kernelX, 'same');
    edgeY = conv2(grayImg, kernelY, 'same');
    edgeImg = sqrt(edgeX.^2 + edgeY.^2);
    edgeImg = mat2gray(edgeImg);
end
