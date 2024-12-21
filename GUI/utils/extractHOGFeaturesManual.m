function hogFeatures = extractHOGFeaturesManual(img)
    if islogical(img) || numel(unique(img)) == 2
        grayImg = im2double(uint8(img) * 255);
    else
        grayImg = im2double(im2gray(img));
    end
    [rows, cols] = size(grayImg);
    [gradX, gradY] = imgradientxy(grayImg);
    [gradientMag, gradientDir] = imgradient(gradX, gradY);
    cellSize = 8;
    numBins = 9;
    binEdges = linspace(0, 180, numBins+1);
    hogFeatures = [];

    for i = 1:cellSize:rows-cellSize+1
        for j = 1:cellSize:cols-cellSize+1
            blockMag = gradientMag(i:i+cellSize-1, j:j+cellSize-1);
            blockDir = gradientDir(i:i+cellSize-1, j:j+cellSize-1);
            blockDir = mod(blockDir, 180);
            hist = zeros(1, numBins);
            for bin = 1:numBins
                binMask = (blockDir >= binEdges(bin) & blockDir < binEdges(bin+1));
                hist(bin) = sum(blockMag(binMask));
            end
            hist = hist / sum(hist);
            hogFeatures = [hogFeatures, hist];
        end
    end
end
