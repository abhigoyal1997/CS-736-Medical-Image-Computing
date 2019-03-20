function P = calculatePosterior(y, mu, sigma, x, cx, priorFn, mask)

G = exp(-((y-mu).^2)./(2*(sigma.^2)))./(sigma*sqrt(2*pi));
P = priorFn(x);

pdf = ((G.*P)./sum(G.*P, 3));
pdf(~mask) = 0;

if size(cx,1) ~= 0
    P = zeros(size(cx));
    K = size(pdf,3);
    for k=1:K
        p = pdf(:,:,k);
        p(cx~=k) = 0;
        P = P + p;
    end
else
    P = pdf;
end

end

