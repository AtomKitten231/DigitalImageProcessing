%% 噪声与滤波模块函数
% 该函数创建一个新窗口，提供上传图片、添加噪声、选择滤波类型等功能。
%
% @param parentWindow 父窗口句柄，关闭子窗口时恢复可见。
function noiseFilterModule(parentWindow)
    parentWindow.Visible = 'off';
    % 创建噪声与滤波窗口
    filterWindow = uifigure('Name', '噪声与滤波', 'WindowStyle', 'normal', 'Position', [100, 100, 800, 500]);
    axOriginal = uiaxes(filterWindow, 'Position', [50, 200, 300, 250], 'XTick', [], 'YTick', [], 'Box', 'on');
    axOriginal.Title.String = '原始图像';
    axNoisy = uiaxes(filterWindow, 'Position', [450, 200, 300, 250], 'XTick', [], 'YTick', [], 'Box', 'on');
    axNoisy.Title.String = '加噪图像';
    % 上传图片按钮
    uibutton(filterWindow, 'Text', '上传图片', 'Position', [50, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) uploadImage(axOriginal, axNoisy));
    % 添加噪声按钮
    uibutton(filterWindow, 'Text', '添加噪声', 'Position', [200, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) chooseNoiseType(axOriginal, axNoisy));
    % 空间域滤波按钮
    uibutton(filterWindow, 'Text', '空间域滤波', 'Position', [350, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) spatialFilterModule(axNoisy, filterWindow));
    % 频率域滤波按钮
    uibutton(filterWindow, 'Text', '频率域滤波', 'Position', [500, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) frequencyFilterModule(axNoisy, filterWindow));
    % 返回按钮
    uibutton(filterWindow, 'Text', '返回', 'Position', [650, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) goBack(parentWindow, filterWindow));
end

%% 上传图像并显示原图和加噪图像
% 该函数用于上传图片并显示原图和加噪图像。
%
% @param axOriginal 原图显示的坐标轴句柄。
% @param axNoisy 加噪图像显示的坐标轴句柄。
function uploadImage(axOriginal, axNoisy)
    [file, path] = uigetfile({'*.jpg;*.png;*.bmp', '图像文件 (*.jpg, *.png, *.bmp)'; '*.*', '所有文件 (*.*)'}, '选择一张图片');
    if isequal(file, 0)
        return;
    end
    img = imread(fullfile(path, file));
    imshow(img, 'Parent', axOriginal);
    axOriginal.Title.String = '原始图像';
    axOriginal.UserData = img;
    cla(axNoisy);
    axNoisy.Title.String = '加噪图像';
end

%% 选择噪声类型函数
% 该函数允许用户选择噪声类型（高斯噪声或均匀噪声），并显示相应的参数输入框。
%
% @param axOriginal 原图显示的坐标轴句柄。
% @param axNoisy 加噪图像显示的坐标轴句柄。
function chooseNoiseType(axOriginal, axNoisy)
    if isempty(axOriginal.UserData)
        uialert(axOriginal.Parent, '请先上传图片！', '错误');
        return;
    end
    % 创建选择噪声类型窗口
    noiseWindow = uifigure('Name', '选择噪声类型', 'WindowStyle', 'modal', 'Position', [300, 300, 400, 400]);
    uilabel(noiseWindow, 'Text', '选择噪声类型:', 'Position', [50, 300, 100, 30]);
    noiseTypeDropdown = uidropdown(noiseWindow, 'Items', {'高斯噪声', '均匀噪声'}, ...
        'Position', [150, 300, 200, 30], 'ValueChangedFcn', @(dd, event) updateParameterFields(dd.Value, noiseWindow));
    updateParameterFields('高斯噪声', noiseWindow);
    % 应用噪声按钮
    uibutton(noiseWindow, 'Text', '应用', 'Position', [150, 50, 100, 30], ...
        'ButtonPushedFcn', @(btn, event) applyNoise(noiseTypeDropdown.Value, noiseWindow, axOriginal, axNoisy));
end

%% 更新噪声参数输入框
% 该函数根据选择的噪声类型更新相应的参数输入框。
%
% @param noiseType 选择的噪声类型。
% @param noiseWindow 噪声窗口句柄。
function updateParameterFields(noiseType, noiseWindow)
    delete(findall(noiseWindow, 'Type', 'uilabel', 'Tag', 'paramLabel'));
    delete(findall(noiseWindow, 'Type', 'uieditfield', 'Tag', 'paramField'));
    switch noiseType
        case '高斯噪声'
            uilabel(noiseWindow, 'Text', '均值:', 'Position', [50, 250, 100, 30], 'Tag', 'paramLabel');
            uieditfield(noiseWindow, 'numeric', 'Position', [150, 250, 200, 30], 'Value', 0, 'Tag', 'paramField');
            uilabel(noiseWindow, 'Text', '标准差:', 'Position', [50, 200, 100, 30], 'Tag', 'paramLabel');
            uieditfield(noiseWindow, 'numeric', 'Position', [150, 200, 200, 30], 'Value', 0.01, 'Tag', 'paramField');
        case '均匀噪声'
            uilabel(noiseWindow, 'Text', '噪声范围:', 'Position', [50, 250, 100, 30], 'Tag', 'paramLabel');
            uieditfield(noiseWindow, 'numeric', 'Position', [150, 250, 200, 30], 'Value', 0.1, 'Tag', 'paramField');
    end
end

%% 应用噪声函数
% 该函数根据选择的噪声类型和参数对图像添加噪声。
%
% @param noiseType 选择的噪声类型。
% @param noiseWindow 噪声参数窗口句柄。
% @param axOriginal 原图显示的坐标轴句柄。
% @param axNoisy 加噪图像显示的坐标轴句柄。
function applyNoise(noiseType, noiseWindow, axOriginal, axNoisy)
    img = im2double(axOriginal.UserData);
    paramFields = noiseWindow.Children(arrayfun(@(x) isprop(x, 'Tag') && strcmp(x.Tag, 'paramField'), noiseWindow.Children));
    if isempty(paramFields)
        uialert(noiseWindow, '未找到参数输入框，请检查界面更新逻辑！', '错误');
        return;
    end
    params = arrayfun(@(x) x.Value, paramFields, 'UniformOutput', true);
    switch noiseType
        case '高斯噪声'
            noisyImg = img + params(2) * randn(size(img)) + params(1);
        case '均匀噪声'
            noisyImg = img + params(1) * (rand(size(img)) - 0.5);
    end
    noisyImg = im2uint8(mat2gray(noisyImg));
    imshow(noisyImg, 'Parent', axNoisy);
    axNoisy.UserData = noisyImg;
    axNoisy.Title.String = [noiseType, ' (加噪图像)'];
    delete(noiseWindow);
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
