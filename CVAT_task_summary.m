function CVAT_task_summary

data = readtable ("combined_stroop_data.csv");

disp(data)


participant_IDs = unique(data.Var1); %everything up until this point is the same as in the import_data script


    % Now we want to create a table with participant ID and success rate
    % for the Stroop task
    task_summary_table = table('Size', [length(participant_IDs), 3], ... %the number of rows is the number of participants, and there are 3 columns
                               'VariableTypes', {'double', 'double', 'double'}, ...
                               'VariableNames', {'participant_ID', 'success_rate_CVAT','avg_reaction_CVAT'});
    
    for i = 1:length(participant_IDs)
        current_ID = participant_IDs(i); % This is the same as before as well
        
        % Get the participant data 
        participant_data = data(data.Var1 == current_ID, :);
                
        
        % add total successes and failures, then divide that by number of
        % success 
        success_rate = participant_data{i,2}/(participant_data{i,2} + participant_data{i,3}) * 100; 

        
        %storing average reaction -- right now just a placeholder
        avg_reaction = 3;

        
        %Store the participant ID and success rate in the new table
        task_summary_table.participant_ID(i) = current_ID;
        task_summary_table.success_rate_CVAT(i) = success_rate;
        task_summary_table.avg_reaction_CVAT(i) = avg_reaction;
    end
    assignin('base', 'CVAT_summary_table', task_summary_table); % Add to workspace
end
