%% 图像缩放函数
% 该函数根据给定的缩放比例对输入图像进行缩放。可以增大或缩小图像。
%
% @param img 输入的图像，可以是彩色或灰度图像。
% @param scaleFactor 缩放比例，必须大于0。
% @return scaledImg 缩放后的图像。
function scaledImg = imageScalingManual(img, scaleFactor)
    if scaleFactor <= 0
        error('缩放比例必须大于 0');  % 确保缩放比例大于0
    end
    [rows, cols, channels] = size(img);  % 获取图像的尺寸
    newRows = round(rows * scaleFactor);  % 计算缩放后的行数
    newCols = round(cols * scaleFactor);  % 计算缩放后的列数
    scaledImg = zeros(newRows, newCols, channels, 'uint8');  % 初始化缩放后的图像

    % 遍历目标图像的每个像素，计算对应原图像的像素值
    for i = 1:newRows
        for j = 1:newCols
            origX = i / scaleFactor;  % 计算原图像中对应的X坐标
            origY = j / scaleFactor;  % 计算原图像中对应的Y坐标
            % 确保坐标在有效范围内
            x1 = min(max(round(origX), 1), rows);
            y1 = min(max(round(origY), 1), cols);
            scaledImg(i, j, :) = img(x1, y1, :);  % 填充缩放后的图像
        end
    end
end
