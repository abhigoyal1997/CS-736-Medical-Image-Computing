function err = rrmse(im1,im2)

im1 = abs(im1);
im2 = abs(im2);

err = sqrt(sum(sum((im1-im2).^2)))/sqrt(sum(sum((im1).^2)));

end