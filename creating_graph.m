

function creating_graph

b = zeros(1,10);


for a = 1:10
    sleep_quality = y == a;
    b(a) = mean(x(sleep_quality));
end

disp(b)

end 

