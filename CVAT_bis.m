participantID = inputdlg('Enter Participant ID:', 'Participant Info', [1 50]);

% Check if the user canceled the input
if isempty(participantID)
    disp('Experiment aborted.');
    return;
end

% Save participant ID to a CSV file
filename = 'participant_data.csv';
if exist(filename, 'file') == 2
    fid = fopen(filename, 'a'); % Append mode
else
    fid = fopen(filename, 'w'); % Create new file
    fprintf(fid, 'ParticipantID\n'); % Write header
end
fprintf(fid, '%s\n', participantID{1}); % Write participant ID
fclose(fid);

disp(['Participant ID saved: ' participantID{1}]);

% Create a figure window for instructions
fig = figure('Color', 'w', 'MenuBar', 'none', 'ToolBar', 'none', ...
    'NumberTitle', 'off', 'Name', 'Instructions', 'Position', [300, 300, 1500, 1300]);

% Display instructions
uicontrol('Style', 'text', 'String', ...
    ['Welcome to this experiment!' ...
    ' You will see a black cross at the center of your screen.' ...
    ' At random time intervals, a red circle will appear on top of that cross.' ...
    ' Your task is to press the SPACE key as quickly as possible when the red circle appears.' ...
    ' Press SPACE to start the task.'], ...
    'FontSize', 18, 'HorizontalAlignment', 'center', ...
    'BackgroundColor', 'w', 'Units', 'normalized', 'Position', [0.1 0.3 0.8 0.4]);

% Wait for SPACE key press
waitforbuttonpress;
while ~strcmp(get(fig, 'CurrentCharacter'), ' ')
    waitforbuttonpress;
end

clc; clear; close all;
rng('shuffle'); % Ensure different random timings each time

numTrials = 3; % Number of trials

% Create a figure window (only once)
fig = figure('Color', 'w', 'MenuBar', 'none', 'ToolBar', 'none', ...
    'NumberTitle', 'off', 'Name', 'Attention Task', 'Position', [300, 300, 1500, 1500]);
hold on; axis off; axis equal; % Ensure correct proportions

% Data storage
successes = 0; % Correct space bar presses
failures = 0; % Incorrect space bar presses
reactionTimes = []; % Store reaction times for correct responses

for i = 1:numTrials
    % 1️⃣ Draw fixation cross (always visible)
    cla; % Clear previous drawings
    plot([0 0], [-0.007 0.007], 'k', 'LineWidth', 2); % Vertical line
    plot([-0.007 0.007], [0 0], 'k', 'LineWidth', 2); % Horizontal line
    xlim([-0.2 0.2]); ylim([-0.2 0.2]);

    % Keep fixation cross for a random time (2-5 sec)
    randomInterval = 2 + (5-2) * rand; % Random number between 2 and 5
    pause(randomInterval);

    % 2️⃣ Show red circle ON TOP of the fixation cross
    rectangle('Position', [-0.01, -0.01, 0.02, 0.02], 'Curvature', [1, 1], 'FaceColor', 'r', 'EdgeColor', 'r');
    xlim([-0.1 0.1]); ylim([-0.1 0.1]);

    % Start reaction timer
    tic;
    keyPressed = '';
    set(fig, 'KeyPressFcn', @(src, event) assignin('base', 'keyPressed', event.Key));

    % Wait for space bar press or timeout
    elapsedTime = 0;
    while elapsedTime < 0.5
        pause(0.01); % Small pause to check for key press
        elapsedTime = toc 

        if strcmp(keyPressed, 'space') % Space bar pressed
            reactionTimes = [reactionTimes; elapsedTime * 1000]; % Convert to ms
            successes = successes + 1;
            break;
        end
    end

    pause(0.5 - elapsedTime); % Ensure the red circle is on for 0.5 sec total

    % 3️⃣ Remove the red circle (but keep the cross)
    cla; % Clear figure again
    plot([0 0], [-0.007 0.007], 'k', 'LineWidth', 2); % Vertical line
    plot([-0.007 0.007], [0 0], 'k', 'LineWidth', 2); % Horizontal line
    xlim([-0.2 0.2]); ylim([-0.2 0.2]);
end

close(fig);

% Show "Thank You" Message in a New Figure
fig2 = figure('Color', 'w', 'MenuBar', 'none', 'ToolBar', 'none', ...
    'NumberTitle', 'off', 'Name', 'End of Experiment', 'Position', [300, 300, 1500, 1500]);

uicontrol('Style', 'text', 'String', ...
    ['Thank you for participating in this experiment!' ...
    ' Press SPACE to close this window.'], ...
    'FontSize', 20, 'HorizontalAlignment', 'center', ...
    'BackgroundColor', 'w', 'Units', 'normalized', 'Position', [0.1 0.3 0.8 0.4]);

% Wait for SPACE key press
waitforbuttonpress;
while ~strcmp(get(fig, 'CurrentCharacter'), ' ')
    waitforbuttonpress;
end

clc; clear; close all;

if strcmp(keyPressed, 'space')
    failures = failures + 1;
end

csvFileName = 'participant_data.csv';
fileID = fopen(csvFileName, 'a'); % Open file for appending
fprintf(fileID, '%s,%d,%d,%s\n', participantID, successes, failures, mat2str(reactionTimes));
fclose(fileID);










