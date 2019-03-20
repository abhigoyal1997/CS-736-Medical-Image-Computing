function [b] = optimalBias(y, mu, c, w, q, mask)

b = conv2(y.*sum((mu.^q).*c, 3), w, 'same')./conv2(sum((mu.^q).*(c.^2), 3), w, 'same');
b(~mask) = 0;

end