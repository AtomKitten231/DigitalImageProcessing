%% 几何变换模块函数
% 该函数创建一个新窗口，提供上传图片、缩放、旋转等几何变换操作。
%
% @param parentWindow 父窗口句柄，关闭子窗口时恢复可见。
function geometryTransformModule(parentWindow)
    parentWindow.Visible = 'off';
    % 创建几何变换窗口
    transformWindow = uifigure('Name', '几何变换', 'WindowStyle', 'normal', 'Position', [100, 100, 800, 500]);
    axImage = uiaxes(transformWindow, ...
        'Position', [100, 150, 300, 300], ...
        'XTick', [], 'YTick', [], 'Box', 'on');
    axImage.Title.String = '原始图像';
    % 上传图片按钮
    uploadBtn = uibutton(transformWindow, ...
        'Text', '上传图片', ...
        'Position', [100, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) uploadImage(axImage));
    % 缩放按钮
    scaleBtn = uibutton(transformWindow, ...
        'Text', '缩放', ...
        'Position', [250, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) scaleImageModule(transformWindow, axImage));
    % 旋转按钮
    rotateBtn = uibutton(transformWindow, ...
        'Text', '旋转', ...
        'Position', [400, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) rotateImageModule(transformWindow, axImage));
    % 返回按钮
    backButton = uibutton(transformWindow, ...
        'Text', '返回', ...
        'Position', [550, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) goBack(parentWindow, transformWindow));
end

%% 上传图片函数
% 该函数用于上传图像并显示在原图显示区域。
%
% @param axImage 原图显示的坐标轴句柄。
function uploadImage(axImage)
    [file, path] = uigetfile({'*.jpg;*.png;*.bmp', '图像文件 (*.jpg, *.png, *.bmp)'; '*.*', '所有文件 (*.*)'}, ...
                             '选择一张图片');
    if isequal(file, 0)
        return;
    end
    img = imread(fullfile(path, file));
    imshow(img, 'Parent', axImage);
    axImage.Title.String = '原始图像';
    axImage.UserData = img;
end

%% 缩放模块函数
% 该函数创建一个新窗口，提供图像缩放功能并显示缩放后的图像。
%
% @param parentWindow 父窗口句柄。
% @param axImage 原图显示的坐标轴句柄。
function scaleImageModule(parentWindow, axImage)
    if isempty(axImage.UserData)
        uialert(axImage.Parent, '请先上传图片！', '错误');
        return;
    end
    img = axImage.UserData;
    parentWindow.Visible = 'off';
    % 创建缩放窗口
    scaleWindow = uifigure('Name', '缩放图像', 'WindowStyle', 'normal', 'Position', [100, 100, 800, 500]);
    axOriginal = uiaxes(scaleWindow, ...
        'Position', [50, 200, 300, 250], ...
        'XTick', [], 'YTick', [], 'Box', 'on');
    imshow(img, 'Parent', axOriginal);
    axOriginal.Title.String = '原始图像';
    axScaled = uiaxes(scaleWindow, ...
        'Position', [400, 200, 300, 250], ...
        'XTick', [], 'YTick', [], 'Box', 'on');
    axScaled.Title.String = '缩放后图像';
    % 缩放比例输入框
    lbl = uilabel(scaleWindow, ...
        'Text', '缩放比例 (0.1~3.0):', ...
        'Position', [50, 80, 150, 30]);
    scaleInput = uieditfield(scaleWindow, 'numeric', ...
        'Position', [200, 80, 100, 30], ...
        'Limits', [0.1, 3.0], ...
        'Value', 1.0);
    % 应用缩放按钮
    applyBtn = uibutton(scaleWindow, ...
        'Text', '应用缩放', ...
        'Position', [320, 80, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) applyScaling(img, scaleInput.Value, axScaled));
    % 返回按钮
    backButton = uibutton(scaleWindow, ...
        'Text', '返回', ...
        'Position', [650, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) goBack(parentWindow, scaleWindow));
end

%% 应用缩放函数
% 该函数根据用户输入的缩放比例对图像进行缩放。
%
% @param img 原图像。
% @param scaleFactor 缩放因子。
% @param axScaled 缩放后图像显示的坐标轴句柄。
function applyScaling(img, scaleFactor, axScaled)
    addpath('D:\Files\ProgramProject\MatLab\FinalWork\GUI\utils');
    scaledImg = imageScalingManual(img, scaleFactor);
    imshow(scaledImg, 'Parent', axScaled);
    axScaled.Title.String = sprintf('缩放后图像 (%.2fx)', scaleFactor);
end

%% 旋转模块函数
% 该函数创建一个新窗口，提供图像旋转功能并显示旋转后的图像。
%
% @param parentWindow 父窗口句柄。
% @param axImage 原图显示的坐标轴句柄。
function rotateImageModule(parentWindow, axImage)
    if isempty(axImage.UserData)
        uialert(axImage.Parent, '请先上传图片！', '错误');
        return;
    end
    img = axImage.UserData;
    parentWindow.Visible = 'off';
    % 创建旋转窗口
    rotateWindow = uifigure('Name', '旋转图像', 'WindowStyle', 'normal', 'Position', [100, 100, 800, 500]);
    axOriginal = uiaxes(rotateWindow, ...
        'Position', [50, 200, 300, 250], ...
        'XTick', [], 'YTick', [], 'Box', 'on');
    imshow(img, 'Parent', axOriginal);
    axOriginal.Title.String = '原始图像';
    axRotated = uiaxes(rotateWindow, ...
        'Position', [400, 200, 300, 250], ...
        'XTick', [], 'YTick', [], 'Box', 'on');
    axRotated.Title.String = '旋转后图像';
    % 旋转角度输入框
    lbl = uilabel(rotateWindow, ...
        'Text', '旋转角度 (-360~360):', ...
        'Position', [50, 80, 150, 30]);
    rotateInput = uieditfield(rotateWindow, 'numeric', ...
        'Position', [200, 80, 100, 30], ...
        'Limits', [-360, 360], ...
        'Value', 0);
    % 应用旋转按钮
    applyBtn = uibutton(rotateWindow, ...
        'Text', '应用旋转', ...
        'Position', [320, 80, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) applyRotation(img, rotateInput.Value, axRotated));
    % 返回按钮
    backButton = uibutton(rotateWindow, ...
        'Text', '返回', ...
        'Position', [650, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) goBack(parentWindow, rotateWindow));
end

%% 应用旋转函数
% 该函数根据用户输入的旋转角度对图像进行旋转。
%
% @param img 原图像。
% @param angle 旋转角度。
% @param axRotated 旋转后图像显示的坐标轴句柄。
function applyRotation(img, angle, axRotated)
    addpath('D:\Files\ProgramProject\MatLab\FinalWork\GUI\utils');
    rotatedImg = imageRotationManual(img, angle);
    imshow(rotatedImg, 'Parent', axRotated);
    axRotated.Title.String = sprintf('旋转后图像 (%d°)', angle);
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
