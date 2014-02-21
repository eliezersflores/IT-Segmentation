% FEATURE EXTRACTION:

props = regionprops(boarder,'all');

f1 = props.Solidity;
f2 = props.Extent;
f3 = props.EquivDiameter;
f4 = (4*pi*props.FilledArea)/(props.Perimeter^2);

% Calculating Major Axis (L1) and Minor Axis (L2)...

rotate = imrotate(boarder,props.Orientation);
propsRotate = regionprops(rotate,'all');
center = round(propsRotate.Centroid); % center(1) = columns, center(2) = row.
L1 = propsRotate.BoundingBox(4);
L2 = propsRotate.BoundingBox(3);

rightMajor = rotate;
rightMajor(:,1:center(1)-1) = 0;
rightMajor(:,center(1)) = 1;
rightMajor = imfill(rightMajor);
BR = sum(rightMajor(:) == 1);

leftMajor = rotate;
leftMajor(:,center(1):end) = 0;
leftMajor(:,center(1)-1) = 1;
leftMajor = imfill(leftMajor);
BL = sum(leftMajor(:) == 1);

bottonMinor = rotate;
bottonMinor(1:center(2)-1,:) = 0;
bottonMinor(center(2),:) = 1;
bottonMinor = imfill(bottonMinor);
BB = sum(bottonMinor(:) == 1);

upperMinor = rotate;
upperMinor(center(2):end,:) = 0;
upperMinor(center(2)-1,:) = 1;
upperMinor = imfill(upperMinor);
BU = sum(upperMinor(:) == 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f5 = L2/L1;
f6 = props.BoundingBox(3)/props.BoundingBox(4);
f7 = props.Perimeter/props.FilledArea;
f8 = (BL-BR)/props.FilledArea;
f9 = (BB-BU)/props.FilledArea;
f10 = BL/BR;
f11 = BB/BU;

nc1MagGrad = imfilter(nc1,fspecial('sobel'));
nc2MagGrad = imfilter(nc2,fspecial('sobel'));
nc3MagGrad = imfilter(nc3,fspecial('sobel'));

f12 = mean(nc1MagGrad(boarder == 1));
f13 = mean(nc2MagGrad(boarder == 1));
f14 = mean(nc3MagGrad(boarder == 1));

f15 = var(nc1MagGrad(boarder == 1));
f16 = var(nc2MagGrad(boarder == 1));
f17 = var(nc3MagGrad(boarder == 1));