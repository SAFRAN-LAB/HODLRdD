function [max_val, max_all] = bern_fun(a,b,source,target_end,choice)
    x   = linspace(-1,1,187903);
    z   = exp(2i*pi*x);                          % The unit circle centered at origin
    rho = 2.1;                                   % The "rho" of the ellipse
    switch choice
        case 1
            fun = @(y) 1./(y-target_end);
        case 2
            fun = @(y) log(y-target_end);
        case 3
            fun = @(y) exp(1*i*(y-target_end))./(y-target_end);
        case 4
            fun = @(y) besselh(1,1*(y-target_end));
        case 5
            fun = @(y) ((y-target_end));
        case 6
            fun = @(y) sin((y-target_end));
        case 7
            fun = @(y) 1./sqrt(1+(y-target_end));
        case 8
            fun = @(y) exp(-(y-target_end));
        case 9
            fun = @(y) 1./(y-target_end).^7;
        case 10
            fun = @(y) cos(100*(y-target_end))./(y-target_end);
        case 11
            fun = @(y) sin(100*(y-target_end))./(y-target_end);
    end
    
    len = b-a;                                            % Length of the source interval
    
    [~,SOURCE_SIZE] = size(source);
    max_iter = ceil(log2(SOURCE_SIZE));                                         % Number of sub-divisions of the source 
    MAX_VAL = zeros(max_iter,1);                                                % To store the max value in complex plane           
    max_val_all = zeros(max_iter,1);
    for iter = 1:max_iter
        low = a + len/2;
        high = low + len/2; 

     
        e = (rho*z+(rho*z).^(-1))/2;                                            % Bern ellipse w.r.t. [-1,1]
        %plot(e)
        mid = (low+high)/2;
        semi_major_right = (high+low)/2 + ((high-low)/2) * (rho+rho^(-1))/2;    % Real shifting
        semi_minor_up = ((high-low)/2) * (rho-rho^(-1))/2;                      % Imaginary shifting
        semi_major_left = (high+low)/2 - ((high-low)/2) * (rho+rho^(-1))/2;     % Real shifting
        semi_minor_down = -((high-low)/2) * (rho-rho^(-1))/2;                   % Imaginary shifting
        sum_semi_major_minor = semi_minor_up + semi_major_right-mid;
        e = (high+low)/2 + ((high-low)/2) .* e;                                 % Shifting Bern ellipse to Y_i
        [max_val_all(iter,1), id] = max(abs(fun(e)));
        plot(e), hold on
        plot(mid,semi_minor_up,"-o"), plot(semi_major_right,0,"-*")
        plot(mid,semi_minor_down,"-^"), plot(semi_major_left,0,"-s")
        z1 = mid + 1i* semi_minor_down;
        z2 = mid + 1i* semi_minor_up;
        z3 = semi_major_left + 0*i;
        z4 = semi_major_right + 0*i;
        abs(fun(z1));
        vec = [z1 z2 z3 z4];
        [MAX_VAL(iter,1),ind] = max([abs(fun(z1)),abs(fun(z2)),abs(fun(z3)),abs(fun(z4))]);
        len = len/2;
    end
    grid on
    axis equal
    title("Generalized Bernstein ellipses")
    MAX_VAL;
    max_val = max(max(MAX_VAL));
    max_all = max(max(max_val_all));
end
