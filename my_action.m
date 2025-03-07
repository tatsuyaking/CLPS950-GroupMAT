function [my_msg] = my_action(is_sunny)

    is_sunny = true;
    if is_sunny
        my_msg = 'I will go to the park';
    else
        my_msg = 'I will stay home'; 
    end
    disp(my_msg)  

end

