%% Loading and Visualizing the images

data = load('../data/assignmentImageDenoisingPhantom.mat');
im = data.imageNoisy;
im_orig = data.imageNoiseless;

fprintf('RRMSE = %f\n', rrmse(im,im_orig));

printImage(im_orig,'Original Noiseless Image');
printImage(abs(im),'Input Noisy Image');

%% MRF Potential: Quadratic

alphaOptimal = 0.215;
[im_r_op, nllHistory] = denoise(im,'q',alphaOptimal);
fprintf('Optimal alpha=%f, RRMSE = %f\n\n', alphaOptimal, rrmse(im_orig, im_r_op));

for alpha=[0.8*alphaOptimal, min(1.2*alphaOptimal,1)]
    [im_r, ~] = denoise(im,'q',alpha);
    fprintf('RRMSE (alpha=%f) = %f\n', alpha, rrmse(im_orig, im_r));
end

printImage(abs(im_r_op),'Denoised image using Quadratic prior potential');
figure;
plot(nllHistory);
title('nll function using Quadratic prior');
xlabel('Iteration number');
ylabel('nll');

%% MRF Potential: Discontinuity-adaptive Huber

alphaOptimal = 0.78;
gammaOptimal = 0.03;
[im_r_op, nllHistory] = denoise(im,'h',alphaOptimal,gammaOptimal);
fprintf('Optimal alpha=%f, Optimal gamma=%f RRMSE = %f\n\n', alphaOptimal, gammaOptimal, rrmse(im_orig, im_r_op));

for alpha=[0.8*alphaOptimal, min(1.2*alphaOptimal,1)]
    [im_r, ~] = denoise(im,'h',alpha,gammaOptimal);
    fprintf('RRMSE (alpha=%f) = %f\n', alpha, rrmse(im_orig, im_r));
end

fprintf('\n');

for gamma=[0.8*gammaOptimal, 1.2*gammaOptimal]
    [im_r, ~] = denoise(im,'h',alphaOptimal,gamma);
    fprintf('RRMSE (gamma=%f) = %f\n', gamma, rrmse(im_orig, im_r));
end

printImage(abs(im_r_op),'Denoised image using Discontinuity-adaptive Huber prior potential');
figure;
plot(nllHistory);
title('nll function using Discontinuity-adaptive Huber prior');
xlabel('Iteration number');
ylabel('nll');

%% MRF Potential: Discontinuity-adaptive

alphaOptimal = 0.78;
gammaOptimal = 0.04;
[im_r_op, nllHistory] = denoise(im,'d',alphaOptimal,gammaOptimal);
fprintf('Optimal alpha=%f, Optimal gamma=%f RRMSE = %f\n\n', alphaOptimal, gammaOptimal, rrmse(im_orig, im_r_op));

for alpha=[0.8*alphaOptimal, min(1.2*alphaOptimal,1)]
    [im_r, ~] = denoise(im,'d',alpha,gammaOptimal);
    fprintf('RRMSE (alpha=%f) = %f\n', alpha, rrmse(im_orig, im_r));
end

fprintf('\n');

for gamma=[0.8*gammaOptimal, 1.2*gammaOptimal]
    [im_r, ~] = denoise(im,'d',alphaOptimal,gamma);
    fprintf('RRMSE (gamma=%f) = %f\n', gamma, rrmse(im_orig, im_r));
end

printImage(abs(im_r_op),'Denoised image using Discontinuity-adaptive prior potential');
figure;
plot(nllHistory);
title('nll function using Discontinuity-adaptive prior');
xlabel('Iteration number');
ylabel('nll');