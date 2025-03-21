

%plot(table_combined, "sleep_hours", "success_rate");
x = table_combined{:, 'sleep_hours'};  
y = table_combined{:, 'success_rate_stroop'};

%bar_labels = {1:9};  % Labels for bar graph


% Example data for demonstration
%x = 1:10;  % X-axis data for both plots
%y = rand(1, 10) * 10;  % Y-axis data for scatter plot

variables = 'sleep_hours';

fig = figure;


% First subplot: Scatter plot
subplot(1, 2, 1);
scatter(x, y, 100, 'MarkerEdgeColor', 'black', 'MarkerFaceColor', [0.529, 0.808, 0.922]); 
title('Sleep/Success', 'FontSize', 14, 'FontWeight', 'bold'); 
xlabel('Sleep Hours', 'FontSize', 12);  
ylabel('Success Rate', 'FontSize', 12);  
grid on;  
set(gca, 'GridLineStyle', '--', 'GridAlpha', 0.7);  
%xlim([0, 11]); 
%ylim([0, 10]);  


%saving the figure into the workspace with the name being 'what variables
%it looks at' + "_figure"
variable_name = [variables, '_figure']; 
variable_name = string(variable_name);
assignin('base', variable_name, fig);

