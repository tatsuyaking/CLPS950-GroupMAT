
function import_data

data = readtable ("sleep_cycle_productivity.csv");

x = data{:, 13}; 
y = data{:, 15}; 

b = zeros(1,10);


for a = 1:10
    sleep_quality = y == a;
    b(a) = mean(x(sleep_quality));
end

disp(b)

end