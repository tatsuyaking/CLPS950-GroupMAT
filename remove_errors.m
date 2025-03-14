function usable = remove_errors(id)

    % Ensure 'id' is a table and extract the third column as a table column
    if istable(id)
        success = id{:, 3};  % Use curly braces to extract the third column as a numeric array
    else
        error('Input must be a table.');
    end

    numRows = size(id, 1);

    if numRows == 0 || size(id, 2) < 3
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





    
end
