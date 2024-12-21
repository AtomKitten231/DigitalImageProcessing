function grayscaleModule(parentWindow)
    parentWindow.Visible = 'off';
    grayscaleWindow = uifigure('Name', '灰度化处理', 'WindowStyle', 'normal', 'Position', [100, 100, 640, 400]);
    axImage = uiaxes(grayscaleWindow, ...
        'Position', [50, 100, 250, 250], ...
        'XTick', [], 'YTick', [], ...
        'Box', 'on');
    axImage.Title.String = '原始图像';
    axGrayscaleImage = uiaxes(grayscaleWindow, ...
        'Position', [340, 100, 250, 250], ...
        'XTick', [], 'YTick', [], ...
        'Box', 'on');
    axGrayscaleImage.Title.String = '灰度图像';
    uploadBtn = uibutton(grayscaleWindow, ...
        'Text', '上传图片', ...
        'Position', [50, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) uploadImage(axImage, axGrayscaleImage));
    grayscaleBtn = uibutton(grayscaleWindow, ...
        'Text', '灰度化', ...
        'Position', [200, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) convertToGrayscale(axImage, axGrayscaleImage));
    backButton = uibutton(grayscaleWindow, ...
        'Text', '返回', ...
        'Position', [470, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) goBack(parentWindow, grayscaleWindow));
end
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

function convertToGrayscale(axImage, axGrayscaleImage)
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
    imshow(grayscaleImg, 'Parent', axGrayscaleImage);
    axGrayscaleImage.Title.String = '灰度图像';
end
function goBack(parentWindow, currentWindow)
    delete(currentWindow);
    parentWindow.Visible = 'on';
end
