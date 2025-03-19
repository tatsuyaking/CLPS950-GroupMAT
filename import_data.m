
function import_data

data = readtable ("MAT_example_csv - Attention.csv"); % import csv into code

disp(data)


participant_IDs = unique(data.participant_ID); % Extracts number of unique values in participant_ID section

for i = 1:length(participant_IDs) 
%for each participant ID, creates a new table with just that participants data

    current_ID = participant_IDs(i);
    
    participant_data = data(data.participant_ID == current_ID, :);
    %for whatever ID the loop is on, the participant_data variable holds
    %that participants data
    
    var_name = ['participant_' num2str(current_ID)]; % Makes a unique name for each ID
    assignin('base', var_name, participant_data); % Saves new table 
end

data = readtable ("MAT_example_csv - Survey.csv");

disp(data)

assignin('base', 'survey_table', data);

end
