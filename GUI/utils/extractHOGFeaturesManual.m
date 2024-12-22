%% HOG特征提取函数
% 该函数从输入图像中提取HOG（方向梯度直方图）特征。
% 输入图像可以是灰度图像或彩色图像。函数会计算每个小块的梯度方向直方图，并进行归一化。
%
% @param img 输入的图像（可以是彩色图像或灰度图像）。
% @return hogFeatures 提取的HOG特征，作为一个向量。
function hogFeatures = extractHOGFeaturesManual(img)
    % 如果输入是二值图像或逻辑值图像，则转换为标准灰度图
    if islogical(img) || numel(unique(img)) == 2
        grayImg = im2double(uint8(img) * 255);  % 将二值图像转换为灰度图像
    else
        grayImg = im2double(im2gray(img));  % 将彩色图像转换为灰度图像
    end
    
    [rows, cols] = size(grayImg);  % 获取图像的尺寸
    [gradX, gradY] = imgradientxy(grayImg);  % 计算图像的梯度（X和Y方向）
    [gradientMag, gradientDir] = imgradient(gradX, gradY);  % 计算梯度的大小和方向
    cellSize = 8;  % 每个单元格的大小
    numBins = 9;  % 梯度方向的数量
    binEdges = linspace(0, 180, numBins+1);  % 梯度方向的边界（0到180度）
    hogFeatures = [];  % 初始化HOG特征向量

    % 遍历图像的每个小块
    for i = 1:cellSize:rows-cellSize+1
        for j = 1:cellSize:cols-cellSize+1
            % 获取当前小块的梯度大小和方向
            blockMag = gradientMag(i:i+cellSize-1, j:j+cellSize-1);
            blockDir = gradientDir(i:i+cellSize-1, j:j+cellSize-1);
            blockDir = mod(blockDir, 180);  % 保证梯度方向在[0, 180)范围内
            hist = zeros(1, numBins);  % 初始化直方图

            % 计算每个方向区间内的梯度大小总和
            for bin = 1:numBins
                binMask = (blockDir >= binEdges(bin) & blockDir < binEdges(bin+1));
                hist(bin) = sum(blockMag(binMask));
            end
            hist = hist / sum(hist);  % 对直方图进行归一化
            hogFeatures = [hogFeatures, hist];  % 将当前小块的特征添加到特征向量中
        end
    end
end
