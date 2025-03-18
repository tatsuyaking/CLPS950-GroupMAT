

data = readtable ("MAT_example_csv - Survey.csv");

disp(data)

assignin('base', 'survey_table', data);

table_combined = [survey_table, avg_table, success_rate_table]; % NOT WORKING RN






