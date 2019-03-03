function printImage(im, header)

figure; imagesc(im);
daspect([1 1 1]);
axis tight;
colormap('gray');
if (nargin>1) && ~isempty(header)
    title(header);
end

end

