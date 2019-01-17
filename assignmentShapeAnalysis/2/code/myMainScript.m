%% Loading and visualizing the data

data = load('../data/hands2D.mat');
z = data.shapes;
n = size(z,2);
N = size(z,3);

color = rand(N,3);

figure; hold on;
for i=1:N
    scatter(z(1,:,i), z(2,:,i), 5, color(i,:),'o');
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
    scatter(z(1,:,i), z(2,:,i), 5, color(i,:),'o');
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
    scatter(z(1,:,i), z(2,:,i), 5, color(i,:),'o');
end
mean_plot = plot(z_m(1,:), z_m(2,:), 'r-', 'LineWidth',1);
hold off;
xlabel('x');
ylabel('y');
title('Mean Pointset and Aligned Pointsets');
legend(mean_plot, 'Mean shape');

%% Finding eigenvalues and eigenvectors

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

%% First principal mode of variation

z_pu = z_m + 2*sqrt(D_s(1))*reshape(V(:,1),2,n);
z_pd = z_m - 2*sqrt(D_s(1))*reshape(V(:,1),2,n);

figure; set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 0.6, 0.4]);

subplot(1,3,1); hold on;
for i=1:N
    scatter(z(1,:,i), z(2,:,i), 5, color(i,:),'o');
end
plot(z_pu(1,:), z_pu(2,:), 'r-', 'LineWidth',1);
hold off;
xlabel('x');
ylabel('y');
title('-2{\surd}\lambda_{1}')
axis square;

subplot(1,3,2); hold on;
for i=1:N
    scatter(z(1,:,i), z(2,:,i), 5, color(i,:),'o');
end
plot(z_m(1,:), z_m(2,:), 'r-', 'LineWidth',1);
hold off;
xlabel('x');
ylabel('y');
title('Mean shape')
axis square;

subplot(1,3,3); hold on;
for i=1:N
    scatter(z(1,:,i), z(2,:,i), 5, color(i,:),'o');
end
plot(z_pd(1,:), z_pd(2,:), 'r-', 'LineWidth',1);
hold off;
xlabel('x');
ylabel('y');
title('+2{\surd}\lambda_{1}')
axis square;

suptitle('1st principal mode of variation');

%% Second principal mode of variation

z_pu = z_m + 2*sqrt(D_s(2))*reshape(V(:,2),2,n);
z_pd = z_m - 2*sqrt(D_s(2))*reshape(V(:,2),2,n);

figure; set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 0.6, 0.4]);

subplot(1,3,1); hold on;
for i=1:N
    scatter(z(1,:,i), z(2,:,i), 5, color(i,:),'o');
end
plot(z_pu(1,:), z_pu(2,:), 'r-', 'LineWidth',1);
hold off;
xlabel('x');
ylabel('y');
title('-2{\surd}\lambda_{2}')
axis square;

subplot(1,3,2); hold on;
for i=1:N
    scatter(z(1,:,i), z(2,:,i), 5, color(i,:),'o');
end
plot(z_m(1,:), z_m(2,:), 'r-', 'LineWidth',1);
hold off;
xlabel('x');
ylabel('y');
title('Mean shape')
axis square;

subplot(1,3,3); hold on;
for i=1:N
    scatter(z(1,:,i), z(2,:,i), 5, color(i,:),'o');
end
plot(z_pd(1,:), z_pd(2,:), 'r-', 'LineWidth',1);
hold off;
xlabel('x');
ylabel('y');
title('+2{\surd}\lambda_{2}')
axis square;

suptitle('2nd principal mode of variation');

%% Third principal mode of variation

z_pu = z_m + 2*sqrt(D_s(3))*reshape(V(:,3),2,n);
z_pd = z_m - 2*sqrt(D_s(3))*reshape(V(:,3),2,n);

figure; set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 0.6, 0.4]);

subplot(1,3,1); hold on;
for i=1:N
    scatter(z(1,:,i), z(2,:,i), 5, color(i,:),'o');
end
plot(z_pu(1,:), z_pu(2,:), 'r-', 'LineWidth',1);
hold off;
xlabel('x');
ylabel('y');
title('-2{\surd}\lambda_{3}')
axis square;

subplot(1,3,2); hold on;
for i=1:N
    scatter(z(1,:,i), z(2,:,i), 5, color(i,:),'o');
end
plot(z_m(1,:), z_m(2,:), 'r-', 'LineWidth',1);
hold off;
xlabel('x');
ylabel('y');
title('Mean shape')
axis square;

subplot(1,3,3); hold on;
for i=1:N
    scatter(z(1,:,i), z(2,:,i), 5, color(i,:),'o');
end
plot(z_pd(1,:), z_pd(2,:), 'r-', 'LineWidth',1);
hold off;
xlabel('x');
ylabel('y');
title('+2{\surd}\lambda_{3}')
axis square;

suptitle('3rd principal mode of variation');
