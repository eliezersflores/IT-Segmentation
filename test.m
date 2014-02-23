images = loadData('images','tif');
gts = loadData('gts','tif');

accuracy = zeros(1,numel(images));

for k = 1:numel(images)
%%
   
    img = images{k};
    gt = gts{k};
    
    [M, N, dim] = size(img);
    
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

    data = reshape(img,M*N,dim);

    [~, SCORE] = princomp(data);

    C = imageNormalize(abs(reshape(SCORE(:,1),M,N)));

    nc3 = medfilt2(C, [5 5]);

    %% Parameters 

    % Size of Square Patch:

    W = 5;

    % Rank:

    K = 20; %10

    %% NMF SEGMENTATION:

    IN = cat(3,nc1,nc2,nc3);

    Y = img2patch(IN,W);
    Ygt = im2patch(gt,[W W]);
     
    C = zeros(1,size(Ygt,2));
    for i = 1:size(Ygt,2)
        if sum(Ygt(:,i)) == W^2
            C(i) = 1;
        end
    end;
    
    [D, X] = nnmf(Y,K); % decomposing: Y in D*X
        
    [invDD, XX] = informationTheoretic(Y, D, X, K, 10);
    DD = pinv(invDD);
   
    % multiDimPlot(XX,C);
    
    similarityMatrix = SimGraph_NearestNeighbors(XX, 15, 1, 1);
    Ctemp = SpectralClustering(similarityMatrix, 2, 2);
    Xmask = 2*Ctemp(:,1) + 1*Ctemp(:,2);
       
%     Xmask = kmeans(XX,2)';
%    
    posToZero = Xmask == 1;
    
    XX(:,posToZero) = 0;
    
    YY = DD*XX;
   
    INOut = patch2img(YY,W,M,N);
   
    mask = (INOut(:,:,1) + INOut(:,:,2) + INOut(:,:,3))/3;
    
    mask(mask > 0) = 255;
    
    % If skin/lesion was inverted by k-means:
    
    if(sum(mask(:) == 255) > sum(sum(mask(:) == 0)))
        
        mask = 255 - mask;
        
    end;
    
    mask = im2bw(mask);

    accuracy(k) = sum(sum(mask == gt))/numel(mask);
    
    figure, imshow(mask);
    
end;