%% 拉普拉斯边缘检测函数
% 该函数使用拉普拉斯算子对输入图像进行边缘检测。
% 拉普拉斯算子通过计算图像的二阶导数来检测边缘。
%
% @param img 输入的彩色图像或灰度图像。
% @return edgeImg 检测到的边缘图像。
function edgeImg = laplacianEdgeManual(img)
    grayImg = double(rgb2gray(img));  % 将输入图像转换为灰度图并转换为double类型
    kernel = [0 -1 0; -1 4 -1; 0 -1 0];  % 定义拉普拉斯算子核
    edgeImg = conv2(grayImg, kernel, 'same');  % 使用卷积运算应用拉普拉斯算子
    edgeImg = abs(edgeImg);  % 取绝对值，保留边缘的强度
    edgeImg = mat2gray(edgeImg);  % 将结果归一化到[0, 1]范围
end
