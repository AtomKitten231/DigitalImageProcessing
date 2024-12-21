function spatialFilterModule(axNoisy, parentWindow)
    addpath('D:\Files\ProgramProject\MatLab\FinalWork\GUI\utils');
    if isempty(axNoisy.UserData)
        uialert(parentWindow, '请先上传图片并添加噪声！', '错误');
        return;
    end
    parentWindow.Visible = 'off';
    spatialWindow = uifigure('Name', '空间域滤波', 'WindowStyle', 'normal', 'Position', [100, 100, 800, 500]);
    axNoisyImage = uiaxes(spatialWindow, 'Position', [50, 200, 300, 250], 'XTick', [], 'YTick', [], 'Box', 'on');
    axNoisyImage.Title.String = '原噪声图像';
    imshow(axNoisy.UserData, 'Parent', axNoisyImage);
    axFilteredImage = uiaxes(spatialWindow, 'Position', [450, 200, 300, 250], 'XTick', [], 'YTick', [], 'Box', 'on');
    axFilteredImage.Title.String = '滤波后图像';
    uibutton(spatialWindow, 'Text', '中值滤波', 'Position', [200, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) applyMedianFilter(axNoisy.UserData, axFilteredImage));
    uibutton(spatialWindow, 'Text', '双边滤波', 'Position', [350, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) applyBilateralFilter(axNoisy.UserData, axFilteredImage));
    uibutton(spatialWindow, 'Text', '返回', 'Position', [650, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) goBack(parentWindow, spatialWindow));
end
function applyMedianFilter(noisyImg, axFilteredImage)
    filteredImg = applyMedianFilterManual(noisyImg);
    imshow(filteredImg, 'Parent', axFilteredImage);
    axFilteredImage.Title.String = '中值滤波结果';
end
function applyBilateralFilter(noisyImg, axFilteredImage)
    sigmaSpatial = 3;
    sigmaRange = 0.1;
    filteredImg = applyBilateralFilterManual(noisyImg, sigmaSpatial, sigmaRange);
    imshow(filteredImg, 'Parent', axFilteredImage);
    axFilteredImage.Title.String = '双边滤波结果';
end
function goBack(parentWindow, currentWindow)
    delete(currentWindow);
    parentWindow.Visible = 'on';
end
