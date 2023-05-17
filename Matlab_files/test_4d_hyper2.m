clc;

%%%% Edit here %%%%
nP = [5 7];  % Number of particles along 1D
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
    xs(1) = [];
    xs(end) = [];
    ys = linspace(0,1,nP(i));
    ys(1) = [];
    ys(end) = [];
    zs = linspace(0,1,nP(i));
    zs(1) = [];
    zs(end) = [];
    ws = linspace(0,1,nP(i));
    ws(1) = [];
    ws(end) = [];
    %Destination Box
    xd = linspace(0,1,nP(i));
    xd(1) = [];
    xd(end) = [];
    yd = linspace(0,1,nP(i));
    yd(1) = [];
    yd(end) = [];
    zd = linspace(0,1,nP(i));
    zd(1) = [];
    zd(end) = [];
    wd = linspace(1.01,2,nP(i));
    wd(1) = [];
    wd(end) = [];

    % compute Result
    [r(i),err(i),~] = compute_norm(nDim,nP(i),choice,xs,xd,ys,yd,zs,zd,ws,wd);
    fprintf('Numerical Rank    : %d -- %d\n',r(i), N(i));
end
% print Result
fprintf('HYPER SHAPE 2 4D for choice %d \t : \n', choice);
fprintf("------------------------------------\n");
for i = 1:m
    fprintf('System Size       : %d\n',N(i));
    fprintf('Numerical Rank    : %d\n',r(i));
    fprintf('Error in 2-Norm   : %d\n',err(i));
    fprintf("------------------------------------\n");
end
csvwrite('N_h2.csv',N)
csvwrite('rank_h2.csv',r)
csvwrite('error_h2.csv',err)

% cp string  
% display([N' r' err']);
