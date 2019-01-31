function [x,nllHistory] = denoise(y, method, alpha, gamma, maxIter)

    if (nargin<4) || isempty(gamma)
        gamma = 0;
    end

    if (nargin<5) || isempty(maxIter)
        maxIter = 100;
    end

    x = y;
    stepSize = 0.0005;
    prevLoss = Inf;
    nllHistory = zeros(maxIter);
    
    for i=1:maxIter
        grad = nllGrad(x,y,method,alpha,gamma);
        xt = x - stepSize*grad;
        loss = nll(xt,y,method,alpha,gamma);
        
        if loss < prevLoss
            prevLoss = loss;
            x = xt;
            nllHistory(i) = loss;
            stepSize = stepSize*1.1;
        else
            nllHistory(i) = prevLoss;
            stepSize = stepSize*0.5;
        end
    end

end

