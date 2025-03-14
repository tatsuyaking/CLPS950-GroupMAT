
function import_data

data = readtable ("MAT_example_csv - Attention.csv");

disp(data)


participant_IDs = unique(data.participant_ID);

for i = 1:length(participant_IDs)
    current_ID = participant_IDs(i);
    
    participant_data = data(data.participant_ID == current_ID, :);
    
    var_name = ['participant_' num2str(current_ID)]; 
    assignin('base', var_name, participant_data);  
end


end
