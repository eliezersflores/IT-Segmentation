function [img] = patch2img(patches,W,M,N)

    channelSize = size(patches,1)/3;

    patchesR = patches(1:channelSize,:);
    patchesG = patches(channelSize+1:2*channelSize,:);
    patchesB = patches(2*channelSize+1:end,:);

    img(:,:,1) = patch2im(patchesR,[W W],[M N]);
    img(:,:,2) = patch2im(patchesG,[W W],[M N]);
    img(:,:,3) = patch2im(patchesB,[W W],[M N]);

end

