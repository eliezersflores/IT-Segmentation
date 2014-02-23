function [f] = dictDiscrimination(XD0,d,D,C,first)

    % Based on paper:
    % Information-theoretic Dictionary Learning for Image Classification
    % Qiang Qiu, Vishal M. Patel and Rama Chellappa
   
    % Only two classes problems.
    
    % Using entropy of multivariate normal distribution definition from:
    % http://en.wikipedia.org/wiki/Multivariate_normal_distribution

    % Initial decomposition : Y = D0 * XD0 (KSVD + OMP).
    
    % XD0: initial coefficients.
    % d: index of current atom.
    % D: index of selected atoms of Dictionary.
    % C: Class labels.
    
    XD0_0 = XD0(:,C==0);
    XD0_1 = XD0(:,C==1);
    c0 = (numel(C(C==0))/numel(C));
    c1 = (numel(C(C==1))/numel(C));

    if first == 1 % if D is empty:
        
        f = entropy(XD0(d,:)) - c0*entropy(XD0_0(d,:)) - c1*entropy(XD0_1(d,:));
        
    else % otherwise:

        f = entropy(XD0([D d],:)) - c0*entropy(XD0_0([D d],:)) - c1*entropy(XD0_1([D d],:));

    end;
    
end

