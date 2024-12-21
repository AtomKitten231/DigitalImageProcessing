function filteredImg = applyHighPassFilterManual(noisyImg, radius)
    grayImg = im2double(rgb2gray(noisyImg));
    fftImg = fft2(grayImg);
    fftShifted = fftshift(fftImg);
    [rows, cols] = size(fftShifted);
    centerX = round(rows / 2);
    centerY = round(cols / 2);
    [X, Y] = meshgrid(1:cols, 1:rows);
    mask = ((X - centerY).^2 + (Y - centerX).^2) > radius^2;
    mask = double(mask);
    filteredFFT = fftShifted .* mask;
    filteredImg = real(ifft2(ifftshift(filteredFFT)));
    filteredImg = mat2gray(filteredImg);
end
