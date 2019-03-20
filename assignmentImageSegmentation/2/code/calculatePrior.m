function P = calculatePrior(x, nbMask, beta, K)

cx = repmat(reshape(1:K,1,1,K),size(x));
potential = 0;
for dim=[1,2]
    for k=[-1,1]
        u = (cx~=circshift(x,k,dim)).*nbMask(:,:,dim+k+1);
        potential = potential + u;
    end
end
potential = potential*beta;

P = exp(-potential);

end

