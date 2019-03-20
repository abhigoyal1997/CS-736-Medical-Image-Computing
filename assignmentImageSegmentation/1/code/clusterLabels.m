function [mu,J] = clusterLabels(y,c)

[d,idx] = min((y-c).^2,[],2);
mu = full(ind2vec(idx'))';
J = sum(sum(d));

end