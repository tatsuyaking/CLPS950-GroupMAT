% storing the four questions in one variable
prompt = {'What is the participant ID#?', ...
    'How many hours of sleep did you get last night? Please enter a single or double digit number as a response, eg. "8".', ...
    'How would you rate the quality of your sleep last night on a scale of 1-10? Please enter a single or double digit number as a response, eg. "6".', ...
    'Which task did you complete first—task A (with the red circle) or B (with the color words)? Please enter "A" or "B" as your answer.'};

% creates an input window for the questionnaire
responses = inputdlg(prompt, 'Sleep questionnaire', [2 50]);

% Check if the participants didn't enter anything and closed the window
if isempty(responses)
    return;
end

% convert the responses into numeric values
participantID = responses{1}; 
sleepHours = str2double(responses{2});  
sleepQuality = str2double(responses{3});  
firstTask = responses{4};  

% Define the name of the csv file
filename = 'sleep_questionnaire_data.csv';

% Check if file exists and/or open the existing file to append a new row
if exist(filename, 'file') == 2
    fid = fopen(filename, 'a'); % Append a row
else
    fid = fopen(filename, 'w'); % Create new file
    fprintf(fid, 'Participant_ID,Sleep_hours,Sleep_quality,First_task\n'); % column names
end

% add data to the csv file
fprintf(fid, '%s,%d,%d,%s\n', participantID, sleepHours, sleepQuality, firstTask);
fclose(fid);