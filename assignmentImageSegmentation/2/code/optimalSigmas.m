function [sigma] = optimalSigmas(y, gamma, mu)

sigma = sqrt(sum(sum(gamma.*((y-mu).^2)))./sum(sum(gamma)));

end