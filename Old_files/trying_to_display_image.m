% Working with a matlab demo to adapt showing my keyboard image visually

% Initialize Psychtoolbox
PsychDefaultSetup(2);

% Open a window on the screen
[window, windowRect] = PsychImaging('OpenWindow', 0, [0 0 0]);

% Load the image
imageFile = 'keyboard_image.png';  % Provide the full path to your image file
img = imread(imageFile);

% Ensure image is in RGB format and convert to uint8 if necessary
if size(img, 3) == 1
    % If the image is grayscale, convert it to RGB by repeating the channels
    img = repmat(img, [1 1 3]);
end

% Convert the image to uint8 if it's not already
img = uint8(img);

% Convert the image into a texture for Psychtoolbox
imageTexture = Screen('MakeTexture', window, img);

% Draw the image on the screen
Screen('DrawTexture', window, imageTexture);

% Flip the screen to display the image
Screen('Flip', window);

% Wait for a key press to close the window
KbWait;

% Close the screen
Screen('CloseAll');