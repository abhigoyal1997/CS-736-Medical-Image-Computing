function [Rf,Aw] = myFilter(R,t,filter,L)

    function Cw = C(w,L)
        if strcmp(filter,'ram-lak')
            Cw = ones(size(w));
        elseif strcmp(filter,'shepp-logan')
            Cw = sinc(0.5*w/L);
        else
            Cw = cos(0.5*pi*w/L);
        end
    end

    FR = fft(R,[],1);
    w = linspace(-1,1,length(t))';
    L = L*max(w);
    w_abs = abs(w);
    Aw = w_abs.*C(w,L);
    Aw(w_abs > L) = 0;
    Aws = circshift(Aw,[floor(length(Aw)/2) 0]);
    Rf = real(ifft(Aws.*FR,[],1));
end

