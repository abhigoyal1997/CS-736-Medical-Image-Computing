function printImage(im, header, theta, t)

figure;
if nargin == 4
    iptsetpref('ImshowAxesVisible','on');
    imshow(im,[],'Xdata',theta,'Ydata',t,'InitialMagnification','fit')
    xlabel('theta');
    ylabel('t');
else
    imshow(im,[],'InitialMagnification','fit')
end

axis('square');
title(header);
colormap(gca,hot), colorbar;

end

