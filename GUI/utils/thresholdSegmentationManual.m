%% 阈值分割函数
% 该函数使用Otsu算法进行图像的阈值分割。根据图像的灰度直方图，计算最佳的分割阈值。
% 分割后的图像为二值图像，可以选择保存分割结果。
%
% @param img 输入的彩色图像。
% @param savePath 可选参数，指定保存二值图像的路径。
% @return binaryImg 分割后的二值图像。
function binaryImg = thresholdSegmentationManual(img, savePath)
    grayImg = rgb2grayManual(img);  % 将输入图像转换为灰度图
    [rows, cols] = size(grayImg);  % 获取图像的尺寸
    histogram = imhistManual(grayImg);  % 计算图像的灰度直方图
    totalPixels = rows * cols;  % 计算图像的总像素数
    currentMax = 0;  % 初始化最大类间方差
    threshold = 0;  % 初始化最佳阈值
    
    % 遍历所有可能的阈值，使用Otsu算法寻找最佳阈值
    for t = 1:256
        w0 = sum(histogram(1:t)) / totalPixels;  % 计算类0的权重
        w1 = sum(histogram(t+1:end)) / totalPixels;  % 计算类1的权重
        
        if w0 == 0 || w1 == 0
            continue;  % 如果某个类的权重为0，跳过
        end
        
        mean0 = sum((0:t-1) .* histogram(1:t)) / sum(histogram(1:t));  % 计算类0的均值
        mean1 = sum((t:255) .* histogram(t+1:end)) / sum(histogram(t+1:end));  % 计算类1的均值
        
        betweenVar = w0 * w1 * (mean0 - mean1)^2;  % 计算类间方差
        
        if betweenVar > currentMax
            currentMax = betweenVar;  % 更新最大类间方差
            threshold = t - 1;  % 更新最佳阈值
        end
    end
    
    binaryImg = grayImg > threshold;  % 根据最佳阈值进行分割
    
    % 如果提供了保存路径，保存分割结果
    if nargin > 1 && ~isempty(savePath)
        imwrite(binaryImg, savePath);
        disp(['目标区域保存至：' savePath]);
    end
end

%% RGB转灰度图像函数
% 该函数将RGB图像转换为灰度图像，使用加权平均法根据RGB值计算灰度值。
%
% @param img 输入的RGB图像。
% @return grayImg 转换后的灰度图像。
function grayImg = rgb2grayManual(img)
    grayImg = 0.2989 * img(:, :, 1) + 0.5870 * img(:, :, 2) + 0.1140 * img(:, :, 3);  % RGB转灰度
    grayImg = uint8(grayImg);  % 将结果转换为uint8类型
end

%% 自定义直方图计算函数
% 该函数计算输入图像的灰度直方图。
%
% @param grayImg 输入的灰度图像。
% @return histogram 计算得到的灰度直方图。
function histogram = imhistManual(grayImg)
    histogram = zeros(1, 256);  % 初始化直方图
    for i = 1:numel(grayImg)
        value = grayImg(i) + 1;  % 获取像素值并转换为直方图索引
        histogram(value) = histogram(value) + 1;  % 更新直方图计数
    end
end
