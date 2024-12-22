%% 线性对比度增强模块函数
% 该函数创建一个新窗口，提供对上传的灰度图像进行线性对比度增强的功能，并显示增强前后的图像。
%
% @param parentWindow 父窗口句柄，关闭子窗口时恢复可见。
% @param axImage 原图显示的坐标轴句柄。
function linearEnhanceModule(parentWindow, axImage)
    addpath('D:\Files\ProgramProject\MatLab\FinalWork\GUI\utils');
    if isempty(axImage.UserData)
        uialert(axImage.Parent, '请先上传图片！', '错误');
        return;
    end
    img = axImage.UserData;
    if size(img, 3) == 3
        grayscaleImg = rgbToGrayscaleManual(img);
    else
        grayscaleImg = img;
    end
    parentWindow.Visible = 'off';
    % 创建线性对比度增强窗口
    linearWindow = uifigure('Name', '线性对比度增强', 'WindowStyle', 'normal', 'Position', [100, 100, 800, 400]);
    % 显示原始灰度图像
    axOriginal = uiaxes(linearWindow, ...
        'Position', [50, 100, 300, 250], ...
        'XTick', [], 'YTick', [], 'Box', 'on');
    imshow(grayscaleImg, 'Parent', axOriginal);
    axOriginal.Title.String = '原始灰度图像';
    % 显示增强后的图像
    axEnhanced = uiaxes(linearWindow, ...
        'Position', [400, 100, 300, 250], ...
        'XTick', [], 'YTick', [], 'Box', 'on');
    enhancedImg = linearContrastEnhancementManual(grayscaleImg);
    imshow(enhancedImg, 'Parent', axEnhanced);
    axEnhanced.Title.String = '线性对比度增强结果';
    % 返回按钮
    backButton = uibutton(linearWindow, ...
        'Text', '返回', ...
        'Position', [350, 20, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) goBack(parentWindow, linearWindow));
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
