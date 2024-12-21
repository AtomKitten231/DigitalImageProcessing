function frequencyFilterModule(axNoisy, parentWindow)
    addpath('D:\Files\ProgramProject\MatLab\FinalWork\GUI\utils');
    if isempty(axNoisy.UserData)
        uialert(parentWindow, '请先上传图片并添加噪声！', '错误');
        return;
    end
    parentWindow.Visible = 'off';
    frequencyWindow = uifigure('Name', '频率域滤波', 'WindowStyle', 'normal', 'Position', [100, 100, 800, 500]);
    axNoisyImage = uiaxes(frequencyWindow, 'Position', [50, 200, 300, 250], 'XTick', [], 'YTick', [], 'Box', 'on');
    axNoisyImage.Title.String = '原噪声图像';
    imshow(axNoisy.UserData, 'Parent', axNoisyImage);
    axFilteredImage = uiaxes(frequencyWindow, 'Position', [450, 200, 300, 250], 'XTick', [], 'YTick', [], 'Box', 'on');
    axFilteredImage.Title.String = '滤波后图像';
    uibutton(frequencyWindow, 'Text', '低通滤波', 'Position', [200, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) applyLowPassFilter(axNoisy.UserData, axFilteredImage));
    uibutton(frequencyWindow, 'Text', '高通滤波', 'Position', [350, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) applyHighPassFilter(axNoisy.UserData, axFilteredImage));
    uibutton(frequencyWindow, 'Text', '返回', 'Position', [650, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) goBack(parentWindow, frequencyWindow));
end

function applyLowPassFilter(noisyImg, axFilteredImage)
    radius = 50;
    filteredImg = applyLowPassFilterManual(noisyImg, radius);
    imshow(filteredImg, 'Parent', axFilteredImage);
    axFilteredImage.Title.String = '低通滤波结果';
end
function applyHighPassFilter(noisyImg, axFilteredImage)
    radius = 50;
    filteredImg = applyHighPassFilterManual(noisyImg, radius);
    imshow(filteredImg, 'Parent', axFilteredImage);
    axFilteredImage.Title.String = '高通滤波结果';
end
function goBack(parentWindow, currentWindow)
    delete(currentWindow);
    parentWindow.Visible = 'on';
end
