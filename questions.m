prompt = {'What is the participant ID#?', ...
    'How many hours of sleep did you get last night? Please enter a single or double digit number as a response, eg. "8".', ...
    'How would you rate the quality of your sleep last night on a scale of 1-10? Please enter a single or double digit number as a response, eg. "6".', ...
    'Which task did you complete first—task A (with the red circle) or B (with the color words)? Please enter "A" or "B" as your answer.'};

responses = inputdlg(prompt, 'Sleep questionnaire', [2 50]);

% Check if user canceled the input
if isempty(responses)
    return;
end

% Extract responses and convert numeric values
participantID = responses{1}; 
sleepHours = str2double(responses{2});  
sleepQuality = str2double(responses{3});  
firstTask = responses{4};  

% Define CSV filename
filename = 'sleep_questionnaire_data.csv';

% Check if file exists and open in the appropriate mode
if exist(filename, 'file') == 2
    fid = fopen(filename, 'a'); % Append mode
else
    fid = fopen(filename, 'w'); % Create new file
    fprintf(fid, 'Participant_ID,Sleep_hours,Sleep_quality,First_task\n'); % Write header
end

% Write data to CSV file
fprintf(fid, '%s,%d,%d,%s\n', participantID, sleepHours, sleepQuality, firstTask);
fclose(fid);