function targetExtractionModule(parentWindow)
    parentWindow.Visible = 'off';
    targetWindow = uifigure('Name', '目标提取', 'WindowStyle', 'normal', 'Position', [100, 100, 850, 600]);
    axOriginal = uiaxes(targetWindow, ...
        'Position', [50, 200, 300, 300], ...
        'XTick', [], 'YTick', [], 'Box', 'on');
    axOriginal.Title.String = '原图';
    axResult = uiaxes(targetWindow, ...
        'Position', [450, 200, 300, 300], ...
        'XTick', [], 'YTick', [], 'Box', 'on');
    axResult.Title.String = '目标提取结果';
    uibutton(targetWindow, ...
        'Text', '上传图片', ...
        'Position', [50, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) uploadImage(axOriginal));
    uibutton(targetWindow, ...
        'Text', '阈值分割', ...
        'Position', [200, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) extractThresholdTarget(axOriginal, axResult));
    uibutton(targetWindow, ...
        'Text', '边缘检测 (Sobel)', ...
        'Position', [350, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) extractSobelTarget(axOriginal, axResult));
    uibutton(targetWindow, ...
        'Text', '颜色直方图分离', ...
        'Position', [500, 50, 150, 30], ...
        'ButtonPushedFcn', @(btn, event) extractColorTarget(axOriginal, axResult));
    uibutton(targetWindow, ...
        'Text', '返回', ...
        'Position', [700, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) goBack(parentWindow, targetWindow));
end
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
function extractThresholdTarget(axOriginal, axResult)
    if isempty(axOriginal.UserData)
        uialert(axOriginal.Parent, '请先上传图片！', '错误');
        return;
    end
    img = axOriginal.UserData;
    saveDir = 'D:\Files\ProgramProject\MatLab\FinalWork\results\';
    if ~exist(saveDir, 'dir')
        mkdir(saveDir);
    end
    binaryImg = thresholdSegmentationManual(img, fullfile(saveDir, 'threshold_result.png'));
    imshow(binaryImg, 'Parent', axResult);
    axResult.Title.String = '阈值分割结果';
    axResult.UserData = binaryImg;
end
function extractSobelTarget(axOriginal, axResult)
    if isempty(axOriginal.UserData)
        uialert(axOriginal.Parent, '请先上传图片！', '错误');
        return;
    end
    img = axOriginal.UserData;
    saveDir = 'D:\Files\ProgramProject\MatLab\FinalWork\results\';
    if ~exist(saveDir, 'dir')
        mkdir(saveDir);
    end
    edgeImg = sobelEdgeDetectionManual(img, fullfile(saveDir, 'sobel_result.png'));
    imshow(edgeImg, 'Parent', axResult);
    axResult.Title.String = '边缘检测 (Sobel) 结果';
    axResult.UserData = edgeImg;
end
function extractColorTarget(axOriginal, axResult)
    if isempty(axOriginal.UserData)
        uialert(axOriginal.Parent, '请先上传图片！', '错误');
        return;
    end
    img = axOriginal.UserData;
    saveDir = 'D:\Files\ProgramProject\MatLab\FinalWork\results\';
    if ~exist(saveDir, 'dir')
        mkdir(saveDir);
    end
    targetRange = [0.2, 0.4];
    binaryImg = colorHistogramSegmentationManual(img, targetRange, fullfile(saveDir, 'color_result.png'));
    imshow(binaryImg, 'Parent', axResult);
    axResult.Title.String = '颜色直方图分离结果';
    axResult.UserData = binaryImg;
end
function goBack(parentWindow, currentWindow)
    delete(currentWindow);
    parentWindow.Visible = 'on';
end
