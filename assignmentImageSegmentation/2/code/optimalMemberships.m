function [gamma] = optimalMemberships(y, mu, sigma, x, posteriorFn)

gamma = posteriorFn(y,mu,sigma,x,[]);

end
