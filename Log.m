% Adapting log to do log(0) = 0

function [y] = Log(x)

    y = log(x);
    y(~isfinite(y)) = 0;
       
end

