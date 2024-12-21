function binaryImg = colorHistogramSegmentationManual(img, targetRange, savePath)
    hsvImg = rgb2hsvManual(img);
    hChannel = hsvImg(:, :, 1);
    binaryImg = (hChannel >= targetRange(1)) & (hChannel <= targetRange(2));
    if nargin > 2 && ~isempty(savePath)
        imwrite(binaryImg, savePath);
        disp(['目标区域保存至：' savePath]);
    end
end
function hsvImg = rgb2hsvManual(img)
    img = double(img) / 255;
    r = img(:, :, 1);
    g = img(:, :, 2);
    b = img(:, :, 3);
    maxVal = max(img, [], 3);
    minVal = min(img, [], 3);
    delta = maxVal - minVal;
    h = zeros(size(maxVal));
    h(delta ~= 0 & maxVal == r) = mod((g(delta ~= 0 & maxVal == r) - b(delta ~= 0 & maxVal == r)) ./ delta(delta ~= 0 & maxVal == r), 6);
    h(delta ~= 0 & maxVal == g) = ((b(delta ~= 0 & maxVal == g) - r(delta ~= 0 & maxVal == g)) ./ delta(delta ~= 0 & maxVal == g)) + 2;
    h(delta ~= 0 & maxVal == b) = ((r(delta ~= 0 & maxVal == b) - g(delta ~= 0 & maxVal == b)) ./ delta(delta ~= 0 & maxVal == b)) + 4;
    h = h / 6;
    h(h < 0) = h(h < 0) + 1;
    s = delta ./ maxVal;
    s(maxVal == 0) = 0;
    v = maxVal;
    hsvImg = cat(3, h, s, v);
end
