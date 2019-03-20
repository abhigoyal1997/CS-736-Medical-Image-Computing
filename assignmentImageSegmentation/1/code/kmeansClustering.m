function [c,history] = kmeansClustering(y,c,eps)

err = inf;
history = zeros(300,1);
i = 1;
[mu,J] = clusterLabels(y,c);
history(i) = J;

while err > eps
    c = clusterMeans(y,mu);
    [mu,J] = clusterLabels(y,c);
    
    err = (history(i)-J)/history(i);
    i = i+1;
    history(i) = J;
end

history = history(1:i);

end

