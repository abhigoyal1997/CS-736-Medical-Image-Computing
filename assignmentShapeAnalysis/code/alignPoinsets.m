function theta = alignPoinsets(z1,z2, preshape)

if preshape ~= 1
    z1 = z1 - mean(z1);
    z2 = z2 - mean(z2);
    
    z1 = 
end

[U,~,V] = svd(z1*z2');
theta = U*V';
sz = size(U,1);
if det(theta) ~= 1
    M = eye(sz);
    M(end,end) = -1;
    theta = U*M*V';
end

end