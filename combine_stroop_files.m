
numFiles = 10; %for 5 participants
combined_data = [];

for i = 1:numFiles
    
    %all files follow the same naming convention
    filename = sprintf('Stroop_Data_files/stroop_data%d.csv', i);
    
    %Import the data from the CSV file
    data = readtable(filename);
    
    %stack the data on top of each other
    combined_data = [combined_data; data];
    
end

%save the combined data to a new CSV file
writetable(combined_data, 'combined_stroop_data.csv');