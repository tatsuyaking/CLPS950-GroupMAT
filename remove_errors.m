


    
    avg_table = table(); %make a new table outside of the loop that will update every iteration of the loop

    for id = 1:100 %arbitrary length, the loop will just stop working when it runs out of participants
        
        clean_data = eval("participant_"+num2str(id)); %uses clean_data placeholder variable to store current participants data
    
        if istable(clean_data)
            success = clean_data{:, 3}; % Success/failure info is stored in column 3
        else
            error('Input must be a table.');
        end % Making sure the input will work
    
        numRows = size(clean_data, 1);
    
        if numRows == 0 || size(clean_data, 2) < 3
            error('Matrix must have at least 3 columns and at least 1 row.');
        end %making sure the size fits
    
        %count the number of 1s in the third column
        success_count = sum(success == 1);
    
        % check if more than 50% of the values in column 3 are 1
        if success_count > numRows / 2
            usable = 1;
        else
            usable = 0;
        end

        if usable == 1 %if the data is good, now we want to make a table of just succuesses
                   
            rowsToKeep = clean_data{:, 3} == 1; % Only column 3, and rows that are 1
            updated_clean_data = clean_data(rowsToKeep, :);  % Placeholder for clean data
            var_name = ['clean_participant_' num2str(id)]; % New table, now named "clean_..."
            assignin('base', var_name, updated_clean_data);  

            % With the clean data, now we want to calculate averages and
            % store them in a new table
            if size(updated_clean_data, 2) >= 4 % make sure there is a 4th column
                avg_value = mean(updated_clean_data{:, 4});  % Calculate the average of column 4
            else
                avg_value = NaN;  % If column 4 doesn't exist, return NaN
            end
    
            % Add the participant ID and average to the avg_table
            avg_table = [avg_table; table(id, avg_value, 'VariableNames', {'ParticipantID', 'reaction_times'})];


        elseif usable == 0 % If the data is not usable, we don't want to calculate averages for it, so we just add 0
            avg_table = [avg_table; table(id, 0, 'VariableNames', {'ParticipantID', 'reaction_times'})];
            % The number of rows should still be the same, so that it is
            % easier to combine later, which is why we don't just not
            % include the data

        else
            updated_clean_data = [];  
        end

    end


