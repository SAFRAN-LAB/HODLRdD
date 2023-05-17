function r = numerical_rank(X,tolr)
% This function calculates the Numerical rank provided the Eigen values
% X - Either the matrix or Vector of Eigen values
% tolr - either array or KD#%&
    itr_count = length(tolr);
% dim = size(X);
% if dim(2) > 1% Computes the matrix's numerical rank for a matrix
%     sv = svd(X);
%     %MAX_SVD = max(ev); ev = ev/MAX_SVD;
%     r = zeros(itr_count,1);
%    for k = 1:itr_count
%        r(k) = length(find(sv>tolr(k)));
%    end
% else  %Computes the matrix's numerical rank provided eigen values
    r = zeros(itr_count,1);
    MAX_SVD = max(X);
    sv = X/MAX_SVD;
    for k = 1:itr_count
       r(k) = length(find(sv>tolr(k)));
    end
end