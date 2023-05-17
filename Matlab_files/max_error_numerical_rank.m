function rk = max_error_numerical_rank(K,tol)
   % Choice is the type of kernel
   [u,s,v] = svd(K);
   normK = max(max(K))*tol;
    rk  =   1;
    K = K - u(:,rk)*s(rk,rk)*v(:,rk)';
    err = max(max(K));
    while err > normK && rk < length(u(1,:))
        rk = rk + 1;
        K = K - u(:,rk)*s(rk,rk)*v(:,rk)';
        norm(K);
        err = max(max(abs(K)));
    end
    % The loop breaks after computing this err; hence a decrement
    rk = rk - 1;
end