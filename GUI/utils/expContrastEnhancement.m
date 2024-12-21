function enhancedImg = expContrastEnhancement(img)
    if size(img, 3) == 3
        error('输入图像必须是灰度图像');
    end
    img = double(img);
    c = 255 / (255 ^ 0.5);
    enhancedImg = c * (img .^ 0.5);
    enhancedImg = uint8(enhancedImg);
end
