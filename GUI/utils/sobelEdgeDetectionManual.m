function edgeImg = sobelEdgeDetectionManual(img, savePath)
    grayImg = rgb2grayManual(img);
    sobelX = [-1 0 1; -2 0 2; -1 0 1];
    sobelY = [-1 -2 -1; 0 0 0; 1 2 1];
    edgeX = conv2Manual(double(grayImg), sobelX);
    edgeY = conv2Manual(double(grayImg), sobelY);
    edgeImg = sqrt(edgeX.^2 + edgeY.^2);
    edgeImg = mat2gray(edgeImg);
    if nargin > 1 && ~isempty(savePath)
        imwrite(edgeImg, savePath);
        disp(['目标区域保存至：' savePath]);
    end
end
function result = conv2Manual(img, kernel)
    [rows, cols] = size(img);
    [kRows, kCols] = size(kernel);
    padRow = floor(kRows / 2);
    padCol = floor(kCols / 2);
    paddedImg = padarray(img, [padRow, padCol], 'replicate');
    result = zeros(size(img));
    for i = 1:rows
        for j = 1:cols
            region = paddedImg(i:i+kRows-1, j:j+kCols-1);
            result(i, j) = sum(region(:) .* kernel(:));
        end
    end
end
function grayImg = rgb2grayManual(img)
    grayImg = 0.2989 * img(:, :, 1) + 0.5870 * img(:, :, 2) + 0.1140 * img(:, :, 3);
    grayImg = uint8(grayImg);
end
