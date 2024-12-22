%% 边缘提取模块函数
% 该函数创建一个新的窗口用于边缘提取操作，包括上传图片、选择边缘检测算子以及显示结果。
%
% @param parentWindow 父窗口句柄，关闭子窗口时恢复可见。
function edgeDetectionModule(parentWindow)
    addpath('D:\Files\ProgramProject\MatLab\FinalWork\GUI\utils');
    parentWindow.Visible = 'off';
    % 创建边缘提取窗口
    edgeWindow = uifigure('Name', '边缘提取', 'WindowStyle', 'normal', 'Position', [100, 100, 800, 500]);
    % 创建原图显示区域
    axOriginal = uiaxes(edgeWindow, ...
        'Position', [50, 150, 300, 300], ...
        'XTick', [], 'YTick', [], 'Box', 'on');
    axOriginal.Title.String = '原图';
    % 创建结果图显示区域
    axResult = uiaxes(edgeWindow, ...
        'Position', [450, 150, 300, 300], ...
        'XTick', [], 'YTick', [], 'Box', 'on');
    axResult.Title.String = '结果图';
    % 上传照片按钮
    uibutton(edgeWindow, ...
        'Text', '上传照片', ...
        'Position', [100, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) uploadImage(axOriginal));
    % 边缘提取按钮
    uibutton(edgeWindow, ...
        'Text', '边缘提取', ...
        'Position', [300, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) selectEdgeDetection(axOriginal, axResult));
    % 返回按钮
    uibutton(edgeWindow, ...
        'Text', '返回', ...
        'Position', [500, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) goBack(parentWindow, edgeWindow));
end

%% 上传图片函数
% 该函数用于上传图像并显示在原图区域。
%
% @param axOriginal 原图显示的坐标轴句柄。
function uploadImage(axOriginal)
    [file, path] = uigetfile({'*.jpg;*.png;*.bmp', '图像文件 (*.jpg, *.png, *.bmp)'; '*.*', '所有文件 (*.*)'}, ...
                             '选择一张图片');
    if isequal(file, 0)
        return;
    end
    img = imread(fullfile(path, file));
    imshow(img, 'Parent', axOriginal);
    axOriginal.Title.String = '原图';
    axOriginal.UserData = img;
end

%% 选择边缘检测算子函数
% 该函数弹出窗口供用户选择边缘检测算子。
%
% @param axOriginal 原图显示的坐标轴句柄。
% @param axResult 结果图显示的坐标轴句柄。
function selectEdgeDetection(axOriginal, axResult)
    if isempty(axOriginal.UserData)
        uialert(axOriginal.Parent, '请先上传图片！', '错误');
        return;
    end
    selectionWindow = uifigure('Name', '选择边缘检测算子', 'WindowStyle', 'modal', 'Position', [300, 300, 400, 200]);
    uilabel(selectionWindow, 'Text', '选择边缘检测算子:', 'Position', [50, 120, 150, 30]);
    dropdown = uidropdown(selectionWindow, ...
        'Items', {'Robert', 'Prewitt', 'Sobel', '拉普拉斯'}, ...
        'Position', [200, 120, 150, 30]);
    % 应用按钮
    uibutton(selectionWindow, ...
        'Text', '应用', ...
        'Position', [150, 50, 100, 30], ...
        'ButtonPushedFcn', @(btn, event) applyEdgeDetection(axOriginal, axResult, dropdown.Value, selectionWindow));
end

%% 应用边缘检测函数
% 该函数根据选择的算子进行边缘检测，并显示结果。
%
% @param axOriginal 原图显示的坐标轴句柄。
% @param axResult 结果图显示的坐标轴句柄。
% @param method 选择的边缘检测方法。
% @param selectionWindow 边缘检测选择窗口句柄，检测后关闭。
function applyEdgeDetection(axOriginal, axResult, method, selectionWindow)
    img = axOriginal.UserData;
    switch method
        case 'Robert'
            edgeImg = robertEdgeManual(img);
        case 'Prewitt'
            edgeImg = prewittEdgeManual(img);
        case 'Sobel'
            edgeImg = sobelEdgeManual(img);
        case '拉普拉斯'
            edgeImg = laplacianEdgeManual(img);
    end
    imshow(edgeImg, 'Parent', axResult);
    axResult.Title.String = [method, ' 边缘提取结果'];
    delete(selectionWindow);
end

%% 返回函数
% 该函数关闭边缘提取窗口并恢复父窗口的可见性。
%
% @param parentWindow 父窗口句柄。
% @param edgeWindow 边缘提取窗口句柄。
function goBack(parentWindow, edgeWindow)
    delete(edgeWindow);
    parentWindow.Visible = 'on';
end
