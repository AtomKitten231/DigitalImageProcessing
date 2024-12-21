function lbpHist = extractLBPFeaturesManual(img)
    if islogical(img) || numel(unique(img)) == 2
        grayImg = uint8(img) * 255;
    else
        grayImg = im2gray(img);
    end
    lbpImg = zeros(size(grayImg));
    [rows, cols] = size(grayImg);
    paddedImg = padarray(grayImg, [1, 1], 'symmetric');
    for i = 2:rows+1
        for j = 2:cols+1
            patch = paddedImg(i-1:i+1, j-1:j+1);
            center = patch(2, 2);
            binaryPattern = (patch >= center);
            binaryPattern(2, 2) = 0;
            weights = [1, 2, 4; 128, 0, 8; 64, 32, 16];
            lbpImg(i-1, j-1) = sum(binaryPattern(:) .* weights(:));
        end
    end
    lbpHist = histcounts(lbpImg(:), 0:256, 'Normalization', 'probability');
end
