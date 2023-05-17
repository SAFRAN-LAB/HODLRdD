clc;
clear all;
%%%% Edit here %%%%
nP = [5,7];  % Number of particles along 1D
nDim = 4;
choice = 1;          % Choice 1  = 1/r , 2 = log(r)... look at Kernel.m
%%%%%%%%%%%%%%%%%%%

N = nP.^nDim;
[~,m] = size(nP);
r = zeros(1,m);
err = zeros(1,m);
for i = 1:m
    % Source Box
    xs = linspace(-1,0,nP(i));
    ys = linspace(0,1,nP(i));
    zs = linspace(0,1,nP(i));
    ws = linspace(0,1,nP(i));
    %Destination Box
    xd = linspace(1,2,nP(i));
    yd = linspace(0,1,nP(i));
    zd = linspace(0,1,nP(i));
    wd = linspace(0,1,nP(i));

    % compute Result
    [r(i),err(i),~] = compute_norm(nDim,nP(i),choice,xs,xd,ys,yd,zs,zd,ws,wd);
    fprintf('Numerical Rank    : %d -- %d\n',r(i), N(i));
end
% print Result
fprintf('FAR FIELD 4D for choice %d \t : \n', choice);
fprintf("------------------------------------\n");
for i = 1:m
    fprintf('System Size       : %d\n',N(i));
    fprintf('Numerical Rank    : %d\n',r(i));
    fprintf('Error in 2-Norm   : %d\n',err(i));
    fprintf("------------------------------------\n");
end
csvwrite('N_far.csv',N)
csvwrite('rank_far.csv',r)
csvwrite('error_far.csv',err)

% cp string  
% display([N' r' err']);