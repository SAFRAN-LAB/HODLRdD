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
    xs = linspace(0,1,nP(i)+2);
    xs(1) = [];
    xs(end) = [];
    ys = linspace(0,1,nP(i)+2);
    ys(1) = [];
    ys(end) = [];
    zs = linspace(0,1,nP(i)+2);
    zs(1) = [];
    zs(end) = [];
    ws = linspace(0,1,nP(i)+2);
    ws(1) = [];
    ws(end) = [];
    %Destination Box
    xd = linspace(1,2,nP(i)+2);
    xd(1) = [];
    xd(end) = [];
    yd = linspace(1,2,nP(i)+2);
    yd(1) = [];
    yd(end) = [];
    zd = linspace(1,2,nP(i)+2);
    zd(1) = [];
    zd(end) = [];
    wd = linspace(1,2,nP(i)+2);
    wd(1) = [];
    wd(end) = [];

    % compute Result
    [r(i),err(i),~] = compute_norm(nDim,nP(i),choice,xs,xd,ys,yd,zs,zd,ws,wd);
    fprintf('Numerical Rank    : %d -- %d\n',r(i), N(i));
end
% print Result
fprintf('VERTEX SHARING 4D for choice %d \t : \n', choice);
fprintf("------------------------------------\n");
for i = 1:m
    fprintf('System Size       : %d\n',N(i));
    fprintf('Numerical Rank    : %d\n',r(i));
    fprintf('Error in 2-Norm   : %d\n',err(i));
    fprintf("------------------------------------\n");
end
csvwrite('N_ver.csv',N)
csvwrite('rank_ver.csv',r)
csvwrite('error_ver.csv',err)

% cp string  
% display([N' r' err']);
