
function import_stroop_data

data = readtable ("MAT_example_csv - Stroop.csv");

disp(data)


participant_IDs = unique(data.participant_ID);

    success_rate_table = table('Size', [length(participant_IDs), 2], ...
                               'VariableTypes', {'double', 'double'}, ...
                               'VariableNames', {'participant_ID', 'success_rate'});
    
    for i = 1:length(participant_IDs)
        current_ID = participant_IDs(i);
        
        % Get the participant data
        participant_data = data(data.participant_ID == current_ID, :);
        
        % Get the 3rd column values (assuming it's a binary column with 0s and 1s)
        third_column = participant_data{:, 3};
        
        % Calculate the percentage of 1s (success rate)
        success_rate = sum(third_column == 1) / length(third_column) * 100;
        
        % Store the participant ID and success rate in the new table
        success_rate_table.participant_ID(i) = current_ID;
        success_rate_table.success_rate(i) = success_rate;
    end
    assignin('base', 'success_rate_table', success_rate_table);
end
