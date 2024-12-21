function edgeImg = robertEdge(img)
    grayImg = double(rgb2gray(img));
    kernelX = [1 0; 0 -1];
    kernelY = [0 1; -1 0];
    edgeX = conv2(grayImg, kernelX, 'same');
    edgeY = conv2(grayImg, kernelY, 'same');
    edgeImg = sqrt(edgeX.^2 + edgeY.^2);
    edgeImg = mat2gray(edgeImg);
end
