function [gamma, x, mu, sigma] = emSegmentation(y, mu, sigma, x, posteriorFn, mask, eps)

while true
    % E-step
    x = optimalLabels(y,mu,sigma,x,posteriorFn,mask);
    
    gamma = optimalMemberships(y,mu,sigma,x,posteriorFn);
    
    % M-step   
    mu_n = optimalMeans(y,gamma);
    sigma = optimalSigmas(y,gamma,mu_n);
    
    err = sum((mu_n-mu).^2);
    mu = mu_n;
    
    if err <= eps
        break
    end
end

end

