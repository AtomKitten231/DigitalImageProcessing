function rotatedImg = manualImageRotation(img, angle)
    theta = deg2rad(angle);
    [rows, cols, channels] = size(img);
    centerX = ceil(rows / 2);
    centerY = ceil(cols / 2);
    rotatedImg = zeros(rows, cols, channels, 'uint8');
    for i = 1:rows
        for j = 1:cols
            for k = 1:channels
                x = (i - centerX) * cos(theta) - (j - centerY) * sin(theta) + centerX;
                y = (i - centerX) * sin(theta) + (j - centerY) * cos(theta) + centerY;
                if x >= 1 && x <= rows && y >= 1 && y <= cols
                    x1 = min(max(round(x), 1), rows);
                    y1 = min(max(round(y), 1), cols);
                    rotatedImg(i, j, k) = img(x1, y1, k);
                end
            end
        end
    end
end
