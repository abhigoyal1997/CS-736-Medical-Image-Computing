function potential = mrfPotential(x, method, gamma)

    function qL = qLoss(u)
        qL = abs(u).^2;
    end

    function hL = hLoss(u, gamma)
        u = abs(u);
        cond = (u <= gamma);
        hL = 0.5*(u.^2).*cond + (gamma*u - 0.5*gamma^2).*(~cond);
    end

    function dL = dLoss(u, gamma)
        u = abs(u);
        dL = gamma*u - (gamma^2)*log(1+u/gamma);
    end

    potential = 0;
    for dim=[1,2]
        for k=[-1,1]
            u = x - circshift(x,k,dim);
            if method == 'q'
                potential = potential + qLoss(u);
            elseif method == 'h'
                potential = potential + hLoss(u,gamma);
            else
                potential = potential + dLoss(u,gamma);
            end
        end
    end

end