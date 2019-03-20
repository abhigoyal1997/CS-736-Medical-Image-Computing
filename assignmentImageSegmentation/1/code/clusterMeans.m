function [c] = clusterMeans(y, mu)

c = sum(y.*mu)./sum(mu);

end