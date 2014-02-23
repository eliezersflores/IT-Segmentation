function [H] = entropy(X)

%   Returns the entropy H of a matrix X, where X (mxN) has N vectors in
%   R^m.

    m = size(X,1);
    H = (m/2)*(1+Log(2*pi))+(1/2)*Log(det(cov(X')));

end

