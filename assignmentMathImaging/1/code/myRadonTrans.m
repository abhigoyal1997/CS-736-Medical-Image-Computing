function [result,t,theta] = myRadonTrans(im,delta_t,delta_theta,delta_s)
    t = -90:delta_t:90;
    theta = 0:delta_theta:(180-delta_theta);
    
    [p,q] = meshgrid(theta,t);
    t_g = q(:);
    theta_g = p(:);
    
    result = myIntegration(im,t_g,theta_g,delta_s);
    result = reshape(result, numel(t), numel(theta));
end

