%% 指数对比度增强函数
% 该函数对灰度图像应用指数对比度增强。
% 输入图像必须是灰度图像，增强后图像的对比度将增强。
%
% @param img 输入的灰度图像。
% @return enhancedImg 增强后的图像。
function enhancedImg = expContrastEnhancementManual(img)
    if size(img, 3) == 3
        error('输入图像必须是灰度图像');  % 输入必须为灰度图像
    end
    img = double(img);  % 转换为double类型以进行计算
    c = 255 / (255 ^ 0.5);  % 计算常数c
    enhancedImg = c * (img .^ 0.5);  % 应用指数对比度增强
    enhancedImg = uint8(enhancedImg);  % 将结果转换回uint8类型
end
