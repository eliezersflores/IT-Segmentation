function [patches] = img2patch(img, W)

    r = img(:,:,1);
    g = img(:,:,2);
    b = img(:,:,3);
    
    patchesR = im2patch(r, [W W]);
    patchesG = im2patch(g, [W W]);
    patchesB = im2patch(b, [W W]);
    
    patches = vertcat(patchesR, patchesG, patchesB);
    
end

