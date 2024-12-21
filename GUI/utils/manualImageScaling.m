function scaledImg = manualImageScaling(img, scaleFactor)
    if scaleFactor <= 0
        error('缩放比例必须大于 0');
    end
    [rows, cols, channels] = size(img);
    newRows = round(rows * scaleFactor);
    newCols = round(cols * scaleFactor);
    scaledImg = zeros(newRows, newCols, channels, 'uint8');
    for i = 1:newRows
        for j = 1:newCols
            origX = i / scaleFactor;
            origY = j / scaleFactor;
            x1 = min(max(round(origX), 1), rows);
            y1 = min(max(round(origY), 1), cols);
            scaledImg(i, j, :) = img(x1, y1, :);
        end
    end
end
