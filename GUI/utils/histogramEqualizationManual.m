%% 直方图均衡化函数
% 该函数对灰度图像进行直方图均衡化，增强图像的对比度。
% 通过计算累计分布函数（CDF），映射输入灰度值到输出灰度值。
%
% @param img 输入的灰度图像。
% @return equalizedImg 均衡化后的图像。
function equalizedImg = histogramEqualizationManual(img)
    if size(img, 3) == 3
        error('输入图像必须是灰度图像');  % 输入必须为灰度图像
    end
    [rows, cols] = size(img);  % 获取图像的尺寸
    numPixels = rows * cols;  % 计算图像的总像素数
    histCounts = zeros(256, 1);  % 初始化灰度级别的计数

    % 计算图像的灰度直方图
    for i = 1:rows
        for j = 1:cols
            histCounts(img(i, j) + 1) = histCounts(img(i, j) + 1) + 1;
        end
    end

    % 计算累计分布函数（CDF）
    cdf = cumsum(histCounts) / numPixels;
    equalizedLUT = uint8(cdf * 255);  % 计算均衡化的查找表（LUT）

    % 应用均衡化后的查找表到图像
    equalizedImg = zeros(size(img), 'uint8');
    for i = 1:rows
        for j = 1:cols
            equalizedImg(i, j) = equalizedLUT(img(i, j) + 1);
        end
    end
end
