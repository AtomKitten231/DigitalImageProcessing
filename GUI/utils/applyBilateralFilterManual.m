function filteredImg = applyBilateralFilterManual(noisyImg, sigmaSpatial, sigmaRange)
    grayImg = im2double(rgb2gray(noisyImg));
    [rows, cols] = size(grayImg);
    filteredImg = zeros(rows, cols);
    halfWindow = ceil(3 * sigmaSpatial);
    [X, Y] = meshgrid(-halfWindow:halfWindow, -halfWindow:halfWindow);
    spatialKernel = exp(-(X.^2 + Y.^2) / (2 * sigmaSpatial^2));
    for i = 1:rows
        for j = 1:cols
            iMin = max(i - halfWindow, 1);
            iMax = min(i + halfWindow, rows);
            jMin = max(j - halfWindow, 1);
            jMax = min(j + halfWindow, cols);
            region = grayImg(iMin:iMax, jMin:jMax);
            intensityKernel = exp(-(region - grayImg(i, j)).^2 / (2 * sigmaRange^2));
            combinedKernel = spatialKernel((iMin:iMax)-i+halfWindow+1, (jMin:jMax)-j+halfWindow+1) .* intensityKernel;
            filteredImg(i, j) = sum(region(:) .* combinedKernel(:)) / sum(combinedKernel(:));
        end
    end
    filteredImg = im2uint8(filteredImg);
end
