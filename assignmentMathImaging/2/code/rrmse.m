function err = rrmse(im1,im2)

err = sqrt(sum(sum((im1-im2).^2)))/sqrt(sum(sum((im1).^2)));

end