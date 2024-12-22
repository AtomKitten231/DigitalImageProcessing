%% LBP特征提取函数
% 该函数从输入图像中提取局部二值模式（LBP）特征，并计算其直方图。
% LBP特征用于描述图像纹理信息，常用于图像分类与识别任务。
%
% @param img 输入的图像（可以是灰度图像或彩色图像）。
% @return lbpHist LBP特征的归一化直方图。
function lbpHist = extractLBPFeaturesManual(img)
    % 如果输入是二值图像或逻辑值图像，则转换为灰度图
    if islogical(img) || numel(unique(img)) == 2
        grayImg = uint8(img) * 255;  % 将二值图像转换为灰度图像
    else
        grayImg = im2gray(img);  % 将彩色图像转换为灰度图像
    end
    
    lbpImg = zeros(size(grayImg));  % 初始化LBP图像
    [rows, cols] = size(grayImg);  % 获取图像的尺寸
    paddedImg = padarray(grayImg, [1, 1], 'symmetric');  % 对图像进行边界填充，避免边界效应

    % 遍历图像的每个像素，计算LBP值
    for i = 2:rows+1
        for j = 2:cols+1
            patch = paddedImg(i-1:i+1, j-1:j+1);  % 提取3x3邻域
            center = patch(2, 2);  % 获取邻域中心像素值
            binaryPattern = (patch >= center);  % 计算二值模式
            binaryPattern(2, 2) = 0;  % 将中心像素设为0，避免重复计算
            weights = [1, 2, 4; 128, 0, 8; 64, 32, 16];  % LBP权重矩阵
            lbpImg(i-1, j-1) = sum(binaryPattern(:) .* weights(:));  % 计算LBP值
        end
    end

    % 计算LBP图像的直方图，并进行归一化
    lbpHist = histcounts(lbpImg(:), 0:256, 'Normalization', 'probability');
end
