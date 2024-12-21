function equalizedImg = histogramEqualization(img)
    if size(img, 3) == 3
        error('输入图像必须是灰度图像');
    end
    [rows, cols] = size(img);
    numPixels = rows * cols;
    histCounts = zeros(256, 1);
    for i = 1:rows
        for j = 1:cols
            histCounts(img(i, j) + 1) = histCounts(img(i, j) + 1) + 1;
        end
    end
    cdf = cumsum(histCounts) / numPixels;
    equalizedLUT = uint8(cdf * 255);
    equalizedImg = zeros(size(img), 'uint8');
    for i = 1:rows
        for j = 1:cols
            equalizedImg(i, j) = equalizedLUT(img(i, j) + 1);
        end
    end
end
