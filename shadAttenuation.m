% INPUT: image RGB MxNx3 (three channels).
% OUTPUT: image RGB MxNx3 (three channels) with shad attenuation.

function [imageOut] = shadAttenuation(imageIn)


    hsvImage = rgb2hsv(double(imageIn));

%     hChannel = hsvImage(:,:,1); % in [0,1]
%     sChannel = hsvImage(:,:,2); % in [0,1]
    vChannel = hsvImage(:,:,3); % in [0,255]
    
    [rows, columns] = size(vChannel);

    mask = zeros(rows,columns);
    sizeCorners = 30;

    mask(1:sizeCorners,1:sizeCorners) = 1;
    mask(1:sizeCorners,end-(sizeCorners-1):end) = 1;
    mask(end-(sizeCorners-1):end,1:sizeCorners) = 1;
    mask(end-(sizeCorners-1):end,end-(sizeCorners-1):end) = 1;
    
    k = 1;

    % Transformando o problema em um SELA sobredeterminado:

    for y = 1:rows

        for x = 1:columns

            if mask(y,x) == 1

                A(k,:) = [x^2 y^2 x*y x y 1]; 
                b(k,:) = vChannel(y,x);
                k = k+1;

            end

        end;

    end;
    
    % Resolvendo por mínimos quadrados:

    P = A\b;
    
    % Cálculo do modelo:

    for y = 1:rows

        for x = 1:columns

            z(y,x) = P(1)*x^2 + P(2)*y^2 + P(3)*x*y + P(4)*x + P(5)*y + P(6);

        end;

    end;
        
    vChannelNew = imageNormalize(vChannel./z);
        
    hsvImage(:,:,3) = 255*vChannelNew;

    imageOut = imageNormalize(hsv2rgb(hsvImage));
    
end

