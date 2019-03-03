function result = myIntegration(im,t,theta,delta_s)
    [m,n] = size(im);
    m = m/2.0;
    n = n/2.0;
    
    s = repmat(-90:delta_s:90,numel(t),1);
    x = m+t.*cosd(theta) + s.*sind(theta);
    y = n+s.*cosd(theta) - t.*sind(theta);
    
    f = interp2(im,x,y,'linear',0);
    result = sum(f,2)*delta_s;
end

