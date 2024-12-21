function matchedImg = histogramMatching(srcImg, targetImg)
    if size(srcImg, 3) == 3 || size(targetImg, 3) == 3
        error('输入的图像必须是灰度图像');
    end
    [rows, cols] = size(srcImg);
    srcHistCounts = zeros(256, 1);
    for i = 1:rows
        for j = 1:cols
            srcHistCounts(srcImg(i, j) + 1) = srcHistCounts(srcImg(i, j) + 1) + 1;
        end
    end
    [targetRows, targetCols] = size(targetImg);
    targetHistCounts = zeros(256, 1);
    for i = 1:targetRows
        for j = 1:targetCols
            targetHistCounts(targetImg(i, j) + 1) = targetHistCounts(targetImg(i, j) + 1) + 1;
        end
    end
    srcCDF = cumsum(srcHistCounts) / sum(srcHistCounts);
    targetCDF = cumsum(targetHistCounts) / sum(targetHistCounts);
    LUT = zeros(256, 1, 'uint8');
    for srcGray = 0:255
        [~, closestIdx] = min(abs(targetCDF - srcCDF(srcGray + 1)));
        LUT(srcGray + 1) = closestIdx - 1;
    end
    matchedImg = zeros(size(srcImg), 'uint8');
    for i = 1:rows
        for j = 1:cols
            matchedImg(i, j) = LUT(srcImg(i, j) + 1);
        end
    end
end
