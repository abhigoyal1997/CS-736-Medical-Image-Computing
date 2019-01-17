function theta = alignPoinsets(z1,z2)

[U,~,V] = svd(z1*z2');
theta = V*U';
if det(theta) < 0
    M = eye(size(U,1));
    M(end,end) = -1;
    theta = V*M*U';
end

end