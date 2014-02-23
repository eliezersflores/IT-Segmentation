% Adapting log2 to do log2(0) = 0

function [y] = Log2(x)

    y = log2(x);
    y(~isfinite(y)) = 0;
       
end

