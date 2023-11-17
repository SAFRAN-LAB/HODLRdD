clear
close
clc

choice = 6;

%%%%%%%%%%% SOURCE %%%%%%%%%%%
SOURCE_SIZE = 10^5;
a = 0;                                                                      % Source interval [a,b]
b = 1;
source = linspace(a,b,SOURCE_SIZE+2);
source(1) = [];                                                             % Vertex sharing
source(end) = [];

%%%%%%%%%%% TARGET %%%%%%%%%%%
TAR_SIZE = SOURCE_SIZE;                                                     % Number of targets 
c = -1;
d = 0;
target = linspace(c,d,TAR_SIZE+2);                                          % Target interval [c,d]
target(1) = [];
target(end) = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    switch choice
        case 1
            K_max = 1/abs(source(1)-target(end));
        case 2
            K_max = max(abs(log(source(end)-target(1))),abs(log(source(1)-target(end))));
        case 3
            K_max = 1/abs(source(1)-target(end));
        case 4
            K_max = abs(besselh(2,1*abs(source(1)-target(end))));
        case 5
            K_max = abs(source(end)-target(1));
        case 6
            K_max = max(abs(sin(source(end)-target(1))),abs(sin(source(1)-target(end))));
        case 7
            K_max = 1/abs(sqrt(1+source(1)-target(end)));
        case 8
            K_max =  abs(exp(-(source(1)-target(end))));
        case 9
            K_max = 1/(abs(source(1)-target(end)))^7;
        case 10
            K_max = abs(cos(100*abs(source(1)-target(end)))/abs(source(1)-target(end)));
        case 11
            K_max = abs(sin(100*abs(source(1)-target(end)))/abs(source(1)-target(end)));
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[m1,max_all_1] = bern_fun(a,b,source,target(1),choice);
fprintf("=============================\n\n");
[m2,max_all_2] = bern_fun(a,b,source,target(end),choice);
% [m1,max_all_1];
% [m2,max_all_2];
max_val_M = max([m1,m2,max_all_1,max_all_2])
K_max_val = K_max 
c = max_val_M/K_max
fprintf("=============================\n\n");