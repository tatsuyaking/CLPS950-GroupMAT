
function import_stroop_data

data = readtable ("combined_stroop_data.csv");

disp(data)


participant_IDs = unique(data.Var1); %everything up until this point is the same as in the import_data script


    % Now we want to create a table with participant ID and success rate
    % for the Stroop task
    success_rate_table = table('Size', [length(participant_IDs), 8], ... %the number of rows is the number of participants, and there are 2 columns
                               'VariableTypes', {'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double'}, ...
                               'VariableNames', {'participant_ID', 'easy_not_easy', 'easy_reaction', 'hard_reaction','reaction_time_stroop','easy_success', 'hard_success', 'success_rate_stroop'});
    
    for i = 1:length(participant_IDs)
        current_ID = participant_IDs(i); % This is the same as before as well
        
        % Get the participant data
        participant_data = data(data.Var1 == current_ID, :);
        
        % Get the 3rd column values (assuming it's a binary column with 0s and 1s for failure or success)
        result = participant_data{:, 6};
        
        % Calculate the percentage of 1s, multiply by 100 to make a
        % percentage
        success_rate = sum(result == 1) / length(result) * 100; 

        %collects average reaction time
        avg_reaction = mean(participant_data{:,5});


        %Finding 'easy' trials, or trials where color matches word
        num_trials = size(participant_data, 1);
        for trial = 1:num_trials
            if participant_data{trial, 2} == participant_data{trial, 3}
                participant_data{trial,4} = 1;
            else
                participant_data{trial,4} = 0; %instead of making a new table, I am updating column 4 of the old table. The values in that column don't matter.
            end
        end


        
        %calculating rate of easy trials (should be 33%)
        easy_rate = sum(participant_data{:,4} == 1) / length(participant_data{:,4}) * 100;

        %calculating average reaction time for easy trials and hard trials
        
        easy_reaction_time = mean(participant_data{participant_data{:, 4} == 1, 5});
        hard_reaction_time = mean(participant_data{participant_data{:, 4} == 0, 5});
     
        %calculate success rate for easy and hard trials
 

        easy_success_rate = sum(participant_data{participant_data{:, 4} == 1, 6}) / sum(participant_data{:,4} == 1) * 100;
        hard_success_rate = sum(participant_data{participant_data{:, 4} == 0, 6}) / sum(participant_data{:,4} == 0) * 100;


        
        
        % Store the participant ID and success rate in the new table
        success_rate_table.participant_ID(i) = current_ID;
        success_rate_table.easy_not_easy(i) = easy_rate;
        success_rate_table.easy_reaction(i) = easy_reaction_time;
        success_rate_table.hard_reaction(i) = hard_reaction_time;
        success_rate_table.reaction_time_stroop(i) = avg_reaction;
        success_rate_table.easy_success(i) = easy_success_rate;
        success_rate_table.hard_success(i) = hard_success_rate;
        success_rate_table.success_rate_stroop(i) = success_rate;
    end
    assignin('base', 'success_rate_table', success_rate_table); % Add to workspace
end
