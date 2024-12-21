function noiseFilterModule(parentWindow)
    parentWindow.Visible = 'off';
    filterWindow = uifigure('Name', '噪声与滤波', 'WindowStyle', 'normal', 'Position', [100, 100, 800, 500]);
    axOriginal = uiaxes(filterWindow, 'Position', [50, 200, 300, 250], 'XTick', [], 'YTick', [], 'Box', 'on');
    axOriginal.Title.String = '原始图像';
    axNoisy = uiaxes(filterWindow, 'Position', [450, 200, 300, 250], 'XTick', [], 'YTick', [], 'Box', 'on');
    axNoisy.Title.String = '加噪图像';
    uibutton(filterWindow, 'Text', '上传图片', 'Position', [50, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) uploadImage(axOriginal, axNoisy));
    uibutton(filterWindow, 'Text', '添加噪声', 'Position', [200, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) chooseNoiseType(axOriginal, axNoisy));
    uibutton(filterWindow, 'Text', '空间域滤波', 'Position', [350, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) spatialFilterModule(axNoisy, filterWindow));
    uibutton(filterWindow, 'Text', '频率域滤波', 'Position', [500, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) frequencyFilterModule(axNoisy, filterWindow));
    uibutton(filterWindow, 'Text', '返回', 'Position', [650, 50, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) goBack(parentWindow, filterWindow));
end

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

function chooseNoiseType(axOriginal, axNoisy)
    if isempty(axOriginal.UserData)
        uialert(axOriginal.Parent, '请先上传图片！', '错误');
        return;
    end
    noiseWindow = uifigure('Name', '选择噪声类型', 'WindowStyle', 'modal', 'Position', [300, 300, 400, 400]);
    uilabel(noiseWindow, 'Text', '选择噪声类型:', 'Position', [50, 300, 100, 30]);
    noiseTypeDropdown = uidropdown(noiseWindow, 'Items', {'高斯噪声', '均匀噪声'}, ...
        'Position', [150, 300, 200, 30], 'ValueChangedFcn', @(dd, event) updateParameterFields(dd.Value, noiseWindow));
    updateParameterFields('高斯噪声', noiseWindow);
    uibutton(noiseWindow, 'Text', '应用', 'Position', [150, 50, 100, 30], ...
        'ButtonPushedFcn', @(btn, event) applyNoise(noiseTypeDropdown.Value, noiseWindow, axOriginal, axNoisy));
end

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


function goBack(parentWindow, currentWindow)
    delete(currentWindow);
    parentWindow.Visible = 'on';
end
