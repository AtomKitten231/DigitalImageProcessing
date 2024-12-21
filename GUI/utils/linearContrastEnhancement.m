function enhancedImg = linearContrastEnhancement(img)
    if size(img, 3) == 3
        error('输入图像必须是灰度图像');
    end
    img = double(img);
    minVal = min(img(:));
    maxVal = max(img(:));
    enhancedImg = (img - minVal) / (maxVal - minVal) * 255;
    enhancedImg = uint8(enhancedImg);
end
