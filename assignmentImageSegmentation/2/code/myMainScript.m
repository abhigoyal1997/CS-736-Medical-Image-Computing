%% Visualizing the data

data = load('../data/assignmentSegmentBrainGmmEmMrf.mat');
im = data.imageData;
mask = data.imageMask;

printImage(im.*mask,'Masked corrupted image - y');

%% Initialisation using k-means

K = 3;
y = im(logical(mask));
y_uniq = unique(y);
mu_idx = randperm(length(y_uniq),K);
mu = reshape(y_uniq(mu_idx),1,K);
[mu,~] = kmeansClustering(y,mu,eps);

[d,x] = min(((y-mu).^2),[],2);

sigma = zeros(1,1,K);
for k=1:K
    sigma(k) = sqrt(sum(d(x==k))/sum(x==k));
end

mu = reshape(mu,1,1,K);
y = im;
y(~mask) = 0;
[~,x] = min(((y-mu).^2).*mask,[],3);

printImage(label2rgb(x).*uint8(mask), 'Initial Labels');
x(~mask) = 0;

fprintf('Initial class means = %f %f %f\n',mu);
fprintf('Initial class standard deviations = %f %f %f\n',sigma);


%%
% This initialization is given by kmeans clustering on masked image.
% Motivation for this is that kmeans is a natural and efficient algorithm
% for image segmentation. This gives reasonable initial labels for EM and
% sufficiently far apart initial means (but which are close to optimal
% means). The the class standard deviations are calculated using ML
% estimate which reduces to the emperical standard deviations in data. This
% is because ML estimate for standard deviation in a Gaussian distribution
% is same as the emperical standard deviation.

%% Segmentation

printImage(im, 'Corrupted Image');
printImage(im.*mask, 'Masked Corrupted Image');

% Masks for determining valid neighbourhood of a pixel
nbMask = zeros([size(mask),4]);
for dim=[1,2]
    for k=[-1,1]
        nbMask(:,:,dim+k+1) = circshift(mask,k,dim);
    end
end
nbMask = nbMask.*mask;

mask = repmat(mask,[1,1,K]);

choosen_beta = 1.18;
fprintf('Choosen value for beta = %f\n',choosen_beta);

% Hyperparameter beta for smoothness of segmentation
for beta=[0,choosen_beta]
    fprintf('beta = %f\n',beta);
    
    % Function handle to compute MRF prior image
    priorFn = @(x) calculatePrior(x,nbMask,beta,K);

    % Function handle to compute posterior image
    posteriorFn = @(y,mu,sigma,x,cx) calculatePosterior(y,mu,sigma,x,cx,priorFn,mask);

    % EM
    eps = 1e-7;
    [gamma,x,mu,sigma] = emSegmentation(y,mu,sigma,x,posteriorFn,mask,eps);

    printImage(gamma, sprintf('Class membership image estimate for beta = %f',beta));
    for k=1:K
        printImage(gamma(:,:,k), sprintf('Membership for class %d, for beta = %f',k,beta));
    end
    printImage((label2rgb(x).*uint8(mask)), sprintf('Optimal label image estimate for beta = %f',beta));
end

fprintf('Optimal class means (for beta = %f) = %f %f %f\n',choosen_beta,mu);