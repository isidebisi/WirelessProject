function output = mapGrayFunc(input)
    output = zeros(length(input),1);
    output(all(input == [0 1], 2)) = -1/sqrt(2) + 1/sqrt(2) *1i;
    output(all(input == [0 0], 2)) = 1/sqrt(2) + 1/sqrt(2) *1i;
    output(all(input == [1 0], 2)) = 1/sqrt(2) - 1/sqrt(2) *1i;
    output(all(input == [1 1], 2)) = -1/sqrt(2) - 1/sqrt(2) *1i;
end