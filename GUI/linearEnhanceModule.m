function linearEnhanceModule(parentWindow, axImage)
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
    linearWindow = uifigure('Name', '线性对比度增强', 'WindowStyle', 'normal', 'Position', [100, 100, 800, 400]);
    axOriginal = uiaxes(linearWindow, ...
        'Position', [50, 100, 300, 250], ...
        'XTick', [], 'YTick', [], ...
        'Box', 'on');
    imshow(grayscaleImg, 'Parent', axOriginal);
    axOriginal.Title.String = '原始灰度图像';
    axEnhanced = uiaxes(linearWindow, ...
        'Position', [400, 100, 300, 250], ...
        'XTick', [], 'YTick', [], ...
        'Box', 'on');
    enhancedImg = linearContrastEnhancement(grayscaleImg);
    imshow(enhancedImg, 'Parent', axEnhanced);
    axEnhanced.Title.String = '线性对比度增强结果';
    backButton = uibutton(linearWindow, ...
        'Text', '返回', ...
        'Position', [350, 20, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) goBack(parentWindow, linearWindow));
end
function goBack(parentWindow, currentWindow)
    delete(currentWindow);
    parentWindow.Visible = 'on';
end
