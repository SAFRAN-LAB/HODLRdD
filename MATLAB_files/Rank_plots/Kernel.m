%-----------------------------------------------
% Define the Kernel 
% r be the distance evaluated between to points
% r can be a matrix, a vector or a scaler
%-----------------------------------------------

function [K] = Kernel(r,choice)
    switch choice
        case 1
            K = 1./r;
        case 2
            K = log(r);
        case 3
            K = besselh(2,r);
        case 4
            K = exp(1i*r)./r;
        case 5
            K = r;
        case 6
            K = sin(r);
        case 7
            K = 1./sqrt(1+r);
        case 8
            K = exp(-r);
    end
end
