function edgeImg = laplacianEdge(img)
    grayImg = double(rgb2gray(img));
    kernel = [0 -1 0; -1 4 -1; 0 -1 0];
    edgeImg = conv2(grayImg, kernel, 'same');
    edgeImg = abs(edgeImg);
    edgeImg = mat2gray(edgeImg);
end
