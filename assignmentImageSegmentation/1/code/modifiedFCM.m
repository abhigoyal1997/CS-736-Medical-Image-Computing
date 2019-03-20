function [c,mu,b,history] = modifiedFCM(y,w,q,c,b,eps,mask)

err = inf;
history = zeros(300,1);
i = 1;
[mu,J] = optimalMemberships(y,b,c,w,q,mask);
history(i) = J;

while err > eps
    c = optimalMeans(y,b,mu,w,q);
    b = optimalBias(y,mu,c,w,q,mask);
    fprintf('Value of objective function = %f\n',J);
    [mu_n,J] = optimalMemberships(y,b,c,w,q,mask);
    
    err = (mu_n-mu).^2;
    err = sum(err(:))/sum(mu(:).^2);
    mu = mu_n;
    i = i+1;
    history(i) = J;
end

history = history(1:i);

end

