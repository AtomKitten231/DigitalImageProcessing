%% 直方图匹配函数
% 该函数对源图像进行直方图匹配，使其直方图与目标图像的直方图一致。
% 通过查找源图像和目标图像的累计分布函数（CDF），计算灰度级之间的映射关系。
%
% @param srcImg 输入的源图像（灰度图像）。
% @param targetImg 输入的目标图像（灰度图像）。
% @return matchedImg 匹配后的图像。
function matchedImg = histogramMatchingManual(srcImg, targetImg)
    if size(srcImg, 3) == 3 || size(targetImg, 3) == 3
        error('输入的图像必须是灰度图像');  % 输入图像必须为灰度图像
    end

    % 计算源图像的直方图
    [rows, cols] = size(srcImg);
    srcHistCounts = zeros(256, 1);
    for i = 1:rows
        for j = 1:cols
            srcHistCounts(srcImg(i, j) + 1) = srcHistCounts(srcImg(i, j) + 1) + 1;
        end
    end

    % 计算目标图像的直方图
    [targetRows, targetCols] = size(targetImg);
    targetHistCounts = zeros(256, 1);
    for i = 1:targetRows
        for j = 1:targetCols
            targetHistCounts(targetImg(i, j) + 1) = targetHistCounts(targetImg(i, j) + 1) + 1;
        end
    end

    % 计算源图像和目标图像的累计分布函数（CDF）
    srcCDF = cumsum(srcHistCounts) / sum(srcHistCounts);
    targetCDF = cumsum(targetHistCounts) / sum(targetHistCounts);

    % 创建查找表（LUT）用于映射源图像的灰度级到目标图像的灰度级
    LUT = zeros(256, 1, 'uint8');
    for srcGray = 0:255
        [~, closestIdx] = min(abs(targetCDF - srcCDF(srcGray + 1)));  % 找到与目标CDF最接近的源灰度值
        LUT(srcGray + 1) = closestIdx - 1;
    end

    % 应用LUT进行直方图匹配
    matchedImg = zeros(size(srcImg), 'uint8');
    for i = 1:rows
        for j = 1:cols
            matchedImg(i, j) = LUT(srcImg(i, j) + 1);  % 根据LUT映射灰度值
        end
    end
end
