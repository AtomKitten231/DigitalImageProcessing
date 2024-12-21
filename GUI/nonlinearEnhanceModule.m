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
    nonlinearWindow = uifigure('Name', '非线性对比度增强', 'WindowStyle', 'normal', 'Position', [100, 100, 800, 500]);
    axOriginal = uiaxes(nonlinearWindow, ...
        'Position', [50, 250, 300, 200], ...
        'XTick', [], 'YTick', [], ...
        'Box', 'on');
    imshow(grayscaleImg, 'Parent', axOriginal);
    axOriginal.Title.String = '原始灰度图像';
    axEnhanced = uiaxes(nonlinearWindow, ...
        'Position', [400, 250, 300, 200], ...
        'XTick', [], 'YTick', [], ...
        'Box', 'on');
    logEnhanceBtn = uibutton(nonlinearWindow, ...
        'Text', '对数增强', ...
        'Position', [50, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) logEnhance(grayscaleImg, axEnhanced));
    expEnhanceBtn = uibutton(nonlinearWindow, ...
        'Text', '指数增强', ...
        'Position', [200, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) expEnhance(grayscaleImg, axEnhanced));
    backButton = uibutton(nonlinearWindow, ...
        'Text', '返回', ...
        'Position', [650, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) goBack(parentWindow, nonlinearWindow));
end
function logEnhance(grayscaleImg, axEnhanced)
    enhancedImg = logContrastEnhancement(grayscaleImg);
    imshow(enhancedImg, 'Parent', axEnhanced);
    axEnhanced.Title.String = '对数增强结果';
end
function expEnhance(grayscaleImg, axEnhanced)
    enhancedImg = expContrastEnhancement(grayscaleImg);
    imshow(enhancedImg, 'Parent', axEnhanced);
    axEnhanced.Title.String = '指数增强结果';
end
function grayscaleImg = rgbToGrayscale(img)
    R = img(:, :, 1);
    G = img(:, :, 2);
    B = img(:, :, 3);
    grayscaleImg = uint8(0.2989 * double(R) + 0.5870 * double(G) + 0.1140 * double(B));
end

function goBack(parentWindow, currentWindow)
    delete(currentWindow);
    parentWindow.Visible = 'on';
end
