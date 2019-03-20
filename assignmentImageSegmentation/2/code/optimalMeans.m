function [mu] = optimalMeans(y, gamma)

mu = sum(sum(y.*gamma))./sum(sum(gamma));

end