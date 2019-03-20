function printImage(im, header)

figure;
imshow(im,[],'InitialMagnification','fit')

axis('square');
title(header);
colorbar;

end

