%% 灰度化处理模块函数
% 该函数创建一个新窗口，提供上传图片、灰度化处理、对比度增强等功能。
%
% @param parentWindow 父窗口句柄，关闭子窗口时恢复可见。
function grayscaleModule(parentWindow)
    parentWindow.Visible = 'off';
    % 创建灰度化处理窗口
    grayscaleWindow = uifigure('Name', '灰度化处理', 'WindowStyle', 'normal', 'Position', [100, 100, 800, 400]);
    axImage = uiaxes(grayscaleWindow, ...
        'Position', [50, 100, 250, 250], ...
        'XTick', [], 'YTick', [], 'Box', 'on');
    axImage.Title.String = '原始图像';
    axGrayscaleImage = uiaxes(grayscaleWindow, ...
        'Position', [340, 100, 250, 250], ...
        'XTick', [], 'YTick', [], 'Box', 'on');
    axGrayscaleImage.Title.String = '灰度图像';
    % 上传图片按钮
    uploadBtn = uibutton(grayscaleWindow, ...
        'Text', '上传图片', ...
        'Position', [50, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) uploadImage(axImage, axGrayscaleImage));
    % 灰度化按钮
    grayscaleBtn = uibutton(grayscaleWindow, ...
        'Text', '灰度化', ...
        'Position', [200, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) convertToGrayscale(axImage, axGrayscaleImage));
    % 线性对比度增强按钮
    linearEnhanceBtn = uibutton(grayscaleWindow, ...
        'Text', '线性对比度增强', ...
        'Position', [340, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) linearEnhanceModule(grayscaleWindow, axImage));
    % 非线性对比度增强按钮
    nonlinearEnhanceBtn = uibutton(grayscaleWindow, ...
        'Text', '非线性对比度增强', ...
        'Position', [470, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) nonlinearEnhanceModule(grayscaleWindow, axImage));
    % 返回按钮
    backButton = uibutton(grayscaleWindow, ...
        'Text', '返回', ...
        'Position', [600, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) goBack(parentWindow, grayscaleWindow));
end

%% 上传图片函数
% 该函数用于上传图像并显示在原图和灰度图像显示区域。
%
% @param axImage 原图显示的坐标轴句柄。
% @param axGrayscaleImage 灰度图像显示的坐标轴句柄。
function uploadImage(axImage, axGrayscaleImage)
    [file, path] = uigetfile({'*.jpg;*.png;*.bmp', '图像文件 (*.jpg, *.png, *.bmp)'; '*.*', '所有文件 (*.*)'}, ...
                             '选择一张图片');
    if isequal(file, 0)
        return;
    end
    img = imread(fullfile(path, file));
    imshow(img, 'Parent', axImage);
    axImage.Title.String = '原始图像';
    axImage.UserData = img;
    cla(axGrayscaleImage);
    axGrayscaleImage.Title.String = '灰度图像';
end

%% 灰度化处理函数
% 该函数将上传的彩色图像转换为灰度图像并显示。
%
% @param axImage 原图显示的坐标轴句柄。
% @param axGrayscaleImage 灰度图像显示的坐标轴句柄。
function convertToGrayscale(axImage, axGrayscaleImage)
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
    imshow(grayscaleImg, 'Parent', axGrayscaleImage);
    axGrayscaleImage.Title.String = '灰度图像';
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
