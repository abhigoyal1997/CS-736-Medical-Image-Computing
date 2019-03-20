function [mu, J] = optimalMemberships(y, b, c, w, q, mask)

bf = conv2(b, w, 'same');
b2f = conv2(b.^2, w, 'same');

d = (y.^2)*sum(w(:)) - 2*(y.*(c.*bf)) + (c.^2).*b2f;
d(d<0) = 0;
d_inv = (1./d).^(1/(q-1));

mu = d_inv./nansum(d_inv,3);
mu = mu.*mask;
mu(isnan(mu)) = 0;

J = sum(sum(sum(d.*(mu.^q))));

end
