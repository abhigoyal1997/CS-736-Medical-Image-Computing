function grad = nllGrad(x, y, method, noiseVar, alpha, gamma)

    if (nargin<5) || isempty(gamma)
        grad = (1-alpha)*complexGaussianGrad(x,y,noiseVar) + alpha*mrfPotentialGrad(x,method);
    else
        grad = (1-alpha)*complexGaussianGrad(x,y,noiseVar) + alpha*mrfPotentialGrad(x,method,gamma);
    end

end