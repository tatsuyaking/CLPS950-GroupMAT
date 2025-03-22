prompt = {'What is the participant ID#?', 'How many hours of sleep did you get last night? Please enter a single or double digit number as a response, eg. "8".', 'How would you rate the quality of your sleep last night on a scale of 1-10? Please enter a single or double digit number as a response, eg. "6".', 'Which task did you complete first—task A (with the red circle) or B (with the color words)? Please enter "A" or "B" as your asnwer.'};
title = 'Sleep questionnaire';
dims = [2 100]; 
answers = inputdlg(prompt, title, dims);


T = table(string(answers(1)), string(answers(2)), string(answers(3)), string(answers(4)), ...
          'VariableNames', {'Participant ID', 'Hours', 'Quality', 'First task'});
writetable(T, 'responses.csv');
disp('Answers saved to "responses.csv"');




