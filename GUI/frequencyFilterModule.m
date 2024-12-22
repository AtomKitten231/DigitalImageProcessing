%% 频率域滤波模块函数
% 该函数创建一个新窗口，提供低通滤波和高通滤波操作，并显示噪声图像与滤波后的结果。
%
% @param axNoisy 含噪声图像的坐标轴句柄。
% @param parentWindow 父窗口句柄，关闭子窗口时恢复可见。
function frequencyFilterModule(axNoisy, parentWindow)
    addpath('D:\Files\ProgramProject\MatLab\FinalWork\GUI\utils');
    if isempty(axNoisy.UserData)
        uialert(parentWindow, '请先上传图片并添加噪声！', '错误');
        return;
    end
    parentWindow.Visible = 'off';
    % 创建频率滤波窗口
    frequencyWindow = uifigure('Name', '频率域滤波', 'WindowStyle', 'normal', 'Position', [100, 100, 800, 500]);
    % 显示原噪声图像
    axNoisyImage = uiaxes(frequencyWindow, 'Position', [50, 200, 300, 250], 'XTick', [], 'YTick', [], 'Box', 'on');
    axNoisyImage.Title.String = '原噪声图像';
    imshow(axNoisy.UserData, 'Parent', axNoisyImage);
    % 显示滤波后图像
    axFilteredImage = uiaxes(frequencyWindow, 'Position', [450, 200, 300, 250], 'XTick', [], 'YTick', [], 'Box', 'on');
    axFilteredImage.Title.String = '滤波后图像';
    % 低通滤波按钮
    uibutton(frequencyWindow, 'Text', '低通滤波', 'Position', [200, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) applyLowPassFilter(axNoisy.UserData, axFilteredImage));
    % 高通滤波按钮
    uibutton(frequencyWindow, 'Text', '高通滤波', 'Position', [350, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) applyHighPassFilter(axNoisy.UserData, axFilteredImage));
    % 返回按钮
    uibutton(frequencyWindow, 'Text', '返回', 'Position', [650, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) goBack(parentWindow, frequencyWindow));
end

%% 低通滤波应用函数
% 该函数应用低通滤波器，并显示滤波后的图像。
%
% @param noisyImg 含噪声图像。
% @param axFilteredImage 滤波后图像显示的坐标轴句柄。
function applyLowPassFilter(noisyImg, axFilteredImage)
    radius = 50;
    filteredImg = applyLowPassFilterManual(noisyImg, radius);
    imshow(filteredImg, 'Parent', axFilteredImage);
    axFilteredImage.Title.String = '低通滤波结果';
end

%% 高通滤波应用函数
% 该函数应用高通滤波器，并显示滤波后的图像。
%
% @param noisyImg 含噪声图像。
% @param axFilteredImage 滤波后图像显示的坐标轴句柄。
function applyHighPassFilter(noisyImg, axFilteredImage)
    radius = 50;
    filteredImg = applyHighPassFilterManual(noisyImg, radius);
    imshow(filteredImg, 'Parent', axFilteredImage);
    axFilteredImage.Title.String = '高通滤波结果';
end

%% 返回函数
% 该函数关闭当前窗口并恢复父窗口的可见性。
%
% @param parentWindow 父窗口句柄。
% @param currentWindow 当前窗口句柄。
function goBack(parentWindow, currentWindow)
    delete(currentWindow);
    parentWindow.Visible = 'on';
end
