%% 空间域滤波模块函数
% 该函数创建一个新窗口，提供中值滤波和双边滤波操作，并显示加噪图像及滤波后的图像。
%
% @param axNoisy 加噪图像显示的坐标轴句柄。
% @param parentWindow 父窗口句柄，关闭子窗口时恢复可见。
function spatialFilterModule(axNoisy, parentWindow)
    addpath('D:\Files\ProgramProject\MatLab\FinalWork\GUI\utils');
    if isempty(axNoisy.UserData)
        uialert(parentWindow, '请先上传图片并添加噪声！', '错误');
        return;
    end
    parentWindow.Visible = 'off';
    % 创建空间域滤波窗口
    spatialWindow = uifigure('Name', '空间域滤波', 'WindowStyle', 'normal', 'Position', [100, 100, 800, 500]);
    axNoisyImage = uiaxes(spatialWindow, 'Position', [50, 200, 300, 250], 'XTick', [], 'YTick', [], 'Box', 'on');
    axNoisyImage.Title.String = '原噪声图像';
    imshow(axNoisy.UserData, 'Parent', axNoisyImage);
    axFilteredImage = uiaxes(spatialWindow, 'Position', [450, 200, 300, 250], 'XTick', [], 'YTick', [], 'Box', 'on');
    axFilteredImage.Title.String = '滤波后图像';
    % 中值滤波按钮
    uibutton(spatialWindow, 'Text', '中值滤波', 'Position', [200, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) applyMedianFilter(axNoisy.UserData, axFilteredImage));
    % 双边滤波按钮
    uibutton(spatialWindow, 'Text', '双边滤波', 'Position', [350, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) applyBilateralFilter(axNoisy.UserData, axFilteredImage));
    % 返回按钮
    uibutton(spatialWindow, 'Text', '返回', 'Position', [650, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) goBack(parentWindow, spatialWindow));
end

%% 中值滤波函数
% 该函数对图像应用中值滤波并显示结果。
%
% @param noisyImg 加噪图像。
% @param axFilteredImage 滤波后图像显示的坐标轴句柄。
function applyMedianFilter(noisyImg, axFilteredImage)
    filteredImg = applyMedianFilterManual(noisyImg);
    imshow(filteredImg, 'Parent', axFilteredImage);
    axFilteredImage.Title.String = '中值滤波结果';
end

%% 双边滤波函数
% 该函数对图像应用双边滤波并显示结果。
%
% @param noisyImg 加噪图像。
% @param axFilteredImage 滤波后图像显示的坐标轴句柄。
function applyBilateralFilter(noisyImg, axFilteredImage)
    sigmaSpatial = 3;
    sigmaRange = 0.1;
    filteredImg = applyBilateralFilterManual(noisyImg, sigmaSpatial, sigmaRange);
    imshow(filteredImg, 'Parent', axFilteredImage);
    axFilteredImage.Title.String = '双边滤波结果';
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
