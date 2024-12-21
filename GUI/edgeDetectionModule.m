function edgeDetectionModule(parentWindow)
    addpath('D:\Files\ProgramProject\MatLab\FinalWork\GUI\utils');
    parentWindow.Visible = 'off';
    edgeWindow = uifigure('Name', '边缘提取', 'WindowStyle', 'normal', 'Position', [100, 100, 800, 500]);
    axOriginal = uiaxes(edgeWindow, ...
        'Position', [50, 150, 300, 300], ...
        'XTick', [], 'YTick', [], 'Box', 'on');
    axOriginal.Title.String = '原图';
    axResult = uiaxes(edgeWindow, ...
        'Position', [450, 150, 300, 300], ...
        'XTick', [], 'YTick', [], 'Box', 'on');
    axResult.Title.String = '结果图';
    uibutton(edgeWindow, ...
        'Text', '上传照片', ...
        'Position', [100, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) uploadImage(axOriginal));
    uibutton(edgeWindow, ...
        'Text', '边缘提取', ...
        'Position', [300, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) selectEdgeDetection(axOriginal, axResult));
    uibutton(edgeWindow, ...
        'Text', '返回', ...
        'Position', [500, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) goBack(parentWindow, edgeWindow));
end
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
    uibutton(selectionWindow, ...
        'Text', '应用', ...
        'Position', [150, 50, 100, 30], ...
        'ButtonPushedFcn', @(btn, event) applyEdgeDetection(axOriginal, axResult, dropdown.Value, selectionWindow));
end
function applyEdgeDetection(axOriginal, axResult, method, selectionWindow)
    img = axOriginal.UserData;
    switch method
        case 'Robert'
            edgeImg = robertEdge(img);
        case 'Prewitt'
            edgeImg = prewittEdge(img);
        case 'Sobel'
            edgeImg = sobelEdge(img);
        case '拉普拉斯'
            edgeImg = laplacianEdge(img);
    end
    imshow(edgeImg, 'Parent', axResult);
    axResult.Title.String = [method, ' 边缘提取结果'];
    delete(selectionWindow);
end
function goBack(parentWindow, edgeWindow)
    delete(edgeWindow);
    parentWindow.Visible = 'on';
end
