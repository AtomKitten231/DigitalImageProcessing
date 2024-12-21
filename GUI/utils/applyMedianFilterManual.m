function filteredImg = applyMedianFilterManual(noisyImg)
    grayImg = rgb2gray(noisyImg);
    [rows, cols] = size(grayImg);
    filteredImg = zeros(rows, cols, 'uint8');
    padImg = padarray(grayImg, [1, 1], 'replicate');
    for i = 2:rows+1
        for j = 2:cols+1
            window = padImg(i-1:i+1, j-1:j+1);
            filteredImg(i-1, j-1) = median(window(:));
        end
    end
end
