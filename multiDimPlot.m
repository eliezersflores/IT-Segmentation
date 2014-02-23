function [] = multiDimPlot(multiDimData,labels)

% Each column is a point.
% Plot star coordinate representation.

d = size(multiDimData, 1);
unitRoot = exp(2 * pi * 1i / d);

starAxes = zeros(1, d);
for ii = 1:d
    starAxes(ii) = unitRoot^ii;
end

starAxes = repmat(starAxes', 1, size(multiDimData, 2));
starCoordinateData = sum(multiDimData .* starAxes, 1);

figure, gscatter(real(starCoordinateData),imag(starCoordinateData),labels);

