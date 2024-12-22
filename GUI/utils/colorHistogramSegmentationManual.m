%% 颜色直方图分割函数
% 该函数根据给定的颜色范围对图像进行分割，提取目标区域并保存为二值图像。
%
% @param img 输入的彩色图像。
% @param targetRange 目标区域的颜色范围，包含两个元素：[minHue, maxHue]。
% @param savePath 可选参数，保存二值图像的路径。
% @return binaryImg 提取后的二值图像。
function binaryImg = colorHistogramSegmentationManual(img, targetRange, savePath)
    hsvImg = rgb2hsvManual(img);  % 将RGB图像转换为HSV图像
    hChannel = hsvImg(:, :, 1);  % 提取色调（H）通道
    % 根据色调范围提取目标区域
    binaryImg = (hChannel >= targetRange(1)) & (hChannel <= targetRange(2));  
    % 保存二值图像（如果提供保存路径）
    if nargin > 2 && ~isempty(savePath)
        imwrite(binaryImg, savePath);
        disp(['目标区域保存至：' savePath]);
    end
end

%% RGB转HSV函数
% 该函数将RGB图像转换为HSV图像。
%
% @param img 输入的RGB图像。
% @return hsvImg 转换后的HSV图像。
function hsvImg = rgb2hsvManual(img)
    img = double(img) / 255;  % 将图像值归一化到[0, 1]
    r = img(:, :, 1);
    g = img(:, :, 2);
    b = img(:, :, 3);
    maxVal = max(img, [], 3);  % 获取每个像素的最大值
    minVal = min(img, [], 3);  % 获取每个像素的最小值
    delta = maxVal - minVal;  % 计算最大值与最小值的差
    h = zeros(size(maxVal));  % 初始化色调（H）通道
    % 计算色调（H）通道
    h(delta ~= 0 & maxVal == r) = mod((g(delta ~= 0 & maxVal == r) - b(delta ~= 0 & maxVal == r)) ./ delta(delta ~= 0 & maxVal == r), 6);
    h(delta ~= 0 & maxVal == g) = ((b(delta ~= 0 & maxVal == g) - r(delta ~= 0 & maxVal == g)) ./ delta(delta ~= 0 & maxVal == g)) + 2;
    h(delta ~= 0 & maxVal == b) = ((r(delta ~= 0 & maxVal == b) - g(delta ~= 0 & maxVal == b)) ./ delta(delta ~= 0 & maxVal == b)) + 4;
    h = h / 6;  % 归一化色调到[0, 1]范围
    h(h < 0) = h(h < 0) + 1;  % 确保色调为正值
    s = delta ./ maxVal;  % 计算饱和度（S）通道
    s(maxVal == 0) = 0;  % 如果最大值为0，饱和度为0
    v = maxVal;  % 计算亮度（V）通道
    hsvImg = cat(3, h, s, v);  % 合并H、S、V三个通道
end
