%% Sobel边缘检测函数
% 该函数使用Sobel算子对输入图像进行边缘检测。通过计算图像的X和Y方向梯度，得到边缘图像。
% 如果提供了保存路径，检测结果将被保存为图像。
%
% @param img 输入的彩色图像。
% @param savePath 可选参数，指定保存边缘图像的路径。
% @return edgeImg 检测到的边缘图像。
function edgeImg = sobelEdgeDetectionManual(img, savePath)
    grayImg = rgb2grayManual(img);  % 将输入图像转换为灰度图
    sobelX = [-1 0 1; -2 0 2; -1 0 1];  % Sobel算子X方向核
    sobelY = [-1 -2 -1; 0 0 0; 1 2 1];  % Sobel算子Y方向核
    edgeX = conv2Manual(double(grayImg), sobelX);  % 应用Sobel算子X方向卷积
    edgeY = conv2Manual(double(grayImg), sobelY);  % 应用Sobel算子Y方向卷积
    edgeImg = sqrt(edgeX.^2 + edgeY.^2);  % 计算梯度幅值
    edgeImg = mat2gray(edgeImg);  % 将结果归一化到[0, 1]范围
    % 如果提供了保存路径，则保存结果图像
    if nargin > 1 && ~isempty(savePath)
        imwrite(edgeImg, savePath);
        disp(['目标区域保存至：' savePath]);
    end
end

%% 自定义卷积函数
% 该函数对图像应用卷积操作，使用指定的卷积核进行计算。
%
% @param img 输入的灰度图像。
% @param kernel 卷积核。
% @return result 卷积后的图像。
function result = conv2Manual(img, kernel)
    [rows, cols] = size(img);  % 获取图像尺寸
    [kRows, kCols] = size(kernel);  % 获取卷积核尺寸
    padRow = floor(kRows / 2);  % 计算填充的行数
    padCol = floor(kCols / 2);  % 计算填充的列数
    paddedImg = padarray(img, [padRow, padCol], 'replicate');  % 对图像进行填充
    result = zeros(size(img));  % 初始化结果图像
    % 执行卷积操作
    for i = 1:rows
        for j = 1:cols
            region = paddedImg(i:i+kRows-1, j:j+kCols-1);  % 提取邻域区域
            result(i, j) = sum(region(:) .* kernel(:));  % 计算卷积结果
        end
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
