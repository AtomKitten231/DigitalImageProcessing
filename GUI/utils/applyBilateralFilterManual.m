%% 双边滤波函数
% 该函数应用双边滤波对图像进行滤波处理，使用空间域和强度域的双边滤波核。
%
% @param noisyImg 含噪声的图像。
% @param sigmaSpatial 空间域标准差，用于生成空间核。
% @param sigmaRange 强度域标准差，用于生成强度核。
% @return filteredImg 滤波后的图像。
function filteredImg = applyBilateralFilterManual(noisyImg, sigmaSpatial, sigmaRange)
    grayImg = im2double(rgb2gray(noisyImg));  % 转换为灰度图像并规范化为[0, 1]
    [rows, cols] = size(grayImg);  % 获取图像的尺寸
    filteredImg = zeros(rows, cols);  % 初始化滤波结果图像
    halfWindow = ceil(3 * sigmaSpatial);  % 窗口大小根据空间标准差确定
    [X, Y] = meshgrid(-halfWindow:halfWindow, -halfWindow:halfWindow);  % 创建空间网格
    spatialKernel = exp(-(X.^2 + Y.^2) / (2 * sigmaSpatial^2));  % 计算空间域核
    
    % 遍历图像的每个像素
    for i = 1:rows
        for j = 1:cols
            % 定义当前像素的邻域范围
            iMin = max(i - halfWindow, 1);
            iMax = min(i + halfWindow, rows);
            jMin = max(j - halfWindow, 1);
            jMax = min(j + halfWindow, cols);
            
            % 提取邻域区域
            region = grayImg(iMin:iMax, jMin:jMax);
            % 计算强度域核
            intensityKernel = exp(-(region - grayImg(i, j)).^2 / (2 * sigmaRange^2));
            % 计算组合核
            combinedKernel = spatialKernel((iMin:iMax)-i+halfWindow+1, (jMin:jMax)-j+halfWindow+1) .* intensityKernel;
            % 应用双边滤波
            filteredImg(i, j) = sum(region(:) .* combinedKernel(:)) / sum(combinedKernel(:));
        end
    end
    filteredImg = im2uint8(filteredImg);  % 转换回0-255范围的整数图像
end
