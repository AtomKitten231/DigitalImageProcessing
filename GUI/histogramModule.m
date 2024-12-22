%% 直方图处理模块函数
% 该函数创建一个新窗口，提供上传图片、直方图均衡化、直方图匹配等功能。
%
% @param parentWindow 父窗口句柄，关闭子窗口时恢复可见。
function histogramModule(parentWindow)
    parentWindow.Visible = 'off';
    % 创建直方图处理窗口
    histogramWindow = uifigure('Name', '直方图处理', 'WindowStyle', 'normal', 'Position', [100, 100, 800, 400]);
    axImage = uiaxes(histogramWindow, ...
        'Position', [50, 100, 300, 250], ...
        'XTick', [], 'YTick', [], 'Box', 'on');
    axImage.Title.String = '原始图像';
    axHistogram = uiaxes(histogramWindow, ...
        'Position', [400, 100, 300, 250], ...
        'XTick', [], 'YTick', [], 'Box', 'on');
    axHistogram.Title.String = '灰度直方图';
    % 上传图片按钮
    uploadBtn = uibutton(histogramWindow, ...
        'Text', '上传图片', ...
        'Position', [50, 350, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) uploadAndShowImageAndHistogram(axImage, axHistogram));
    % 直方图均衡化按钮
    equalizeBtn = uibutton(histogramWindow, ...
        'Text', '直方图均衡化', ...
        'Position', [200, 350, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) equalizeHistogram(axImage, axHistogram));
    % 直方图匹配按钮
    matchBtn = uibutton(histogramWindow, ...
        'Text', '直方图匹配', ...
        'Position', [350, 350, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) matchHistogram(axImage, axHistogram));
    % 返回按钮
    backButton = uibutton(histogramWindow, ...
        'Text', '返回', ...
        'Position', [500, 350, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) goBack(parentWindow, histogramWindow));
end

%% 上传图片并显示原图和直方图
% 该函数用于上传图片并显示原图和其灰度直方图。
%
% @param axImage 原图显示的坐标轴句柄。
% @param axHistogram 灰度直方图显示的坐标轴句柄。
function uploadAndShowImageAndHistogram(axImage, axHistogram)
    [file, path] = uigetfile({'*.jpg;*.png;*.bmp', '图像文件 (*.jpg, *.png, *.bmp)'; '*.*', '所有文件 (*.*)'}, ...
                             '选择一张图片');
    if isequal(file, 0)
        return;
    end
    img = imread(fullfile(path, file));
    imshow(img, 'Parent', axImage);
    axImage.UserData = img;
    axImage.Title.String = '原始图像';
    if size(img, 3) == 3
        img = rgb2gray(img);
    end
    histogram(axHistogram, img(:), 'BinEdges', 0:256, 'FaceColor', 'k');
    axHistogram.UserData = img;
    axHistogram.Title.String = '灰度直方图';
    axHistogram.XLabel.String = '灰度级';
    axHistogram.YLabel.String = '像素数';
end

%% 直方图均衡化函数
% 该函数对上传的图像进行直方图均衡化，并显示结果。
%
% @param axImage 原图显示的坐标轴句柄。
% @param axHistogram 灰度直方图显示的坐标轴句柄。
function equalizeHistogram(axImage, axHistogram)
    addpath('D:\Files\ProgramProject\MatLab\FinalWork\GUI\utils');
    if isempty(axImage.UserData) || isempty(axHistogram.UserData)
        uialert(axImage.Parent, '请先上传图片！', '错误');
        return;
    end
    img = axHistogram.UserData;
    equalizedImg = histogramEqualizationManual(img);
    equalizedWindow = uifigure('Name', '直方图均衡化', 'WindowStyle', 'normal', 'Position', [100, 100, 800, 500]);
    axOriginalImage = uiaxes(equalizedWindow, ...
        'Position', [50, 250, 300, 200], ...
        'XTick', [], 'YTick', [], 'Box', 'on');
    imshow(img, 'Parent', axOriginalImage);
    axOriginalImage.Title.String = '原始图像';
    axEqualizedImage = uiaxes(equalizedWindow, ...
        'Position', [400, 250, 300, 200], ...
        'XTick', [], 'YTick', [], 'Box', 'on');
    imshow(equalizedImg, 'Parent', axEqualizedImage);
    axEqualizedImage.Title.String = '均衡化后图像';
    axOriginalHistogram = uiaxes(equalizedWindow, ...
        'Position', [50, 50, 300, 150], ...
        'XTick', [], 'YTick', [], 'Box', 'on');
    histogram(axOriginalHistogram, img(:), 'BinEdges', 0:256, 'FaceColor', 'k');
    axOriginalHistogram.Title.String = '原始灰度直方图';
    axEqualizedHistogram = uiaxes(equalizedWindow, ...
        'Position', [400, 50, 300, 150], ...
        'XTick', [], 'YTick', [], 'Box', 'on');
    histogram(axEqualizedHistogram, equalizedImg(:), 'BinEdges', 0:256, 'FaceColor', 'k');
    axEqualizedHistogram.Title.String = '均衡化后灰度直方图';
