function [f] = dictRepresentation(Y,D0,XD0,d,D,first)

    % Based on paper:
    % Information-theoretic Dictionary Learning for Image Classification
    % Qiang Qiu, Vishal M. Patel and Rama Chellappa

    % Initial decomposition : Y = D0 * XD0 (KSVD + OMP).
    
    % Y: data set;
    % D0: initial dictionary.
    % XD0: initial coefficients.
    % d: index of current atom.
    % D: index of selected atoms of dictionary.
    
    if first == 1 % if D is empty:

        Dictionary = D0(:,d);
        Coefficients = XD0(d,:);
                
    else % otherwise:

        Dictionary = D0(:,[D d]);
        Coefficients = XD0([D d],:);

    end;
    
    N = size(Y,2);
    f = 0;
    
    for i = 1:N

        r = Y(:,i) - Dictionary*Coefficients(:,i);
        
        % Avoiding zero division:
        if var(r) ~= 0 
            prob = exp((-1/(2*var(r)))*((norm(r))^2));
        else
            prob = 1;
        end;
        
        f = f + prob*Log(prob);

    end;

end

