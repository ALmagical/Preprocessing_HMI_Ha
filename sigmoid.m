% sigmoid funciton
function [out] = sigmoid(in)
    % out = 1 / (1 + e^(-in))
    % by luojie
    % 2016-7-24
    out = 1 ./ (1 + exp(-in));
end