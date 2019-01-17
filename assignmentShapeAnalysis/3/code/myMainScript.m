%% Loading and visualizing the data

data = load('../data/bone3D.mat');
z = data.shapesTotal;
n = size(z,2);
N = size(z,3);
tri_mesh = data.TriangleIndex;

color = rand(N,3);

figure; set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.8]);
hold on;
for i=1:N
    scatter3(z(1,:,i), z(2,:,i), z(3,:,i), 5, color(i,:),'o');
end
view([1 1 0.1])
hold off;
xlabel('x');
ylabel('y');
zlabel('z');
title('Initial Pointsets');

%% Transformation to preshape space

z = z - mean(z,2); % translating the centroids to origin
z = z./sqrt(sum(sum(z.^2,2),1)); % scaling the pointsets to norm 1

figure; set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.8]);
hold on;
for i=1:N
    scatter3(z(1,:,i), z(2,:,i), z(3,:,i), 5, color(i,:),'o');
end
view([1 1 0.1])
hold off;
xlabel('x');
ylabel('y');
zlabel('z');
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

figure; set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.8]);
hold on;
for i=1:N
    scatter3(z(1,:,i), z(2,:,i), z(3,:,i), 5, color(i,:),'o');
end
mean_plot = patch('vertices', z_m','faces', tri_mesh, 'facecolor', 'r',...
    'FaceAlpha', 0.25, 'EdgeAlpha', 0.1);
view([1 1 0.1])
hold off;
xlabel('x');
ylabel('y');
zlabel('z');
title('Mean Pointset and Aligned Pointsets');

%% Finding eigenvalues and eigenvectors

zv = reshape(z,3*n,N); % vectorisation
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
z_pu = z_m + 2*sqrt(D_s(1))*reshape(V(:,1),3,n);
z_pd = z_m - 2*sqrt(D_s(1))*reshape(V(:,1),3,n);

figure; set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.8]);
h(1) = subplot(1,3,1); hold on;
for i=1:N
    scatter3(z(1,:,i), z(2,:,i), z(3,:,i), 5, color(i,:),'o');
end
patch('vertices', z_pu','faces', tri_mesh, 'facecolor', 'r',...
    'FaceAlpha', 0.25, 'EdgeAlpha', 0.1);
view([1 1 0.1])
hold off;
xlabel('x');
ylabel('y');
zlabel('z');
title('-2{\surd}\lambda_{2}')
axis square;

h(2) = subplot(1,3,2); hold on;
for i=1:N
    scatter3(z(1,:,i), z(2,:,i), z(3,:,i), 5, color(i,:),'o');
end
patch('vertices', z_m','faces', tri_mesh, 'facecolor', 'r',...
    'FaceAlpha', 0.25, 'EdgeAlpha', 0.1);
view([1 1 0.1])
hold off;
xlabel('x');
ylabel('y');
zlabel('z');
title('Mean shape')
axis square;

h(3) = subplot(1,3,3); hold on;
for i=1:N
    scatter3(z(1,:,i), z(2,:,i), z(3,:,i), 5, color(i,:),'o');
end
patch('vertices', z_pd','faces', tri_mesh, 'facecolor', 'r',...
    'FaceAlpha', 0.25, 'EdgeAlpha', 0.1);hold off;
view([1 1 0.1])
xlabel('x');
ylabel('y');
zlabel('z');
title('+2{\surd}\lambda_{2}')
axis square;

linkprop(h, 'CameraPosition');
suptitle('1st principal mode of variation');

%% Second principal mode of variation
z_pu = z_m + 2*sqrt(D_s(2))*reshape(V(:,2),3,n);
z_pd = z_m - 2*sqrt(D_s(2))*reshape(V(:,2),3,n);

figure; set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.8]);
h(1) = subplot(1,3,1); hold on;
for i=1:N
    scatter3(z(1,:,i), z(2,:,i), z(3,:,i), 5, color(i,:),'o');
end
patch('vertices', z_pu','faces', tri_mesh, 'facecolor', 'r',...
    'FaceAlpha', 0.25, 'EdgeAlpha', 0.1);
view([1 1 0.1])
hold off;
xlabel('x');
ylabel('y');
zlabel('z');
title('-2{\surd}\lambda_{2}')
axis square;

h(2) = subplot(1,3,2); hold on;
for i=1:N
    scatter3(z(1,:,i), z(2,:,i), z(3,:,i), 5, color(i,:),'o');
end
patch('vertices', z_m','faces', tri_mesh, 'facecolor', 'r',...
    'FaceAlpha', 0.25, 'EdgeAlpha', 0.1);
view([1 1 0.1])
hold off;
xlabel('x');
ylabel('y');
zlabel('z');
title('Mean shape')
axis square;

h(3) = subplot(1,3,3); hold on;
for i=1:N
    scatter3(z(1,:,i), z(2,:,i), z(3,:,i), 5, color(i,:),'o');
end
patch('vertices', z_pd','faces', tri_mesh, 'facecolor', 'r',...
    'FaceAlpha', 0.25, 'EdgeAlpha', 0.1);hold off;
view([1 1 0.1])
xlabel('x');
ylabel('y');
zlabel('z');
title('+2{\surd}\lambda_{2}')
axis square;

linkprop(h, 'CameraPosition');
suptitle('2nd principal mode of variation');

%% Third principal mode of variation
z_pu = z_m + 2*sqrt(D_s(3))*reshape(V(:,3),3,n);
z_pd = z_m - 2*sqrt(D_s(3))*reshape(V(:,3),3,n);

figure; set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.8]);
h(1) = subplot(1,3,1); hold on;
for i=1:N
    scatter3(z(1,:,i), z(2,:,i), z(3,:,i), 5, color(i,:),'o');
end
patch('vertices', z_pu','faces', tri_mesh, 'facecolor', 'r',...
    'FaceAlpha', 0.25, 'EdgeAlpha', 0.1);
view([1 1 0.1])
hold off;
xlabel('x');
ylabel('y');
zlabel('z');
title('-2{\surd}\lambda_{2}')
axis square;

h(2) = subplot(1,3,2); hold on;
for i=1:N
    scatter3(z(1,:,i), z(2,:,i), z(3,:,i), 5, color(i,:),'o');
end
patch('vertices', z_m','faces', tri_mesh, 'facecolor', 'r',...
    'FaceAlpha', 0.25, 'EdgeAlpha', 0.1);
view([1 1 0.1])
hold off;
xlabel('x');
ylabel('y');
zlabel('z');
title('Mean shape')
axis square;

h(3) = subplot(1,3,3); hold on;
for i=1:N
    scatter3(z(1,:,i), z(2,:,i), z(3,:,i), 5, color(i,:),'o');
end
patch('vertices', z_pd','faces', tri_mesh, 'facecolor', 'r',...
    'FaceAlpha', 0.25, 'EdgeAlpha', 0.1);hold off;
view([1 1 0.1])
xlabel('x');
ylabel('y');
zlabel('z');
title('+2{\surd}\lambda_{2}')
axis square;

linkprop(h, 'CameraPosition');
suptitle('3rd principal mode of variation');
