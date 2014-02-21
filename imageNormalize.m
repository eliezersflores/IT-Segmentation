% INPUT: image MxN (one channel).
% OUTPUT: image MxN (one channel) with intensity in [0,1].

function [ imageNormalized ] = imageNormalize( image )
    
    imageNormalized = (image - min(image(:)))./(max(image(:)) - min(image(:)));
    
end

