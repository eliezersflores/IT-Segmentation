function [f] = dictSelection(K,d,D,Dn,first)

    % Based on paper:
    % Sparse Dictionary-based Representation and Recognition of Action Attributes
    % Qiang Qiu, Zhuolin Jiang and Rama Chellappa

    % Initial decomposition : Y_nxN = D0_nxm * XD0_mxN (KSVD + OMP).

    % K: covariance (mxm) of X; 
    % d: index of current atom.
    % D: index of selected atoms of Dictionary.
    % Dn: index of non-selected atoms of Dictionary.

    if first == 1 % if D is empty:
        
        f = K(d,d) / (K(d,d) - K(Dn~=d,d)'*K(Dn~=d,Dn~=d)*K(Dn~=d,d));
        
    else % otherwise:

        f = ( K(d,d) - K(D,d)'*K(D,D)*K(D,d) ) / ( K(d,d) - K(Dn~=d,d)'*K(Dn~=d,Dn~=d)*K(Dn~=d,d) );

    end;

end

