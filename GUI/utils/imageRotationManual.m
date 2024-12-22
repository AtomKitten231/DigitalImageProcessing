%% 图像旋转函数
% 该函数根据给定的角度对输入图像进行旋转，旋转中心为图像的中心点。
% 输入角度为度数，函数内部将角度转换为弧度进行计算。
%
% @param img 输入的图像，可以是彩色或灰度图像。
% @param angle 旋转角度，单位为度。
% @return rotatedImg 旋转后的图像。
function rotatedImg = imageRotationManual(img, angle)
    theta = deg2rad(angle);  % 将角度转换为弧度
    [rows, cols, channels] = size(img);  % 获取图像的尺寸
    centerX = ceil(rows / 2);  % 计算图像中心X坐标
    centerY = ceil(cols / 2);  % 计算图像中心Y坐标
    rotatedImg = zeros(rows, cols, channels, 'uint8');  % 初始化旋转后的图像

    % 遍历图像的每个像素
    for i = 1:rows
        for j = 1:cols
            for k = 1:channels
                % 计算当前像素旋转后的坐标
                x = (i - centerX) * cos(theta) - (j - centerY) * sin(theta) + centerX;
                y = (i - centerX) * sin(theta) + (j - centerY) * cos(theta) + centerY;
                % 检查旋转后的坐标是否在图像范围内
                if x >= 1 && x <= rows && y >= 1 && y <= cols
                    % 将旋转后的坐标四舍五入并确保在有效范围内
                    x1 = min(max(round(x), 1), rows);
                    y1 = min(max(round(y), 1), cols);
                    rotatedImg(i, j, k) = img(x1, y1, k);  % 填充旋转后的图像
                end
            end
        end
    end
end
