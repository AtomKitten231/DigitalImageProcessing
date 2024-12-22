%% 非线性对比度增强模块函数
% 该函数创建一个新窗口，提供对上传的灰度图像进行对数增强和指数增强的功能，并显示增强前后的图像。
%
% @param parentWindow 父窗口句柄，关闭子窗口时恢复可见。
% @param axImage 原图显示的坐标轴句柄。
function nonlinearEnhanceModule(parentWindow, axImage)
    addpath('D:\Files\ProgramProject\MatLab\FinalWork\GUI\utils');
    if isempty(axImage.UserData)
        uialert(axImage.Parent, '请先上传图片！', '错误');
        return;
    end
    img = axImage.UserData;
    if size(img, 3) == 3
        grayscaleImg = rgbToGrayscale(img);
    else
        grayscaleImg = img;
    end
    parentWindow.Visible = 'off';
    % 创建非线性对比度增强窗口
    nonlinearWindow = uifigure('Name', '非线性对比度增强', 'WindowStyle', 'normal', 'Position', [100, 100, 800, 500]);
    % 显示原始灰度图像
    axOriginal = uiaxes(nonlinearWindow, ...
        'Position', [50, 250, 300, 200], ...
        'XTick', [], 'YTick', [], 'Box', 'on');
    imshow(grayscaleImg, 'Parent', axOriginal);
    axOriginal.Title.String = '原始灰度图像';
    % 显示增强后的图像
    axEnhanced = uiaxes(nonlinearWindow, ...
        'Position', [400, 250, 300, 200], ...
        'XTick', [], 'YTick', [], 'Box', 'on');
    % 对数增强按钮
    logEnhanceBtn = uibutton(nonlinearWindow, ...
        'Text', '对数增强', ...
        'Position', [50, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) logEnhance(grayscaleImg, axEnhanced));
    % 指数增强按钮
    expEnhanceBtn = uibutton(nonlinearWindow, ...
        'Text', '指数增强', ...
        'Position', [200, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) expEnhance(grayscaleImg, axEnhanced));
    % 返回按钮
    backButton = uibutton(nonlinearWindow, ...
        'Text', '返回', ...
        'Position', [650, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) goBack(parentWindow, nonlinearWindow));
end

%% 对数增强函数
% 该函数对图像进行对数增强，并显示增强后的图像。
%
% @param grayscaleImg 灰度图像。
% @param axEnhanced 增强后图像显示的坐标轴句柄。
function logEnhance(grayscaleImg, axEnhanced)
    enhancedImg = logContrastEnhancementManual(grayscaleImg);
    imshow(enhancedImg, 'Parent', axEnhanced);
    axEnhanced.Title.String = '对数增强结果';
end

%% 指数增强函数
% 该函数对图像进行指数增强，并显示增强后的图像。
%
% @param grayscaleImg 灰度图像。
% @param axEnhanced 增强后图像显示的坐标轴句柄。
function expEnhance(grayscaleImg, axEnhanced)
    enhancedImg = expContrastEnhancementManual(grayscaleImg);
    imshow(enhancedImg, 'Parent', axEnhanced);
    axEnhanced.Title.String = '指数增强结果';
end

%% RGB转灰度图像函数
% 该函数将RGB图像转换为灰度图像。
%
% @param img RGB图像。
% @return grayscaleImg 转换后的灰度图像。
function grayscaleImg = rgbToGrayscale(img)
    R = img(:, :, 1);
    G = img(:, :, 2);
    B = img(:, :, 3);
    grayscaleImg = uint8(0.2989 * double(R) + 0.5870 * double(G) + 0.1140 * double(B));
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
