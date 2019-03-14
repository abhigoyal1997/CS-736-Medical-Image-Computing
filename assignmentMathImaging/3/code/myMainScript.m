%% Q3.a) Loading datasets and plotting RRMSE vs theta

data_title = {'CT_Chest', 'myPhantom'};
best_imr = {[],[]};
best_theta = [0,0];

for i=1:length(data_title)
    data = load(sprintf('../data/%s.mat',data_title{i}));
    im = data.imageAC;
    printImage(im,data_title{i})

    th = 0:179;
    sz = size(im,1);

    % radon transform
    [R,t] = radon(im,th);
    printImage(R,sprintf('Complete radon transform for %s',data_title{i}))

    history = zeros(size(th));
    min_err = Inf;
    for j=0:180
        if j+149 > 179
            theta = [1+j:180, 1:j-30];
        else
            theta = j+1:j+150;
        end
        Rj = R(:,theta);
        Rf = myFilter(Rj,t,'ram-lak',1);
        imr = iradon(Rf,theta,'linear','none',1,sz)/2;
        err = rrmse(im,imr);
        if err < min_err
            min_err = err;
            best_imr{i} = imr;
            best_theta(i) = j;
        end
        history(j+1) = rrmse(im,imr);
    end

    figure;
    plot(0:180,history);
    title(sprintf('RRMSE vs theta for %s data',data_title{i}));
    xlabel('theta');
    ylabel('RRMSE');
end
    
%% Q3.b) Visualising Reconstruction using min RRMSE theta

for i=1:length(data_title)
    printImage(best_imr{i},sprintf('Reconstructed image for %s',data_title{i}));
    fprintf('Best theta for %s = %d\n',data_title{i},best_theta(i));
end