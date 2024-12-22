%% 中值滤波函数
% 该函数应用中值滤波器对图像进行滤波处理，使用3x3邻域进行中值滤波。
%
% @param noisyImg 含噪声的图像。
% @return filteredImg 滤波后的图像。
function filteredImg = applyMedianFilterManual(noisyImg)
    grayImg = rgb2gray(noisyImg);  % 转换为灰度图像
    [rows, cols] = size(grayImg);  % 获取图像的尺寸
    filteredImg = zeros(rows, cols, 'uint8');  % 初始化滤波结果图像
    padImg = padarray(grayImg, [1, 1], 'replicate');  % 填充图像边界
    % 遍历图像的每个像素，进行中值滤波
    for i = 2:rows+1
        for j = 2:cols+1
            window = padImg(i-1:i+1, j-1:j+1);  % 提取3x3邻域
            filteredImg(i-1, j-1) = median(window(:));  % 对邻域内的像素值进行中值滤波
        end
    end
end
