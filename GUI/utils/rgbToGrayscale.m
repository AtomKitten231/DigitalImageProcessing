function grayscaleImg = rgbToGrayscale(img)
    if size(img, 3) ~= 3
        error('输入的图像必须是 RGB 图像');
    end
    R = img(:, :, 1);
    G = img(:, :, 2);
    B = img(:, :, 3);
    grayscaleImg = uint8(0.2989 * double(R) + 0.5870 * double(G) + 0.1140 * double(B));
end
