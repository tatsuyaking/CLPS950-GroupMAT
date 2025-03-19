
%----------------------------------------------------------------------
%               Setup--this code comes from the Matlab demo and
%               allows for our program to run on any size screen
%----------------------------------------------------------------------

% Clear the workspace
Screen('Preference', 'SkipSyncTests', 1);
close all;
clear;
sca; 

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

% We'll use this information to format text on the screen

% Get the screen size
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Calculate the vertical position halfway between the center and bottom
centerY = screenYpixels / 2;
halfwayDownY = centerY + (screenYpixels / 4); % Adjust this value for positioning
halfwayUpY = centerY - (screenYpixels / 4);

%---------------------------------------------------------------------- 
%                            Adding images
%----------------------------------------------------------------------

imageFile = 'keyboard.jpg';  % Specify the path to JPG file 

if exist(imageFile, 'file')
    img = imread(imageFile);  % Read the image
else
    error('Image file not found: %s', imageFile);
end

% Convert the image to texture
imageTexture = Screen('MakeTexture', window, img); 


%----------------------------------------------------------------------
%                       Timing Information--helps us capture time
%               information for reaction time 
%----------------------------------------------------------------------

% Interstimulus interval time in seconds and frames
isiTimeSecs = 1;
isiTimeFrames = round(isiTimeSecs / ifi);

% Numer of frames to wait before re-drawing
waitframes = 1;


%----------------------------------------------------------------------
%            Keyboard information---left key corresponds with
%   "red," down key corresponds with "green," right key corresponds with
%   "blue"
%----------------------------------------------------------------------

% Define the keyboard keys that are listened for. We will be using the left
% and right arrow keys as response keys for the task and the escape key as
% a exit/reset key
escapeKey = KbName('ESCAPE');
leftKey = KbName('LeftArrow');
rightKey = KbName('RightArrow');
downKey = KbName('DownArrow');


%----------------------------------------------------------------------
%            Colors in words and RGB--we continued with the demo's
%           three colors since we appreciated  
%----------------------------------------------------------------------

%  We are going to use three colors for this demo. Red, Green and blue.
wordList = {'Red', 'Green', 'Blue'};
rgbColors = [1 0 0; 0 1 0; 0 0 1];

% Make the matrix which will determine our condition combinations
condMatrixBase = [sort(repmat([1 2 3], 1, 3)); repmat([1 2 3], 1, 3)];

% Number of trials per condition. We set this to one for this demo, to give
% us a total of 9 trials.
trialsPerCondition = 1;

% Duplicate the condition matrix to get the full number of trials
condMatrix = repmat(condMatrixBase, 1, trialsPerCondition);

% Get the size of the matrix
[~, numTrials] = size(condMatrix);

% Randomise the conditions
shuffler = Shuffle(1:numTrials);
condMatrixShuffled = condMatrix(:, shuffler);


%----------------------------------------------------------------------
%                     Make a response matrix
%----------------------------------------------------------------------

% This is a six row matrix the first row will record an ID for the subject,
% the second row the word presented (1 = red, 2 = blue, 3 = green),
% the third row the color the word it written in (same number-to-color key),
% the fourth row the key they respond with, the fifth row the time they took
% to make a response and in the final row 1 if they were sucessful and 0 if not.
respMat = nan(6, numTrials);


%----------------------------------------------------------------------
%                       Experimental loop
%----------------------------------------------------------------------

% Animation loop: we loop for the total number of trials

