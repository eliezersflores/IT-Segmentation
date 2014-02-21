% Select an area between min and max (in pixels)
% bwin is the black and white image input
% bwout is the black and white image output

function [bwout] = bwareaselect(bwin,min,max)
    
    CC = bwconncomp(bwin);
    S = regionprops(CC, 'Area');
    L = labelmatrix(CC);
    bwout = ismember(L, find([S.Area] >= min & [S.Area] <= max));
    
    