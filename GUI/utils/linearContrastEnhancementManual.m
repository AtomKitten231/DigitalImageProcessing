%% 线性对比度增强函数
% 该函数对输入的灰度图像进行线性对比度增强。通过将像素值重新映射到新的范围来增强图像对比度。
% 输入图像必须是灰度图像。
%
% @param img 输入的灰度图像。
% @return enhancedImg 增强后的图像。
function enhancedImg = linearContrastEnhancementManual(img)
    if size(img, 3) == 3
        error('输入图像必须是灰度图像');  % 输入必须为灰度图像
    end
    img = double(img);  % 将图像转换为double类型以进行计算
    minVal = min(img(:));  % 获取图像的最小像素值
    maxVal = max(img(:));  % 获取图像的最大像素值
    enhancedImg = (img - minVal) / (maxVal - minVal) * 255;  % 进行线性对比度增强
    enhancedImg = uint8(enhancedImg);  % 将结果转换回uint8类型
end
