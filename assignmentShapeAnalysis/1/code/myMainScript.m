%% Loading and visualizing the data

data = load('../data/ellipses2D.mat');
N = data.numOfPointSets;
z = data.pointSets;
n = data.numOfPoints;

figure; hold on;
for i=1:N
    scatter(z(1,:,i), z(2,:,i), 15, rand(1,3));
end
hold off;
xlabel('x');
ylabel('y');
title('Initial Pointsets');

%% Transformation to preshape space

z = z - mean(z,2); % translating the centroids to origin
z = z./sqrt(sum(sum(z.^2,2),1)); % scaling the pointsets to norm 1

figure; hold on;
for i=1:N
    scatter(z(1,:,i), z(2,:,i), 15, rand(1,3));
end
hold off;
xlabel('x');
ylabel('y');
title('Pointsets after transformation to preshape space');

%% Finding the mean shape by minimizing the L2-norm

tic;
eps = 1e-10;
z_m = z(:,:,1);
err = inf;

while err > eps
    for i=1:N
        theta = alignPoinsets(z(:,:,i), z_m);
        z(:,:,i) = theta*z(:,:,i);
    end
    
    z_mo = z_m(:,:);
    z_m = mean(z,3);
    z_m = z_m./sqrt(sum(sum(z_m.^2,2),1));
    err = sum(sum((z_m-z_mo).^2));
end
toc;

figure; hold on;
for i=1:N
    scatter(z(1,:,i), z(2,:,i), 5, rand(1,3));
end
mean_plot = plot(z_m(1,:), z_m(2,:), '-', 'LineWidth',2);
hold off;
xlabel('x');
ylabel('y');
title('Mean Pointset and Aligned Pointsets');
legend(mean_plot, 'Mean shape');

%% Finding and visualizing modes of shape variation

zv = reshape(z,2*n,N); % vectorisation
z_c = cov(zv'); % covariance matrix
[V,D] = eig(z_c);
[D_s, idx] = sort(diag(D),'descend'); % sorting the eigenvalues

figure;
plot(D_s);
title('Plot of Eigenvalues');
xlabel('Mode of Variation');
ylabel('Eigenvalue');

V = V(:,idx); % Re-arranging eigenvectors along sorted eigenvalues

% First principal mode of variation
z_pu = z_m + 2*sqrt(D_s(1))*reshape(V(:,1),2,n);
z_pd = z_m - 2*sqrt(D_s(1))*reshape(V(:,1),2,n);

% Second principal mode of variation
z_p2u = z_m + 2*sqrt(D_s(2))*reshape(V(:,2),2,n);
z_p2d = z_m - 2*sqrt(D_s(2))*reshape(V(:,1),2,n);

figure; hold on;
for i=1:N
    scatter(z(1,:,i), z(2,:,i), 5, rand(1,3));
end
mean_plot = plot(z_m(1,:), z_m(2,:), '-', 'LineWidth',2);
p1u_plot = plot(z_pu(1,:), z_pu(2,:), '-', 'LineWidth',1.5);
p1d_plot = plot(z_pd(1,:), z_pd(2,:), '-', 'LineWidth',1.5);
p2u_plot = plot(z_p2u(1,:), z_p2u(2,:), '-', 'LineWidth',1.5);
p2d_plot = plot(z_p2d(1,:), z_p2d(2,:), '-', 'LineWidth',1.5);
hold off;
xlabel('x');
ylabel('y');
title('Mean Pointset and Aligned Pointsets');
legend([mean_plot, p1u_plot, p1d_plot, p2u_plot, p2d_plot],...
    {'Mean shape','1st principal mode of variation (+2)',...
    '1st principal mode of variation (-2)',...
    '2nd principal mode of variation (+2)',...
    '2nd principal mode of variation (-2)'})