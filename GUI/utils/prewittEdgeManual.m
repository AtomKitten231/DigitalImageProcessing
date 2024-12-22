%% Prewitt边缘检测函数
% 该函数使用Prewitt算子对输入图像进行边缘检测。通过对图像应用Prewitt算子的X和Y方向卷积，计算图像的梯度。
%
% @param img 输入的彩色图像或灰度图像。
% @return edgeImg 检测到的边缘图像。
function edgeImg = prewittEdgeManual(img)
    grayImg = double(rgb2gray(img));  % 将输入图像转换为灰度图并转换为double类型
    kernelX = [-1 0 1; -1 0 1; -1 0 1];  % Prewitt算子X方向核
    kernelY = [-1 -1 -1; 0 0 0; 1 1 1];  % Prewitt算子Y方向核
    edgeX = conv2(grayImg, kernelX, 'same');  % 对图像应用X方向卷积
    edgeY = conv2(grayImg, kernelY, 'same');  % 对图像应用Y方向卷积
    edgeImg = sqrt(edgeX.^2 + edgeY.^2);  % 计算梯度幅值
    edgeImg = mat2gray(edgeImg);  % 将结果归一化到[0, 1]范围
end
