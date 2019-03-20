function printImage(im, header)

figure;
imshow(im,[],'InitialMagnification','fit')

axis('square');
if nargin>1
    title(header);
end
colorbar;

end

