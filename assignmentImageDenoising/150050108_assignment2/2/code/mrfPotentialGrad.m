function grad = mrfPotentialGrad(x, method, gamma)

    function qG = qGrad(u)
        qG = 2*u;
    end

    function hG = hGrad(u, gamma)
        cond = (abs(u) <= gamma);
        hG = u.*cond + gamma*sign(u).*(~cond);
    end

    function dG = dGrad(u, gamma)
        dG = u./(1+abs(u)/gamma);
    end

    grad = 0;
    for dim=[1,2]
        for k=[-1,1]
            u = x - circshift(x,k,dim);
            if method == 'q'
                grad = grad + qGrad(u);
            elseif method == 'h'
                grad = grad + hGrad(u,gamma);
            else
                grad = grad + dGrad(u,gamma);
            end
        end
    end

end