for trial = 1:numTrials

    % Word and color number
    wordNum = condMatrixShuffled(1, trial);
    colorNum = condMatrixShuffled(2, trial);

    % The color word and the color it is drawn in
    theWord = wordList(wordNum);
    theColor = rgbColors(colorNum, :);

    % Cue to determine whether a response has been made
    respToBeMade = true;

    
    % If this is the first trial we present a start screen and wait for a
    % key-press
    if trial == 1
        
        DrawFormattedText(window, 'Welcome to the stroop task! \n\n Click the arrow that corresponds with the color of the text (NOT the word written!).',...
            'center', 'center', black);
        DrawFormattedText(window, 'Click the LEFT arrow if color shown is RED, DOWN for GREEN, and RIGHT for BLUE! \n\n Press Any Key To Begin',...
            'center', halfwayDownY, black);
   
        % Draw the image halfway above the center
    
        [imgWidth, imgHeight, ~] = size(img);  % Get image dimensions

        % Scale the width by 8 times
        imgWidth = imgWidth * 8;  % Want to stretch out image to make more readable

        % this positions images horizontally centered and vertically above
        % the center
        imageX = xCenter - imgWidth / 2;  % Center the image horizontally
        imageY = halfwayUpY - imgHeight / 2;  % Position the image halfway above the center
    
        % Draw the image texture at the calculated position
        Screen('DrawTexture', window, imageTexture, [], [imageX, imageY, imageX + imgWidth, imageY + imgHeight]);

        % Flip the screen to display everything
        Screen('Flip', window);
        
        KbStrokeWait;
    end

    % Flip again to sync us to the vertical retrace at the same time as
    % drawing our fixation point
    Screen('DrawDots', window, [xCenter; yCenter], 10, black, [], 2);
    vbl = Screen('Flip', window);

    % Make a note of the time stamp
    iStart = vbl;

    % Now we present the isi interval with fixation point minus one frame
    % because we presented the fixation point once already when getting a
    % time stamp. We use the waitframes functionality to do this without
    % the need of a loop

    % Draw the fixation point
    Screen('DrawDots', window, [xCenter; yCenter], 10, black, [], 2);

    % Flip to the screen
    vbl = Screen('Flip', window, vbl + ((isiTimeFrames - 1) - 0.5) * ifi);

    % Get the presentation time of the ISI
    iEnd = vbl;
    isiRecDuration = iEnd - iStart;

    % Now present the word in continuous loops until the person presses a
    % key to respond. We take a time stamp before and after to calculate
    % our reaction time. We could do this directly with the vbl time stamps,
    % but for the purposes of this introductory demo we will use GetSecs.
    %
    % The person should be asked to respond to either the written word or
    % the color the word is written in. They make thier response with the
    % three arrow key. They should press "Left" for "Red", "Down" for
    % "Green" and "Right" for "Blue".
    %
    % We could also use Keyboard Queues which offer a potentially more
    % accurate way in which to get keyboard resoponses. See the Keyboiard
    % Queue version of this demo.
    %
    % Additionally, we poll the keyboard each time we update the screen. We
    % could alternatively flip to the screen once, then loop over purely
    % the keyboard polling and clear the screen once a button is pressed.
    while respToBeMade == true

        % Draw the word
        DrawFormattedText(window, char(theWord), 'center', 'center', theColor);

        % Display the keyboard instructions along with trials

        % Draw the image halfway below the center
    
        [imgWidth, imgHeight, ~] = size(img);  % Get image dimensions

        % Scale the width by 6 times and cut height in half
        imgWidth = imgWidth * 6;  % Want to stretch out image to make more readable
        imgHeight = imgHeight / 2;  % Shrink the height by half

        % this positions images horizontally centered and vertically above
        % the center
        imageX = xCenter - imgWidth / 2;  % Center the image horizontally
        imageY = halfwayUpY + (4*imgHeight);  % Position the image halfway above the center
    
        % Convert the image to grayscale (black and white) for the
        % experimental loop --see google doc for expanded reason for why I
        % chose NOT to show color (essentially it makes the Stroop task too
        % easy since subjects can just match color with the key below)
        imgBW = rgb2gray(img);  % Convert the image to grayscale
        imageTextureBW = Screen('MakeTexture', window, imgBW);  % Create texture for grayscale image

        % Draw the image texture at the calculated position
        Screen('DrawTexture', window, imageTextureBW, [], [imageX, imageY, imageX + imgWidth, imageY + imgHeight]);

        % Check the keyboard. The person should press the
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

        % Flip to the screen
        vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);

    end

    % Record the reaction time, calculated by the use of flip timestamps
    rt = vbl - iEnd;

    % Record the trial data into out data matrix
    respMat(1, trial) = 0;
    respMat(2, trial) = wordNum;
    respMat(3, trial) = colorNum;
    respMat(4, trial) = response;
    respMat(5, trial) = rt;
    

    % we don't use isiRecDuration (actual time between
    % fixation point and the start of next stimulus) in our demo but we
    % decided to keep it in since it would be easy to add it to the output
    % matrix if one were to use it in futher work

    % respMat(1 , trial) = isiRecDuration;
    

end

for ii = 1:9
    if respMat(3, ii) == respMat(4, ii)
        respMat(6, ii) = 1;
    else
        respMat(6, ii) = 0;
    end
end

% Export the matrix to a CSV file -- flipping the columns and rows to make
% file the correct format for our analysis

writematrix(respMat', 'matrix_data.csv');

% End of experiment screen. We clear the screen once they have made their
% response
DrawFormattedText(window, 'Experiment Finished \n\n Press Any Key To Exit',...
    'center', 'center', black);
Screen('Flip', window);
KbStrokeWait;
sca;