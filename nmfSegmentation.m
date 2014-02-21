function [mask] = nmfSegmentation(image)

   
    [M, N, K] = size(image);

    img = double(image);
    
    r = imageNormalize(img(:,:,1));
    g = imageNormalize(img(:,:,2));
    b = imageNormalize(img(:,:,3));
  
    %% NEW CHANNEL 1: IMAGE DARKNESS (NEGATIVE OF R CHANNEL)

    nc1 = 1 - r;

    %% NEW CHANNEL 2: TEXTURE REPRESENTATION

    L = (r + g + b)/3;

    maskSizes = 7:4:43;

    setS = zeros(M,N,length(maskSizes));

    for i = 1:length(maskSizes);

        maskSize = maskSizes(i);
        sigma = maskSize/7;
        filter = fspecial('gaussian',[maskSize maskSize],sigma);

        S = imfilter(L,filter,'symmetric','same') + eps;
        setS(:,:,i) = (L./S) - L; % *

    end

    % * : L(1-S)./S <=> (L - LS)./S <=> L./S - L

    nc2 = imageNormalize(max(setS,[],3));

    %% NEW CHANNEL 3: COLOR VARIATION

    data = reshape(img,M*N,K);

    [~, SCORE] = princomp(data);

    C = imageNormalize(abs(reshape(SCORE(:,1),M,N)));

    nc3 = medfilt2(C, [5 5]);

    %% Parameters 

    % Size of Square Patch:

    W = 5;

    % Rank:

    R = 1; 

    %% NMF SEGMENTATION:

    IN = cat(3,nc1,nc2,nc3);

    Y = img2patch(IN,W);
    
    [A, X] = nnmf(Y,R); % decomposing: Y in A*X

    Xmask = kmeans(X,2)';
    
    Xmask(Xmask == 1) = 0;
    Xmask(Xmask == 2) = 1;

    XX = Xmask.*X;

    YY = A*XX;

    INOut = patch2img(YY,W,M,N);
   
    mask = (INOut(:,:,1) + INOut(:,:,2) + INOut(:,:,3))/3;
    
    mask(mask > 0) = 255;
    
    % If skin/lesion was inverted by k-means:
    
    if(sum(mask(:) == 255) > sum(sum(mask(:) == 0)))
        
        mask = 255 - mask;
        
    end;
    
    mask = im2bw(mask);
        
