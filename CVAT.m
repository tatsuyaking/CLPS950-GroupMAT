prompt = {'What is the participant ID#?'};
title = 'Participant ID#';
dims = [1 50]; % [height, width]
answer = inputdlg(prompt, title, dims);

T = table(string(answer(1)), ...
          'VariableNames', {'Participant ID'});
writetable(T, 'CVAT.csv');
disp('Answers saved to "CVAT.csv"');





clc; clear; close all;
rng('shuffle'); % Ensure random timing each time the script runs

numTrials = 10; % Number of repetitions

for i = 1:numTrials
    % 1️⃣ Show fixation cross
    fig = figure('Color', 'w', 'MenuBar', 'none', 'ToolBar', 'none', ...
        'NumberTitle', 'off', 'Name', 'Fixation Cross', 'Position', [300, 300, 1500, 1500]);
    hold on; axis off;
    
    % Draw fixation cross
    plot([0 0], [-0.01 0.01], 'k', 'LineWidth', 2); % Vertical line
    plot([-0.007 0.007], [0 0], 'k', 'LineWidth', 2); % Horizontal line
    xlim([-0.2 0.2]); ylim([-0.2 0.2]);
    
    % Keep fixation cross for a random duration between 2 and 5 seconds
    randomInterval = 2 + (5-2) * rand; % Random number between 2 and 5
    pause(randomInterval);
    close(fig);
    
    % 2️⃣ Show red circle for 0.5 seconds
    fig = figure('Color', 'w', 'MenuBar', 'none', 'ToolBar', 'none', ...
        'NumberTitle', 'off', 'Name', 'Red Circle', 'Position', [300, 300, 1500, 1500]);
    hold on; axis off; 
    
    % Draw red circle
    rectangle('Position', [-0.08, 0.04, 0.01, 0.0155], 'Curvature', [1, 1], 'FaceColor', 'r', 'EdgeColor', 'r');
    xlim([-0.1 0.1]); ylim([-0.1 0.1]);
    
    pause(0.5); % Keep red circle for 0.5 seconds
    close(fig);
end

disp('Experiment finished.');

















