function [rk, err,A] = compute_norm(nDim,nPoints,choice,xs,xd,ys,yd,zs,zd,ws,wd)
% `This function computes the interaction matrix, and performs svd 
%  and computes the numerical rank. It also provides the err = |A-A*|_2/|A|_2
%   where A* is the reduced svd approximation of the matrix A with rank rk
%   approximation. KD#%&
% Input arguments (suffix: s - denotes source d - denotes destination)
% nDim - number of dimensions
% nPoints - number of points in single dimension (N = nPoints^nDim)
% xs,ys,zs - source linspace in [a:h:b] in each dimension which is used to
% produce a grid
% xd,yd,zd - destination linspace in [c:h:d] in each dimension which is used to
% produce a grid

% Output arguments 
% err = |A-A*|_2/|A|_2
% rk = numerical rank of the interaction matrix

N = nPoints^nDim;
    if nargin == 5
        xs = ndgrid(xs); 
        xd = ndgrid(xd);
        xs = xs(:); xd = xd(:);
%         display(xs);
%         display(xd);
        A = zeros(N);
        % par DEF
        % r^2
        for i = 1:N
            A(:,i)     =  (xs - xd(i)).^2;
        end
        % r
        A = sqrt(A);
    end
    if nargin == 7 
        [xs,ys] = ndgrid(xs,ys); 
        [xd,yd] = ndgrid(xd,yd);
        xs = xs(:); xd = xd(:);
        ys = ys(:); yd = yd(:);
        display(xs);
        display(ys);
        A = zeros(N);
        % par DEF
        % r^2
        for i = 1:N
            A(:,i)     =  (xs - xd(i)).^2 + (ys - yd(i)).^2;
        end
        % r
        A = sqrt(A);
        %par ADD
    end
    if nargin == 9  
         [xs,ys,zs] = ndgrid(xs,ys,zs);
         [xd,yd,zd] = ndgrid(xd,yd,zd);
         xs = xs(:); xd = xd(:);
         ys = ys(:); yd = yd(:);
         zs = zs(:); zd = zd(:);
         A = zeros(N);
         % par DEF
        % r^2
        for i = 1:N
            A(:,i)     =  (xs - xd(i)).^2 + (ys - yd(i)).^2 + (zs - zd(i)).^2;
        end
        % r
        A = sqrt(A);
        %par ADD
    end
    if nargin == 11  
         [xs,ys,zs,ws] = ndgrid(xs,ys,zs,ws);
         [xd,yd,zd,wd] = ndgrid(xd,yd,zd,wd);
         xs = xs(:); xd = xd(:);
         ys = ys(:); yd = yd(:);
         zs = zs(:); zd = zd(:);
         ws = ws(:); wd = wd(:);
         A = zeros(N);
         % par DEF
        % r^2
        for i = 1:N
            A(:,i)     =  (xs - xd(i)).^2 + (ys - yd(i)).^2 + (zs - zd(i)).^2 ...
                         +(ws - wd(i)).^2;
        end
        % r
        A = sqrt(A);
        %par ADD
    end    

    % Change choice if you want to change the kernel
    A = Kernel(A,choice);
    
    %par ADD
    rk = max_error_numerical_rank(A,1e-12);
    err = 1; 
end