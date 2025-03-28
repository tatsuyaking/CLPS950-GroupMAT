
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               Setup--this code comes from the Matlab demo and
%               allows for our program to run on any size screen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Clear the workspace
Screen('Preference', 'SkipSyncTests', 1);
close all
clear;
sca; 

% Should be manually altered each run (future version could increment this
% automatically
currentID = 10;

% Setup PTB with some default values
PsychDefaultSetup(2);

% Seed the random number generator
rng('shuffle')

% Set the screen number to the external secondary monitor if there is one
% connected
screenNumber = max(Screen('Screens'));

% Define black, white and grey
white = WhiteIndex(screenNumber);
grey = white / 2;
black = BlackIndex(screenNumber);

% Open the screen
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey, [], 32, 2);

% Flip to clear
Screen('Flip', window);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);

% Set the text size
Screen('TextSize', window, 60);

% Get the center coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% Set the blend funciton for the screen
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% Set maximum priority level
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);

% I use this information to format text on the screen

% Get the screen size
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Calculate vertical position halfway between the center and bottom of
% screen
centerY = screenYpixels / 2;
halfwayDownY = centerY + (screenYpixels / 4);
halfwayUpY = centerY - (screenYpixels / 4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%                            Showing the keyboard image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

imageFile = 'keyboard.jpg';  % path to JPG file 

if exist(imageFile, 'file')
    img = imread(imageFile);  % reads image
else
    error('Image file not found: %s', imageFile);
end

% Converts the image to texture allowing image to be shown
imageTexture = Screen('MakeTexture', window, img); 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       Timing inforration--helps us capture time
%               information for reaction time 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Interstimulus interval time in seconds and frames
isiTimeSecs = 1;
isiTimeFrames = round(isiTimeSecs / ifi);

% Numer of frames to wait before re-drawing
waitframes = 1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            Keyboard information---left key corresponds with
%   "red," down key corresponds with "green," right key corresponds with
%   "blue"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Here I specify which keyboard keys will perform specific functions.
% Left, right, and down arrow keys capture responses, and escape exits

escapeKey = KbName('ESCAPE');
leftKey = KbName('LeftArrow');
rightKey = KbName('RightArrow');
downKey = KbName('DownArrow');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            Colors (as words and RGB)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  we are using red, green and blue as our color responses
wordList = {'Red', 'Green', 'Blue'};
rgbColors = [1 0 0; 0 1 0; 0 0 1];

% this matrix determines random combinations of the word and the color it's
% written in. We then duplicate this condition matrix for each trial
condMatrixBase = [sort(repmat([1 2 3], 1, 3)); repmat([1 2 3], 1, 3)];

condMatrix = repmat(condMatrixBase, 1, 1);

[~, numTrials] = size(condMatrix); %gets size of matrix

% randomizes conditions
shuffler = Shuffle(1:numTrials);
condMatrixShuffled = condMatrix(:, shuffler);


% This generates a 6-row response matrix. The first row records an ID for the subject,
% the second row the word presented (1 = red, 2 = blue, 3 = green),
% the third row the color the word it written in (same number-to-color key),
% the fourth row the key they respond with, the fifth row the time they took
% to make a response and in the final row 1 if they were sucessful and 0 if not.

respMat = nan(6, numTrials);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       loop of the experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for trial = 1:numTrials

    % Word and color number
    wordNum = condMatrixShuffled(1, trial);
    colorNum = condMatrixShuffled(2, trial);

    % The color word and the color it is drawn in
    theWord = wordList(wordNum);
    theColor = rgbColors(colorNum, :);

    % determines whether response has been made
    respToBeMade = true;

    
    % If this is trial one, show a start screen and wait for any key-press
    if trial == 1
        
        DrawFormattedText(window, 'Welcome to the stroop task! \n\n Click the arrow that corresponds with the color of the text (NOT the word written!).',...
            'center', 'center', black);
        DrawFormattedText(window, 'Click the LEFT arrow if color shown is RED, DOWN for GREEN, and RIGHT for BLUE! \n\n Press Any Key To Begin',...
            'center', halfwayDownY, black);
   
        % Draw image halfway above the center
    
        [imgWidth, imgHeight, ~] = size(img);  % Get image dimensions

        % Sretch out image to make more readable
        imgWidth = imgWidth * 8;  % Scale the width by 8 times

        % Position images horizontally centered and vertically above the center
        imageX = xCenter - imgWidth / 2;  % Center the image horizontally
        imageY = halfwayUpY - imgHeight / 2;  % Position the image halfway above the center
    
        % Draw image texture at the calculated position
        Screen('DrawTexture', window, imageTexture, [], [imageX, imageY, imageX + imgWidth, imageY + imgHeight]);

        % Flip screen to display everything
        Screen('Flip', window);
        
        KbStrokeWait;
    end

    % Progress to the next screen and syncs vertical retrace at same time as
    % drawing fixation point (the dot that appears between trials)
    Screen('DrawDots', window, [xCenter; yCenter], 10, black, [], 2);
    vbl = Screen('Flip', window);

    iStart = vbl; % notes time stamp

    % Show isi interval with fixation point minus one frame to help
    % find reaction time

    % Draws fixation point
    Screen('DrawDots', window, [xCenter; yCenter], 10, black, [], 2);

    % Flips to the screen
    vbl = Screen('Flip', window, vbl + ((isiTimeFrames - 1) - 0.5) * ifi);

    % Get the presentation time of the ISI to help capture reaction time
    iEnd = vbl;

    % Show word until person presses a key to respond ("Left" for "Red",
    % "Down" for "Green" and "Right" for "Blue"), taking time stamp before
    % and after to calculate reaction time.

    while respToBeMade == true

        % Draw word
        DrawFormattedText(window, char(theWord), 'center', 'center', theColor);

        % Display the keyboard instructions along with trials

        % Draw the image halfway below the center
    
        [imgWidth, imgHeight, ~] = size(img);  % Get image dimensions

        % Scale the width by 6 times and cut height in half
        imgWidth = imgWidth * 6;  % Want to stretch out image to make more readable
        imgHeight = imgHeight / 2;  % Shrink the height by half

        % Positions images horizontally centered and vertically above the center
        imageX = xCenter - imgWidth / 2;  % Center the image horizontally
        imageY = halfwayUpY + (4*imgHeight);  % Position the image halfway above the center
    
        % Convert the image to grayscale (black and white) for the
        % experimental loop --essentially it makes the Stroop task too
        % easy since subjects can just match color with the key below
        imgBW = rgb2gray(img);  % Convert the image to grayscale
        imageTextureBW = Screen('MakeTexture', window, imgBW);  % Create texture for grayscale image

        % Draw the image texture at the calculated position
        Screen('DrawTexture', window, imageTextureBW, [], [imageX, imageY, imageX + imgWidth, imageY + imgHeight]);

        % Saves keyboard response
        [keyIsDown,secs, keyCode] = KbCheck;
        if keyCode(escapeKey)
            ShowCursor;
            sca;
            return
        elseif keyCode(leftKey)
            response = 1;
            respToBeMade = false;
        elseif keyCode(downKey)
            response = 2;
            respToBeMade = false;
        elseif keyCode(rightKey)
            response = 3;
            respToBeMade = false;
        end

        vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);  % flips the screen

    end

    % Records reaction time calculated by the use of flip timestamps
    rt = vbl - iEnd;

    % Records trial data into out data matrix
    respMat(1, trial) = currentID;
    respMat(2, trial) = wordNum;
    respMat(3, trial) = colorNum;
    respMat(4, trial) = response;
    respMat(5, trial) = rt; 

end

% Determines the sucessfulness of the trial by checking that the color key
% pressed matches the color of the image (by seeing if the 3rd and 4th
% columns matched)

for ii = 1:numTrials 
    if respMat(3, ii) == respMat(4, ii)
        respMat(6, ii) = 1; % saves a 1 in the 6th column if response was
                            % appropriate for the color of word shown
    else
        respMat(6, ii) = 0;
    end
end 


% Creates a new csv file for each particpant ID

fileName = ['Stroop_Data_files/stroop_data', num2str(currentID), '.csv'];



% Exports the matrix to a CSV file -- flipping the columns and rows to make
% file the correct format for our analysis

writematrix(respMat', fileName);

% Display the end experiment screen and clears screen once participant makes their response

DrawFormattedText(window, 'Experiment Finished \n\n Press Any Key To Exit',...
    'center', 'center', black);
Screen('Flip', window);
KbStrokeWait;
sca;