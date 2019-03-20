function [c] = optimalMeans(y, b, mu, w, q)

bf = conv2(b, w, 'same');
b2f = conv2(b.^2, w, 'same');

c = sum(sum((mu.^q).*y.*bf))./sum(sum((mu.^q).*b2f));

end