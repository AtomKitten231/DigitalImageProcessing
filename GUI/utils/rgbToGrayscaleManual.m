%% RGB转灰度图像函数
% 该函数将输入的RGB图像转换为灰度图像。使用加权平均法根据RGB值计算灰度值。
%
% @param img 输入的RGB图像。
% @return grayscaleImg 转换后的灰度图像。
function grayscaleImg = rgbToGrayscaleManual(img)
    if size(img, 3) ~= 3
        error('输入的图像必须是 RGB 图像');  % 输入图像必须为RGB图像
    end
    R = img(:, :, 1);  % 获取图像的红色通道
    G = img(:, :, 2);  % 获取图像的绿色通道
    B = img(:, :, 3);  % 获取图像的蓝色通道
    % 使用加权平均法计算灰度值
    grayscaleImg = uint8(0.2989 * double(R) + 0.5870 * double(G) + 0.1140 * double(B));
end
