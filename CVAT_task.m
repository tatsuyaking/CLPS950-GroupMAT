% Create a question pop-up to ask for participant ID
participantID = inputdlg('Enter Participant ID:', 'Participant Info', [1 50]);

% Cancel the task if the participant doesn't provide an ID
if isempty(participantID)
    return;
end

% Open a new screen with the task instructions
fig = figure('Color', 'w', 'MenuBar', 'none', 'ToolBar', 'none', ...
    'NumberTitle', 'off', 'Name', 'Instructions', 'Position', [300, 300, 1500, 1300]);

% Display the instructions
uicontrol('Style', 'text', 'String', ...
    ['Welcome to this experiment!' ...
    ' You will see a black cross at the center of your screen.' ...
    ' At random time intervals, a red circle will appear on top of that cross.' ...
    ' Your task is to press the SPACE key as quickly as possible when the red circle appears.' ...
    ' Press SPACE to start the task.'], ...
    'FontSize', 20, 'HorizontalAlignment', 'center', ...
    'BackgroundColor', 'w', 'Units', 'normalized', 'Position', [0.1 0.3 0.8 0.4]);

% Wait for SPACE key press to close the screen
waitforbuttonpress;
while ~strcmp(get(fig, 'CurrentCharacter'), ' ')
    waitforbuttonpress;
end

clc; close all; % close the screen and clear the command window
rng('shuffle'); % Ensure different random timings each time

numTrials = 10; % Number of trials

% Open a new screen on which the task will be displayed
fig = figure('Color', 'w', 'MenuBar', 'none', 'ToolBar', 'none', ...
    'NumberTitle', 'off', 'Name', 'Attention Task', 'Position', [300, 300, 1500, 1500]);
hold on; axis off; axis equal; % Ensure correct proportions

% Initializing the variables for the final data output
successes = 0; % Correct space bar presses
failures = 0; % Incorrect space bar presses
reactionTimes = []; % Store reaction times for correct responses

spacePressed = false; % track whether the space key is pressed

% Set key press function
set(fig, 'KeyPressFcn', @keyPressCallback)

% Key press callback function
function keyPressCallback(~, event)
global spacePressed % make the spacePressed variable exist outside of this loop
    if strcmp(event.Key, 'space')
        spacePressed = true;
    end
end

% Loop the task numTrials times 
for i = 1:numTrials 
    spacePressed = false;

    % Draw a black fixation cross in the center of the screen
    cla; % Clear previous drawings
    plot([0 0], [-0.007 0.007], 'k', 'LineWidth', 2); % Vertical line
    plot([-0.007 0.007], [0 0], 'k', 'LineWidth', 2); % Horizontal line
    xlim([-0.2 0.2]); ylim([-0.2 0.2]); 

    % Keep fixation cross for a random time (2-5 sec)
    randomInterval = 2 + (5-2) * rand; % Random number between 2 and 5
    startTime = tic; % start timer function
        % if space pressed while cross is on screen, count a failure
        while toc(startTime) < randomInterval
            pause(0.01);
            if spacePressed
                failures = failures + 1;
                spacePressed = false;
            end
        end

    % draw red circle on top of the fixation cross
    rectangle('Position', [-0.01, -0.01, 0.02, 0.02], 'Curvature', [1, 1], 'FaceColor', 'r', 'EdgeColor', 'r');
    xlim([-0.1 0.1]); ylim([-0.1 0.1]);

    % Start timer to calculate reaction time
    circleStartTime = tic; % timer starts
    spacePressed = false; % Reset spacePressed

    % Wait for space bar press or until the circle disappears
    while toc(circleStartTime) < 0.4 % circle remains on screen for 400 ms
        pause(0.01); % Small pause to check for key press
        % if space pressed while circle on screen, count success and
        % reaction time
        if spacePressed
            reactionTime = toc(circleStartTime) * 1000;
            successes = successes + 1;
            reactionTimes = [reactionTimes, reactionTime];
            spacePressed = false;
            break;
        end
    end

    pause(0.4 - toc(circleStartTime)); % Ensure the red circle is on for 400 ms total

    % remove red circle but keep the cross
    cla; % Clear figure again
    plot([0 0], [-0.007 0.007], 'k', 'LineWidth', 2); % Vertical line
    plot([-0.007 0.007], [0 0], 'k', 'LineWidth', 2); % Horizontal line
    xlim([-0.2 0.2]); ylim([-0.2 0.2]);

end

% Save data to the CSV file after the task
    csvFileName = 'CVAT_data.csv'; % name the data file
    if exist(filename, 'file') == 2
        fid = fopen(filename, 'a'); % Append data to the file if it exists
    else
        fid = fopen(filename, 'w'); % Create new file if it doesn't exist
        fprintf(fid, 'Participant_ID, Successes, Failures, ReactionTimes\n'); % column names
    end
    fileID = fopen(csvFileName, 'a'); % Open file for appending
    fprintf(fileID, '%s,%d,%d,%s\n', participantID{1}, successes, failures, mat2str(mean(reactionTimes)));
    fclose(fileID);

pause(1);
close(fig); % close the task screen

% open a new screen with a thank you message
fig2 = figure('Color', 'w', 'MenuBar', 'none', 'ToolBar', 'none', ...
    'NumberTitle', 'off', 'Name', 'End of Experiment', 'Position', [300, 300, 1500, 1500]);

% display thank you message
uicontrol('Style', 'text', 'String', ...
    ['Thank you for participating in this experiment!' ...
    ' Press SPACE to close this window.'], ...
    'FontSize', 20, 'HorizontalAlignment', 'center', ...
    'BackgroundColor', 'w', 'Units', 'normalized', 'Position', [0.1 0.3 0.8 0.4]);

% Wait for space key to be pressed and close the screen
waitforbuttonpress;
while ~strcmp(get(fig2, 'CurrentCharacter'), ' ')
    waitforbuttonpress;
end

close(fig2); % close the screen












