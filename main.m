clear all; close all; clc; tic;

%% LOAD IMAGES:

images = loadData('images','tif');
N = numel(images);

gts = loadData('gts','tif');

%% FOR EACH IMAGE:

for k = 1:N
    %% PREPROCESSING:

    img = shadAttenuation(images{k});

    %% SEGMENTATION:

    mask = nmfSegmentation(img);
    
    %cd([currentDirectory '\segmentationResults']);

    %imwrite(mask,['mask' num2str(k) '.tif']);

    %%
    
    gt = gts{k};
    
    figure, subplot(1,2,1); imshow(mask); 
            subplot(1,2,2); imshow(gt); 
    pause(1); close all;
    
    x = mask - gt;
    
    %mask2 = bwareaselect(mask,5000,40000);

end;
%%

toc;