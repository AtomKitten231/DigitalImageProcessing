function enhancedImg = logContrastEnhancement(img)
    if size(img, 3) == 3
        error('输入图像必须是灰度图像');
    end
    img = double(img);
    c = 255 / log(1 + max(img(:)));
    enhancedImg = c * log(1 + img);
    enhancedImg = uint8(enhancedImg);
end
