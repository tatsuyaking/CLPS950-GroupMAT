
data = readtable ("sleep_cycle_productivity.csv");

x = data{:, 13};  % Column 2 as the x-axis data
y = data{:, 15};  % Column 3 as the y-axis data

b = [0 0 0 0 0 0 0 0 0 0];


for a = 1:10
    sleep_quality = y == a;
    b(a) = mean(x(sleep_quality));
end

disp(b)

