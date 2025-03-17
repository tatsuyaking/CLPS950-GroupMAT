% Initialize Psychtoolbox
PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 1); % Disable sync tests for demo
[window, windowRect] = PsychImaging('OpenWindow', 0, [0, 0, 0]);
Screen('TextSize', window, 50);
Screen('TextColor', window, [255, 255, 255]); % Set default text color to white

% Define the colors and words
colors = {'red', 'green', 'blue', 'yellow'};
words = {'RED', 'GREEN', 'BLUE', 'YELLOW'};

% Set the key mappings
KbName('UnifyKeyNames'); 
keyList = {'r', 'g', 'b', 'y'}; % 'r' for red, 'g' for green, 'b' for blue, 'y' for yellow

% Number of trials
numTrials = 10;

% Set up random trials (congruent and incongruent)
trials = cell(numTrials, 2); % Column 1: word, Column 2: correct color

% Create random trials (half congruent, half incongruent)
for i = 1:numTrials
    if rand < 0.5
        % Congruent trial: Word matches color
        wordIndex = randi(4);
        trials{i, 1} = words{wordIndex}; % Word
        trials{i, 2} = colors{wordIndex}; % Correct color
    else
        % Incongruent trial: Word does not match color
        wordIndex = randi(4);
        colorIndex = randi(4);
        while colorIndex == wordIndex
            colorIndex = randi(4); % Ensure the color doesn't match the word
        end
        trials{i, 1} = words{wordIndex}; % Word
        trials{i, 2} = colors{colorIndex}; % Correct color
    end
end

% Display Instructions
DrawFormattedText(window, 'Welcome to the Stroop Task!\n\nPress the key corresponding to the color of the word.\n\nPress any key to begin...', 'center', 'center', [255, 255, 255]);
Screen('Flip', window);
KbWait; % Wait for a key press to start

% Start the trials
correctResponses = 0;
for i = 1:numTrials
    % Get the word and the correct color for this trial
    word = trials{i, 1};
    correctColor = trials{i, 2};
    
    % Draw the word with the correct color
    switch correctColor
        case 'red'
            Screen('TextColor', window, [255, 0, 0]);
        case 'green'
            Screen('TextColor', window, [0, 255, 0]);
        case 'blue'
            Screen('TextColor', window, [0, 0, 255]);
        case 'yellow'
            Screen('TextColor', window, [255, 255, 0]);
    end
    
    % Draw the word
    DrawFormattedText(window, word, 'center', 'center', [255, 255, 255]);
    Screen('Flip', window);
    
    % Get the response (start a timer)
    startTime = GetSecs;
    response = '';
    while GetSecs - startTime < 2 % Wait for 2 seconds for the response
        [keyIsDown, ~, keyCode] = KbCheck;
        if keyIsDown
            if any(keyCode)
                response = KbName(keyCode);
                break;
            end
        end
    end
    
    % Check if the response was correct
    if ~isempty(response)
        responseColor = keyList{find(strcmp(keyList, response))};
        if strcmp(responseColor, correctColor)
            correctResponses = correctResponses + 1;
        end
    end
    
    % Inter-trial interval (brief pause)
    Screen('Flip', window);
    WaitSecs(0.5);
end

% End of the experiment - show the results
DrawFormattedText(window, sprintf('Experiment over! You got %d out of %d correct!', correctResponses, numTrials), 'center', 'center', [255, 255, 255]);
Screen('Flip', window);
WaitSecs(2); % Wait for 2 seconds to show result

% Close the screen
sca;