function result = nll(x, y, method, noiseVar, alpha, gamma)

    if (nargin<5) || isempty(gamma)
        result = (1-alpha)*complexGaussian(x,y,noiseVar) + alpha*mrfPotential(x,method);
    else
        result = (1-alpha)*complexGaussian(x,y,noiseVar) + alpha*mrfPotential(x,method,gamma);
    end
    
    result = sum(result(:));

end