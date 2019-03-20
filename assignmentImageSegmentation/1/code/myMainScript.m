%% Visualizing the data

data = load('../data/assignmentSegmentBrain.mat');
im = data.imageData;
mask = data.imageMask;

printImage(im.*mask,'Masked corrupted image - y');

%% Hyperparameters

q = 1.65;
fprintf('q = %f\n',q);

nb_size = 12;
nb_sigma = 2.5;
w = fspecial('gaussian', nb_size, nb_sigma);
printImage(w,'Neighbourhood mask - w');

K = 3;
eps = 1e-7;

%% Initialisation

y = im(mask==1);
y_uniq = unique(y);
c_idx = randperm(length(y_uniq),K);
c = reshape(y_uniq(c_idx),1,K);
[c,~] = kmeansClustering(y,c,eps);

c = reshape(c,1,1,K);
y = im.*mask;
[~,mu] = min(((y-c).^2).*mask,[],3);
mu = mu.*mask;

for i=1:K
    printImage(mu==i, sprintf('Initial Memberships for class %d',i));
end

fprintf('Initial Means = %f %f %f\n',c);

b = 0.5*ones(size(y)).*mask;

%%
% This initialization is given by kmeans clustering on masked image.
% Motivation for this is that kmeans is a natural and efficient algorithm
% for image segmentation. This gives binary initial memberships for FCM and
% sufficiently far apart initial means (but which are close to optimal
% means).

%% Modified FCM

[c,mu,b,history] = modifiedFCM(y,w,q,c,b,eps,mask);

figure;
plot(history);
xlabel('Iterations');
ylabel('Objective function value');
title('Value of objective function vs num. of iterations');

printImage(im, 'Corrupted image provided');
printImage(im.*mask, 'Masked corrupted image');

printImage(mu, sprintf('Optimal Class Memberships'));
for i=1:K
    printImage(mu(:,:,i), sprintf('Optimal Memberships for class %d',i));
end

printImage(b, 'Optimal bias-field image estimate');

im_br = sum(mu.*c, 3);
printImage(im_br, 'Bias-removed image');

residual = y - im_br.*b;
printImage(residual, 'Residual image');

fprintf('Optimal estimates of class means = %f %f %f\n',c);