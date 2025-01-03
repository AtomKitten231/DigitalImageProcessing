%% 目标提取模块函数
% 该函数创建一个新窗口，提供上传图片、阈值分割、边缘检测和颜色直方图分离等目标提取功能。
%
% @param parentWindow 父窗口句柄，关闭子窗口时恢复可见。
function targetExtractionModule(parentWindow)
    parentWindow.Visible = 'off';
    % 创建目标提取窗口
    targetWindow = uifigure('Name', '目标提取', 'WindowStyle', 'normal', 'Position', [100, 100, 850, 600]);
    axOriginal = uiaxes(targetWindow, ...
        'Position', [50, 200, 300, 300], ...
        'XTick', [], 'YTick', [], 'Box', 'on');
    axOriginal.Title.String = '原图';
    axResult = uiaxes(targetWindow, ...
        'Position', [450, 200, 300, 300], ...
        'XTick', [], 'YTick', [], 'Box', 'on');
    axResult.Title.String = '目标提取结果';
    % 上传图片按钮
    uibutton(targetWindow, ...
        'Text', '上传图片', ...
        'Position', [50, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) uploadImage(axOriginal));
    % 阈值分割按钮
    uibutton(targetWindow, ...
        'Text', '阈值分割', ...
        'Position', [200, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) extractThresholdTarget(axOriginal, axResult));
    % 边缘检测 (Sobel) 按钮
    uibutton(targetWindow, ...
        'Text', '边缘检测 (Sobel)', ...
        'Position', [350, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) extractSobelTarget(axOriginal, axResult));
    % 颜色直方图分离按钮
    uibutton(targetWindow, ...
        'Text', '颜色直方图分离', ...
        'Position', [500, 50, 150, 30], ...
        'ButtonPushedFcn', @(btn, event) extractColorTarget(axOriginal, axResult));
    % 返回按钮
    uibutton(targetWindow, ...
        'Text', '返回', ...
        'Position', [700, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) goBack(parentWindow, targetWindow));
end

%% 上传图片函数
% 该函数用于上传图像并显示在原图区域。
%
% @param axOriginal 原图显示的坐标轴句柄。
function uploadImage(axOriginal)
    [file, path] = uigetfile({'*.jpg;*.png;*.bmp', '图像文件 (*.jpg, *.png, *.bmp)'; '*.*', '所有文件 (*.*)'}, '选择图片');
    if isequal(file, 0)
        return;
    end
    img = imread(fullfile(path, file));
    imshow(img, 'Parent', axOriginal);
    axOriginal.Title.String = '原图';
    axOriginal.UserData = img;
end

%% 阈值分割函数
% 该函数对图像进行阈值分割并显示分割结果。
%
% @param axOriginal 原图显示的坐标轴句柄。
% @param axResult 目标提取结果显示的坐标轴句柄。
function extractThresholdTarget(axOriginal, axResult)
    if isempty(axOriginal.UserData)
        uialert(axOriginal.Parent, '请先上传图片！', '错误');
        return;
    end
    img = axOriginal.UserData;
    saveDir = 'D:\Files\ProgramProject\MatLab\FinalWork\results\';
    if ~exist(saveDir, 'dir')
        mkdir(saveDir);
    end
    binaryImg = thresholdSegmentationManual(img, fullfile(saveDir, 'threshold_result.png'));
    imshow(binaryImg, 'Parent', axResult);
    axResult.Title.String = '阈值分割结果';
    axResult.UserData = binaryImg;
end

%% Sobel边缘检测函数
% 该函数对图像应用Sobel边缘检测并显示检测结果。
%
% @param axOriginal 原图显示的坐标轴句柄。
% @param axResult 目标提取结果显示的坐标轴句柄。
function extractSobelTarget(axOriginal, axResult)
    if isempty(axOriginal.UserData)
        uialert(axOriginal.Parent, '请先上传图片！', '错误');
        return;
    end
    img = axOriginal.UserData;
    saveDir = 'D:\Files\ProgramProject\MatLab\FinalWork\results\';
    if ~exist(saveDir, 'dir')
        mkdir(saveDir);
    end
    edgeImg = sobelEdgeDetectionManual(img, fullfile(saveDir, 'sobel_result.png'));
    imshow(edgeImg, 'Parent', axResult);
    axResult.Title.String = '边缘检测 (Sobel) 结果';
    axResult.UserData = edgeImg;
end

%% 颜色直方图分离函数
% 该函数对图像进行颜色直方图分离，并显示结果。
%
% @param axOriginal 原图显示的坐标轴句柄。
% @param axResult 目标提取结果显示的坐标轴句柄。
function extractColorTarget(axOriginal, axResult)
    if isempty(axOriginal.UserData)
        uialert(axOriginal.Parent, '请先上传图片！', '错误');
        return;
    end
    img = axOriginal.UserData;

    % 动态获取颜色范围
    inputFig = uifigure('Name', '设置颜色直方图范围', 'Position', [500, 400, 300, 200]);
    uilabel(inputFig, 'Text', '输入颜色范围 (0-1)：', 'Position', [50, 140, 200, 20]);
    uilabel(inputFig, 'Text', '下限：', 'Position', [50, 100, 50, 20]);
    uilabel(inputFig, 'Text', '上限：', 'Position', [50, 60, 50, 20]);

    lowerLimitField = uieditfield(inputFig, 'numeric', 'Position', [100, 100, 100, 20], 'Value', 0.2, 'Limits', [0, 1]);
    upperLimitField = uieditfield(inputFig, 'numeric', 'Position', [100, 60, 100, 20], 'Value', 0.4, 'Limits', [0, 1]);

    uibutton(inputFig, 'Text', '确定', 'Position', [100, 20, 100, 30], ...
        'ButtonPushedFcn', @(btn, event) processColorSegmentationWithSave(lowerLimitField.Value, upperLimitField.Value, inputFig, img, axResult));
end

%% 处理颜色分离的逻辑
% @param lowerLimit 用户输入的下限值
% @param upperLimit 用户输入的上限值
% @param inputFig 用户输入范围的窗口句柄
% @param img 原始图像
% @param axResult 目标提取结果显示的坐标轴句柄
function processColorSegmentationWithSave(lowerLimit, upperLimit, inputFig, img, axResult)
    if lowerLimit >= upperLimit
        uialert(inputFig, '下限必须小于上限！', '错误');
        return;
    end
    close(inputFig);

    % 定义保存路径
    saveDir = 'D:\Files\ProgramProject\MatLab\FinalWork\results\';
    if ~exist(saveDir, 'dir')
        mkdir(saveDir);
    end

    % 调用颜色直方图分割逻辑
    targetRange = [lowerLimit, upperLimit];
    savePath = fullfile(saveDir, 'color_result.png');
    binaryImg = colorHistogramSegmentationManual(img, targetRange, savePath);

    % 显示结果
    imshow(binaryImg, 'Parent', axResult);
    axResult.Title.String = '颜色直方图分离结果';
    axResult.UserData = binaryImg;
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
