function binaryImg = thresholdSegmentationManual(img)
    grayImg = rgb2grayManual(img);
    [rows, cols] = size(grayImg);
    histogram = imhistManual(grayImg);
    totalPixels = rows * cols;
    currentMax = 0;
    threshold = 0;
    for t = 1:256
        w0 = sum(histogram(1:t)) / totalPixels;
        w1 = sum(histogram(t+1:end)) / totalPixels;
        if w0 == 0 || w1 == 0
            continue;
        end
        mean0 = sum((0:t-1) .* histogram(1:t)) / sum(histogram(1:t));
        mean1 = sum((t:255) .* histogram(t+1:end)) / sum(histogram(t+1:end));
        betweenVar = w0 * w1 * (mean0 - mean1)^2;
        if betweenVar > currentMax
            currentMax = betweenVar;
            threshold = t - 1;
        end
    end
    binaryImg = grayImg > threshold;
end
function grayImg = rgb2grayManual(img)
    grayImg = 0.2989 * img(:, :, 1) + 0.5870 * img(:, :, 2) + 0.1140 * img(:, :, 3);
    grayImg = uint8(grayImg);
end
function histogram = imhistManual(grayImg)
    histogram = zeros(1, 256);
    for i = 1:numel(grayImg)
        value = grayImg(i) + 1;
        histogram(value) = histogram(value) + 1;
    end
end
