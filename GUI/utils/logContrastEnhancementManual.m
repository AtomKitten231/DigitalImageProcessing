%% 对数对比度增强函数
% 该函数对输入的灰度图像进行对数对比度增强。通过应用对数变换增强图像的低对比度区域。
% 输入图像必须是灰度图像。
%
% @param img 输入的灰度图像。
% @return enhancedImg 增强后的图像。
function enhancedImg = logContrastEnhancementManual(img)
    if size(img, 3) == 3
        error('输入图像必须是灰度图像');  % 输入必须为灰度图像
    end
    img = double(img);  % 将图像转换为double类型以进行计算
    c = 255 / log(1 + max(img(:)));  % 计算对数变换的常数
    enhancedImg = c * log(1 + img);  % 对图像应用对数变换
    enhancedImg = uint8(enhancedImg);  % 将结果转换回uint8类型
end
