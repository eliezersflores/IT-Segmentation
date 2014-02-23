function [invDict,Coeff] = informationTheoretic(Y,D0,XD0,dictSize,atomsToSelect)
    % Selection:

    tic;
    
    disp('Information-theoretic:');

    objFunct = -Inf(dictSize,1);

    K = cov(XD0');

    % Greedy Algorithm:

    % Indexes of selected/non-selected atoms:

    D = []; % Empty.
    Dn = 1:dictSize; % All atoms.

    % Parameters (lambda1, lambda2 and lambda3) estimation:

    disp('Estimating parameters...');

    I1 = zeros(1,dictSize);
    I2 = zeros(1,dictSize);

    for d = 1:dictSize % For each atom:

        I1(d) = dictSelection(K,d,D,Dn,1);
        I2(d) = dictRepresentation(Y,D0,XD0,d,D,1);

    end;

    lambda1 = 1; % Dictionary selection.
    lambda2 = max(I2)/max(I1); % Dictionary representation.

    fprintf('lambda1 = %.2f\nlambda2 = %.2f\nlambda3 = %.2f\n',lambda1,lambda2,lambda2);

    % Finding the first best atom:

    disp('Finding the atom number 1');

    for d = 1:dictSize % For each atom:

        objFunct(d) = lambda1*I1(d) + lambda2*I2(d);

    end;

    [~,optElement] = max(objFunct);
    objFunct = -Inf(dictSize,1); % Clear objFunct after to select the best atom.

    D = [D optElement];
    Dn = setdiff(Dn,D);

    % Finding the others best atoms:

    tic;

    for j = 2:atomsToSelect % Finding j-th atom:

        fprintf('Finding the atom number %d\n',j);

        for idx = 1:numel(Dn); % For each atom in Dn:
            d = Dn(idx); 
            objFunct(d) = lambda1*dictSelection(K,d,D,Dn,0) + lambda2*dictRepresentation(Y,D0,XD0,d,D,0);              
        end;

        [~,optElement] = max(objFunct);
        objFunct = -Inf(dictSize,1); % Clear objFunct after to select the best atom.

        D = [D optElement];
        Dn = setdiff(Dn,D);

        toc;

    end;

    Dopt = D0(:,D);

    % Update:

    disp('Updating dictionary...');

    invDict = pinv(Dopt'*Dopt)*Dopt';
    Coeff = invDict*Y;

    toc;

end