end

%% 直方图匹配函数
% 该函数进行直方图匹配，并显示匹配后的图像与其灰度直方图。
%
% @param axImage 原图显示的坐标轴句柄。
% @param axHistogram 灰度直方图显示的坐标轴句柄。
function matchHistogram(axImage, axHistogram)
    addpath('D:\Files\ProgramProject\MatLab\FinalWork\GUI\utils');
    if isempty(axImage.UserData) || isempty(axHistogram.UserData)
        uialert(axImage.Parent, '请先上传图片！', '错误');
        return;
    end
    srcImg = axHistogram.UserData;
    matchWindow = uifigure('Name', '直方图匹配', 'WindowStyle', 'normal', 'Position', [100, 100, 1200, 500]);
    axOriginalImage = uiaxes(matchWindow, ...
        'Position', [50, 250, 300, 200], ...
        'XTick', [], 'YTick', [], 'Box', 'on');
    imshow(srcImg, 'Parent', axOriginalImage);
    axOriginalImage.Title.String = '原始图像';
    axOriginalHistogram = uiaxes(matchWindow, ...
        'Position', [50, 50, 300, 150], ...
        'XTick', [], 'YTick', [], 'Box', 'on');
    histogram(axOriginalHistogram, srcImg(:), 'BinEdges', 0:256, 'FaceColor', 'k');
    axOriginalHistogram.Title.String = '原始灰度直方图';
    uploadTargetBtn = uibutton(matchWindow, ...
        'Text', '上传目标图像', ...
        'Position', [60, 460, 150, 30], ...
        'ButtonPushedFcn', @(btn, event) uploadTargetImage(srcImg, matchWindow));
end

%% 上传目标图像并进行直方图匹配
% 该函数用于上传目标图像并与源图像进行直方图匹配，显示匹配结果。
%
% @param srcImg 源图像。
% @param matchWindow 直方图匹配窗口句柄。
function uploadTargetImage(srcImg, matchWindow)
    [file, path] = uigetfile({'*.jpg;*.png;*.bmp', '图像文件 (*.jpg, *.png, *.bmp)'; '*.*', '所有文件 (*.*)'}, ...
                             '选择目标图像');
    if isequal(file, 0)
        return;
    end
    targetImg = imread(fullfile(path, file));
    if size(targetImg, 3) == 3
        targetImg = rgb2gray(targetImg);
    end
    matchedImg = histogramMatchingManual(srcImg, targetImg);
    axTargetImage = uiaxes(matchWindow, ...
        'Position', [400, 250, 300, 200], ...
        'XTick', [], 'YTick', [], 'Box', 'on');
    imshow(targetImg, 'Parent', axTargetImage);
    axTargetImage.Title.String = '目标图像';
    axTargetHistogram = uiaxes(matchWindow, ...
        'Position', [400, 50, 300, 150], ...
        'XTick', [], 'YTick', [], 'Box', 'on');
    histogram(axTargetHistogram, targetImg(:), 'BinEdges', 0:256, 'FaceColor', 'k');
    axTargetHistogram.Title.String = '目标灰度直方图';
    axMatchedImage = uiaxes(matchWindow, ...
        'Position', [750, 250, 300, 200], ...
        'XTick', [], 'YTick', [], 'Box', 'on');
    imshow(matchedImg, 'Parent', axMatchedImage);
    axMatchedImage.Title.String = '匹配后图像';
    axMatchedHistogram = uiaxes(matchWindow, ...
        'Position', [750, 50, 300, 150], ...
        'XTick', [], 'YTick', [], 'Box', 'on');
    histogram(axMatchedHistogram, matchedImg(:), 'BinEdges', 0:256, 'FaceColor', 'k');
    axMatchedHistogram.Title.String = '匹配后灰度直方图';
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
