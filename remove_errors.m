


    
    avg_table = table();

    for id = 1:100
        
        clean_data = eval("participant_"+num2str(id));
    
        if istable(clean_data)
            success = clean_data{:, 3}; 
        else
            error('Input must be a table.');
        end
    
        numRows = size(clean_data, 1);
    
        if numRows == 0 || size(clean_data, 2) < 3
            error('Matrix must have at least 3 columns and at least 1 row.');
        end
    
        % Count the number of 1s in the third column
        success_count = sum(success == 1);
    
        % Check if more than 50% of the values in column 3 are 1
        if success_count > numRows / 2
            usable = 1;
        else
            usable = 0;
        end

        if usable == 1

                   
            rowsToKeep = clean_data{:, 3} == 1; 
            updated_clean_data = clean_data(rowsToKeep, :);  
            var_name = ['clean_participant_' num2str(id)]; 
            assignin('base', var_name, updated_clean_data);  

            % Calculate the average of column 4 for the updated data
            if size(updated_clean_data, 2) >= 4
                avg_value = mean(updated_clean_data{:, 4});  % Calculate the average of column 4
            else
                avg_value = NaN;  % If column 4 doesn't exist, return NaN
            end
    
            % Add the participant ID and average to the avg_table
            avg_table = [avg_table; table(id, avg_value, 'VariableNames', {'ParticipantID', 'reaction_times'})];

        else
            updated_clean_data = [];  % If 'usable' is 0, return an empty table
      
        end

    end


