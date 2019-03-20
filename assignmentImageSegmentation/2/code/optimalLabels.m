function x = optimalLabels(y, mu, sigma, x, posteriorFn, mask)

mask = mask(:,:,1);
P = posteriorFn(y,mu,sigma,x,x);
logP = sum(sum(log(P(logical(mask)))));
logPi = logP;

while true
    pdf = posteriorFn(y,mu,sigma,x,[]);
    [P,idx] = max(pdf,[],3);
    logP_n = sum(sum(log(P(logical(mask)))));
    
    if logP_n <= logP
        break
    end
    logP = logP_n;
    
    x = idx.*mask;
end
fprintf('ICM update - Log posterior probability: %f --> %f\n',logPi,logP);

end

