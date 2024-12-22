%% 主函数，创建主窗口并初始化UI按钮
% 该函数创建一个图形窗口，并添加多个按钮，每个按钮对应一个不同的图像处理模块。
% 每个按钮被点击时，都会打开相应的图像处理模块。
function mainWindow()
    % 创建一个UI图形窗口，标题为'图像处理工具'
    homeWindow = uifigure('Name', '图像处理工具', 'WindowStyle', 'normal', 'Position', [100, 100, 800, 650]);
    
    % 直方图处理按钮
    histogramButton = uibutton(homeWindow, ...
        'Text', '直方图处理', ...
        'Position', [350, 550, 100, 50], ...
        'ButtonPushedFcn', @(btn, event) histogramModule(homeWindow));
    
    % 灰度化处理按钮
    grayscaleButton = uibutton(homeWindow, ...
        'Text', '灰度化处理', ...
        'Position', [350, 480, 100, 50], ...
        'ButtonPushedFcn', @(btn, event) grayscaleModule(homeWindow));
    
    % 几何变换按钮
    geometryButton = uibutton(homeWindow, ...
        'Text', '几何变换', ...
        'Position', [350, 410, 100, 50], ...
        'ButtonPushedFcn', @(btn, event) geometryTransformModule(homeWindow));
    
    % 噪声与滤波按钮
    noiseFilterButton = uibutton(homeWindow, ...
        'Text', '噪声与滤波', ...
        'Position', [350, 340, 100, 50], ...
        'ButtonPushedFcn', @(btn, event) noiseFilterModule(homeWindow));
    
    % 边缘提取按钮
    edgeDetectionButton = uibutton(homeWindow, ...
        'Text', '边缘提取', ...
        'Position', [350, 270, 100, 50], ...
        'ButtonPushedFcn', @(btn, event) edgeDetectionModule(homeWindow));
    
    % 目标提取按钮
    targetExtractionButton = uibutton(homeWindow, ...
        'Text', '目标提取', ...
        'Position', [350, 200, 100, 50], ...
        'ButtonPushedFcn', @(btn, event) targetExtractionModule(homeWindow));
    
    % 特征提取按钮
    featureExtractionButton = uibutton(homeWindow, ...
        'Text', '特征提取', ...
        'Position', [350, 130, 100, 50], ...
        'ButtonPushedFcn', @(btn, event) featureExtractionModule(homeWindow));
    
    % 退出按钮
    exitButton = uibutton(homeWindow, ...
        'Text', '退出', ...
        'Position', [350, 60, 100, 50], ...
        'ButtonPushedFcn', @(btn, event) closeApp(homeWindow));
end

%% 关闭应用程序的函数
% 该函数用于关闭主窗口，从而退出应用程序。
%
% @param homeWindow 主窗口的句柄（uifigure），该窗口将被关闭。
function closeApp(homeWindow)
    delete(homeWindow);
end
