%% 特征提取模块函数
% 该函数创建一个新的窗口用于特征提取操作，提供上传图片和选择不同特征提取方法的按钮。
%
% @param parentWindow 父窗口句柄，关闭子窗口时恢复可见。
function featureExtractionModule(parentWindow)
    parentWindow.Visible = 'off';
    % 创建特征提取窗口
    featureWindow = uifigure('Name', '特征提取', 'WindowStyle', 'normal', 'Position', [100, 100, 800, 500]);
    axOriginal = uiaxes(featureWindow, ...
        'Position', [50, 150, 300, 300], ...
        'XTick', [], 'YTick', [], 'Box', 'on');
    axOriginal.Title.String = '原图';
    % 上传图片按钮
    uibutton(featureWindow, ...
        'Text', '上传图片', ...
        'Position', [50, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) uploadImage(axOriginal));
    % LBP特征提取按钮
    uibutton(featureWindow, ...
        'Text', 'LBP特征提取', ...
        'Position', [200, 50, 150, 30], ...
        'ButtonPushedFcn', @(btn, event) lbpFeatureWindow(axOriginal, featureWindow));
    % HOG特征提取按钮
    uibutton(featureWindow, ...
        'Text', 'HOG特征提取', ...
        'Position', [400, 50, 150, 30], ...
        'ButtonPushedFcn', @(btn, event) hogFeatureWindow(axOriginal, featureWindow));
    % 返回按钮
    uibutton(featureWindow, ...
        'Text', '返回', ...
        'Position', [600, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) goBack(parentWindow, featureWindow));
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

%% LBP特征提取窗口函数
% 该函数创建一个新窗口，用于显示原图和LBP特征提取结果。
%
% @param axOriginal 原图显示的坐标轴句柄。
% @param parentWindow 父窗口句柄。
function lbpFeatureWindow(axOriginal, parentWindow)
    if isempty(axOriginal.UserData)
        uialert(axOriginal.Parent, '请先上传图片！', '错误');
        return;
    end
    parentWindow.Visible = 'off';
    lbpWindow = uifigure('Name', 'LBP特征提取', 'WindowStyle', 'normal', 'Position', [100, 100, 800, 500]);
    axOriginalLBP = uiaxes(lbpWindow, ...
        'Position', [50, 150, 300, 300], ...
        'XTick', [], 'YTick', [], 'Box', 'on');
    axOriginalLBP.Title.String = '原图';
    imshow(axOriginal.UserData, 'Parent', axOriginalLBP);
    axResultLBP = uiaxes(lbpWindow, ...
        'Position', [450, 150, 300, 300], ...
        'XTick', [], 'YTick', [], 'Box', 'on');
    axResultLBP.Title.String = 'LBP特征';
    img = axOriginal.UserData;
    lbpHist = extractLBPFeaturesManual(img);
    bar(axResultLBP, lbpHist);
    % 返回按钮
    uibutton(lbpWindow, ...
        'Text', '返回', ...
        'Position', [650, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) goBack(parentWindow, lbpWindow));
end

%% HOG特征提取窗口函数
% 该函数创建一个新窗口，用于显示原图和HOG特征提取结果。
%
% @param axOriginal 原图显示的坐标轴句柄。
% @param parentWindow 父窗口句柄。
function hogFeatureWindow(axOriginal, parentWindow)
    if isempty(axOriginal.UserData)
        uialert(axOriginal.Parent, '请先上传图片！', '错误');
        return;
    end
    parentWindow.Visible = 'off';
    hogWindow = uifigure('Name', 'HOG特征提取', 'WindowStyle', 'normal', 'Position', [100, 100, 800, 500]);
    axOriginalHOG = uiaxes(hogWindow, ...
        'Position', [50, 150, 300, 300], ...
        'XTick', [], 'YTick', [], 'Box', 'on');
    axOriginalHOG.Title.String = '原图';
    imshow(axOriginal.UserData, 'Parent', axOriginalHOG);
    axResultHOG = uiaxes(hogWindow, ...
        'Position', [450, 150, 300, 300], ...
        'XTick', [], 'YTick', [], 'Box', 'on');
    axResultHOG.Title.String = 'HOG特征';
    img = axOriginal.UserData;
    hogFeatures = extractHOGFeaturesManual(img);
    bar(axResultHOG, hogFeatures);
    % 返回按钮
    uibutton(hogWindow, ...
        'Text', '返回', ...
        'Position', [650, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) goBack(parentWindow, hogWindow));
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
