function [img] = patch2im(patch, size_patch, size_img)

size_skip = size_patch;
border = 'off';

img = zeros(size_img);
w = zeros(size_img);
patch_loc = patchLocation(size_img, size_patch, size_skip, border);
for n=1:size(patch_loc,3)
    img(patch_loc(:,:,n)) = img(patch_loc(:,:,n)) + reshape(patch(:,n), size_patch);
    w(patch_loc(:,:,n)) = w(patch_loc(:,:,n)) + 1;
end
img = img ./ w;