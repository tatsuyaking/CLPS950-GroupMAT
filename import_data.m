
function import_data

data = readtable ("MAT_example_csv - Attention.csv");

x = data{:, :}; 
y = data{:, :}; 

b = zeros(1,10);


for a = 1:10
    sleep_quality = y == a;
    b(a) = mean(x(sleep_quality));
end

disp(b)

end