
function import_stroop_data

data = readtable ("MAT_example_csv - Stroop.csv");

disp(data)


participant_IDs = unique(data.participant_ID); %everything up until this point is the same as in the import_data script


    % Now we want to create a table with participant ID and success rate
    % for the Stroop task
    success_rate_table = table('Size', [length(participant_IDs), 2], ... %the number of rows is the number of participants, and there are 2 columns
                               'VariableTypes', {'double', 'double'}, ...
                               'VariableNames', {'participant_ID', 'success_rate'});
    
    for i = 1:length(participant_IDs)
        current_ID = participant_IDs(i); % This is the same as before as well
        
        % Get the participant data
        participant_data = data(data.participant_ID == current_ID, :);
        
        % Get the 3rd column values (assuming it's a binary column with 0s and 1s for failure or success)
        result = participant_data{:, 3};
        
        % Calculate the percentage of 1s, multiply by 100 to make a
        % percentage
        success_rate = sum(result == 1) / length(result) * 100; 
        
        % Store the participant ID and success rate in the new table
        success_rate_table.participant_ID(i) = current_ID;
        success_rate_table.success_rate(i) = success_rate;
    end
    assignin('base', 'success_rate_table', success_rate_table); % Add to workspace
end
