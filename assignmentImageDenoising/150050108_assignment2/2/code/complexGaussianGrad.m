function grad = complexGaussianGrad(x,y,noiseVar)

    grad = 2*(x-y)/noiseVar;

end