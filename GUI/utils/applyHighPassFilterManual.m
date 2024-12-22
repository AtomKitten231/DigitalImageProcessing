%% 高通滤波函数
% 该函数应用高通滤波器对图像进行滤波处理，使用频率域滤波方法。
%
% @param noisyImg 含噪声的图像。
% @param radius 高通滤波器的截止半径。
% @return filteredImg 滤波后的图像。
function filteredImg = applyHighPassFilterManual(noisyImg, radius)
    grayImg = im2double(rgb2gray(noisyImg));  % 转换为灰度图像并规范化为[0, 1]
    fftImg = fft2(grayImg);  % 对图像进行2D傅里叶变换
    fftShifted = fftshift(fftImg);  % 将零频率成分移到频谱的中心
    [rows, cols] = size(fftShifted);  % 获取图像的尺寸
    centerX = round(rows / 2);  % 计算图像中心X坐标
    centerY = round(cols / 2);  % 计算图像中心Y坐标
    [X, Y] = meshgrid(1:cols, 1:rows);  % 创建频率网格
    % 构建高通滤波掩码，远离中心的区域为1，靠近中心的区域为0
    mask = ((X - centerY).^2 + (Y - centerX).^2) > radius^2;
    mask = double(mask);  % 转换为double类型
    filteredFFT = fftShifted .* mask;  % 应用掩码进行滤波
    filteredImg = real(ifft2(ifftshift(filteredFFT)));  % 对滤波后的频谱进行逆傅里叶变换
    filteredImg = mat2gray(filteredImg);  % 将图像归一化到[0, 1]范围
end
