function [ y ] = aerocosmos_enhance( x )
%AEROCOSMOS_ENHANCE Summary of this function goes here
%   Detailed explanation goes here
[H W C] = size(x);

for i = 1:C
    x(:, :, i) = enhance_plane(x(:, :, i)); 
end

y = x;


end

function y = enhance_plane2(x)
end                     
function y = enhance_plane(x)

histo = sort(x(:));
n = numel(x(:));

% h2 = hist
% maxi = histo(end);
% mini = histo(1);

% lo = mini + 0.005 .* (maxi - mini);
% hi = maxi - 0.005 .* (maxi - mini);

lo = floor(0.01 .* n);
hi = floor((1.0 - 0.0005) .* n);

mini = histo(lo);
maxi = histo(hi);

a = (x - mini) ./ (maxi - mini);

y = min(max(a, 0.0), 1.0);

% y = adapthisteq(y, 'NumTiles', [2 2], 'NBins', 4);
y = 0.75 .* y + 0.25 .* decorrstretch(y, 'Tol', 0.000001);


end

