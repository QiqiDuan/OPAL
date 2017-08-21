function fv = benchmark_func(fp, fun_ind)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% CEC2013-2015 LSGO Benchmark Functions.
%
% -----------------
% || INPUT  || <---
% -----------------
%   fp         <--- matrix(pop_size, fun_dim), function position
%   fun_ind    <--- matrix(1, 1), function index [1, 15]
%
% -----------------
% || OUTPUT || --->
% -----------------
%   fv         ---> matrix(1, pop_size), function value
%
% ----------
% Reference:
% ----------
%   1. X. Li, K. Tang, M. Omidvar, Z. Yang, and K. Qin. "Benchmark Functions 
%       for the CEC'2013 Special Session and Competition on Large Scale 
%       Global Optimization". Technical Report, Evolutionary Computation 
%       and Machine Learning Group, RMIT University, Australia, 2013.
%   2. https://titan.csit.rmit.edu.au/~e46507/ieee-lsgo/
%   3. http://staff.ustc.edu.cn/~ketang/lsgo2015.html
%
% -----
% NOTE:
% -----
%   The original MATLAB code was written by M. Omidvar et al. Here, one
%       main change is that the *global* variable is removed for simplicity.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
    persistent fhd curr_fun_ind; % current function index
    if isempty(curr_fun_ind) || curr_fun_ind ~= fun_ind
        curr_fun_ind = fun_ind;
        if     fun_ind == 1
            fhd = str2func('f1');
        elseif fun_ind == 2
            fhd = str2func('f2');
        elseif fun_ind == 3
            fhd = str2func('f3');
        elseif fun_ind == 4
            fhd = str2func('f4');
        elseif fun_ind == 5
            fhd = str2func('f5');
        elseif fun_ind == 6
            fhd = str2func('f6');
        elseif fun_ind == 7
            fhd = str2func('f7');
        elseif fun_ind == 8
            fhd = str2func('f8');
        elseif fun_ind == 9
            fhd = str2func('f9');
        elseif fun_ind == 10
            fhd = str2func('f10');
        elseif fun_ind == 11
            fhd = str2func('f11');
        elseif fun_ind == 12 
            fhd = str2func('f12');
        elseif fun_ind == 13
            fhd = str2func('f13');
        elseif fun_ind == 14
            fhd = str2func('f14');
        elseif fun_ind == 15 
            fhd = str2func('f15');
        end
    end
    fv = feval(fhd, fp');
end

% ----------------------------------------------------------------------- %
function fv = sphere(fp)
    fv = sum(fp .^ 2, 1);
end

function fv = elliptic(fp)
    [fun_dim, ~] = size(fp);
    fp = T_irreg(fp);
    fv = (1e6 .^ linspace(0, 1, fun_dim)) * (fp .^ 2);
end

function fv = rastrigin(fp)
    [fun_dim, ~] = size(fp);
    fp = T_diag(T_asy(T_irreg(fp), 0.2), 10);
    fv = 10 * (fun_dim - sum(cos(2 * pi * fp), 1)) + sum(fp .^ 2, 1);
end

function fv = ackley(fp)
    [fun_dim, ~] = size(fp);
    fp = T_diag(T_asy(T_irreg(fp), 0.2), 10);
    fv = - 20 * exp(-0.2 * sqrt(sum(fp .^ 2, 1) / fun_dim)) ...
        - exp(sum(cos(2 * pi * fp), 1) / fun_dim) + 20 + exp(1);
end

function fv = schwefel(fp)
    [fun_dim, pop_size] = size(fp);
    fp = T_asy(T_irreg(fp), 0.2);
    fv = zeros(1, pop_size);
    for i = 1 : fun_dim
        fv = fv + sum(fp(1 : i, :), 1) .^ 2;
    end
end

function fv = rosenbrock(fp)
    [fun_dim, ~] = size(fp);
    fv = sum(100 * (fp(1 : (fun_dim - 1), :) .^ 2 - ...
        fp(2 : fun_dim, :)) .^ 2 + (fp(1 : (fun_dim - 1), :) - 1) .^ 2, 1);
end

% ----------------------------------------------------------------------- %
function fv = f1(fp)
    persistent xopt flag; % flag ---> indicate whether is the first call
    if isempty(flag)
        flag = true;
        load 'datafiles/f01.mat' xopt;
    end
    
    [~, pop_size] = size(fp);
    fv = elliptic(fp - repmat(xopt, 1, pop_size));
end

function fv = f2(fp)
    persistent xopt flag;
    if isempty(flag)
        flag = true;
        load 'datafiles/f02.mat' xopt;
    end
    
    [~, pop_size] = size(fp);
    fv = rastrigin(fp - repmat(xopt, 1, pop_size));
end

function fv = f3(fp)
    persistent xopt flag;
    if isempty(flag)
        flag = true;
        load 'datafiles/f03.mat' xopt;
    end
    
    [~, pop_size] = size(fp);
    fv = ackley(fp - repmat(xopt, 1, pop_size));
end

function fv = f4(fp)
    persistent xopt p s R25 R50 R100 w flag;
    if isempty(flag)
        flag = true;
        load 'datafiles/f04.mat' xopt p s R25 R50 R100 w;
    end
    
    [~, pop_size] = size(fp);
    fp = fp - repmat(xopt, 1, pop_size);
    fv = 0;
    ldim = 1;
    for i = 1 : length(s)
        if s(i) == 25
            fv_sub = elliptic(R25 * fp(p(ldim : (ldim + s(i) - 1)), :));
            ldim = ldim + s(i);
        elseif s(i) == 50
            fv_sub = elliptic(R50 * fp(p(ldim : (ldim + s(i) - 1)), :));
            ldim = ldim + s(i);
        elseif s(i) == 100
            fv_sub = elliptic(R100 * fp(p(ldim : (ldim + s(i) - 1)), :));
            ldim = ldim + s(i);
        end
        fv = fv + w(i) * fv_sub;
    end
    fv = fv + elliptic(fp(p(ldim : end), :));
end

function fv = f5(fp) 
    persistent xopt p s R25 R50 R100 w flag;
    if isempty(flag)
        flag = true;
        load 'datafiles/f05.mat' xopt p s R25 R50 R100 w;
    end
    
    [~, pop_size] = size(fp);
    fp = fp - repmat(xopt, 1, pop_size);
    fv = 0;
    ldim = 1;
    for i = 1 : length(s)
        if s(i) == 25
            fv_sub = rastrigin(R25 * fp(p(ldim : (ldim + s(i) - 1)), :));
            ldim = ldim + s(i);
        elseif s(i) == 50
            fv_sub = rastrigin(R50 * fp(p(ldim : (ldim + s(i) - 1)), :));
            ldim = ldim + s(i);
        elseif s(i) == 100
            fv_sub = rastrigin(R100 * fp(p(ldim : (ldim + s(i) - 1)), :));
            ldim = ldim + s(i);
        end
        fv = fv + w(i) * fv_sub;
    end
    fv = fv + rastrigin(fp(p(ldim : end), :));
end

function fv = f6(fp)
    persistent xopt p s R25 R50 R100 w flag;
    if isempty(flag)
        flag = true;
        load 'datafiles/f06.mat' xopt p s R25 R50 R100 w;
    end
    
    [~, pop_size] = size(fp);
    fp = fp - repmat(xopt, 1, pop_size);
    fv = 0;
    ldim = 1;
    for i = 1 : length(s)
        if s(i) == 25
            fv_sub = ackley(R25 * fp(p(ldim : (ldim + s(i) - 1)), :));
            ldim = ldim + s(i);
        elseif s(i) == 50
            fv_sub = ackley(R50 * fp(p(ldim : (ldim + s(i) - 1)), :));
            ldim = ldim + s(i);
        elseif s(i) == 100
            fv_sub = ackley(R100 * fp(p(ldim : (ldim + s(i) - 1)), :));
            ldim = ldim + s(i);
        end
        fv = fv + w(i) * fv_sub;
    end
    fv = fv + ackley(fp(p(ldim : end), :));
end

function fv = f7(fp)
    persistent xopt p s R25 R50 R100 w flag;
    if isempty(flag)
        flag = true;
        load 'datafiles/f07.mat' xopt p s R25 R50 R100 w;
    end
    
    [~, pop_size] = size(fp);
    fp = fp - repmat(xopt, 1, pop_size);
    fv = 0;
    ldim = 1;
    for i = 1 : length(s)
        if s(i) == 25
            fv_sub = schwefel(R25 * fp(p(ldim : (ldim + s(i) - 1)), :));
            ldim = ldim + s(i);
        elseif s(i) == 50
            fv_sub = schwefel(R50 * fp(p(ldim : (ldim + s(i) - 1)), :));
            ldim = ldim + s(i);
        elseif s(i) == 100
            fv_sub = schwefel(R100 * fp(p(ldim : (ldim + s(i) - 1)), :));
            ldim = ldim + s(i);
        end
        fv = fv + w(i) * fv_sub;
    end
    fv = fv + sphere(fp(p(ldim : end), :));
end

function fv = f8(fp)
    persistent xopt p s R25 R50 R100 w flag;
    if isempty(flag)
        flag = true;
        load 'datafiles/f08.mat' xopt p s R25 R50 R100 w;
    end
    
    [~, pop_size] = size(fp);
    fp = fp - repmat(xopt, 1, pop_size);
    fv = 0;
    ldim = 1;
    for i = 1 : length(s)
        if s(i) == 25
            fv_sub = elliptic(R25 * fp(p(ldim : (ldim + s(i) - 1)), :));
            ldim = ldim + s(i);
        elseif s(i) == 50
            fv_sub = elliptic(R50 * fp(p(ldim : (ldim + s(i) - 1)), :));
            ldim = ldim + s(i);
        elseif s(i) == 100
            fv_sub = elliptic(R100 * fp(p(ldim : (ldim + s(i) - 1)), :));
            ldim = ldim + s(i);
        end
        fv = fv + w(i) * fv_sub;
    end
end

function fv = f9(fp)
    persistent xopt p s R25 R50 R100 w flag;
    if isempty(flag)
        flag = true;
        load 'datafiles/f09.mat' xopt p s R25 R50 R100 w;
    end
    
    [~, pop_size] = size(fp);
    fp = fp - repmat(xopt, 1, pop_size);
    fv = 0;
    ldim = 1;
    for i = 1 : length(s)
        if s(i) == 25
            fv_sub = rastrigin(R25 * fp(p(ldim : (ldim + s(i) - 1)), :));
            ldim = ldim + s(i);
        elseif s(i) == 50
            fv_sub = rastrigin(R50 * fp(p(ldim : (ldim + s(i) - 1)), :));
            ldim = ldim + s(i);
        elseif s(i) == 100
            fv_sub = rastrigin(R100 * fp(p(ldim : (ldim + s(i) - 1)), :));
            ldim = ldim + s(i);
        end
        fv = fv + w(i) * fv_sub;
    end
end

function fv = f10(fp)
    persistent xopt p s R25 R50 R100 w flag;
    if isempty(flag)
        flag = true;
        load 'datafiles/f10.mat' xopt p s R25 R50 R100 w;
    end
    
    [~, pop_size] = size(fp);
    fp = fp - repmat(xopt, 1, pop_size);
    fv = 0;
    ldim = 1;
    for i = 1 : length(s)
        if s(i) == 25
            fv_sub = ackley(R25 * fp(p(ldim : (ldim + s(i) - 1)), :));
            ldim = ldim + s(i);
        elseif s(i) == 50
            fv_sub = ackley(R50 * fp(p(ldim : (ldim + s(i) - 1)), :));
            ldim = ldim + s(i);
        elseif s(i) == 100
            fv_sub = ackley(R100 * fp(p(ldim : (ldim + s(i) - 1)), :));
            ldim = ldim + s(i);
        end
        fv = fv + w(i) * fv_sub;
    end
end

function fv = f11(fp)
    persistent xopt p s R25 R50 R100 w flag;
    if isempty(flag)
        flag = true;
        load 'datafiles/f11.mat' xopt p s R25 R50 R100 w;
    end
    
    [~, pop_size] = size(fp);
    fp = fp - repmat(xopt, 1, pop_size);
    fv = 0;
    ldim = 1;
    for i = 1 : length(s)
        if s(i) == 25
            fv_sub = schwefel(R25 * fp(p(ldim : (ldim + s(i) - 1)), :));
            ldim = ldim + s(i);
        elseif s(i) == 50
            fv_sub = schwefel(R50 * fp(p(ldim : (ldim + s(i) - 1)), :));
            ldim = ldim + s(i);
        elseif s(i) == 100
            fv_sub = schwefel(R100 * fp(p(ldim : (ldim + s(i) - 1)), :));
            ldim = ldim + s(i);
        end
        fv = fv + w(i) * fv_sub;
    end
end

function fv = f12(fp)
    persistent xopt flag;
    if isempty(flag)
        flag = true;
        load 'datafiles/f12.mat' xopt;
    end
    
    [~, pop_size] = size(fp);
    fv = rosenbrock(fp - repmat(xopt, 1, pop_size));
end

function fv = f13(fp)
    persistent xopt p s R25 R50 R100 m c w flag;
    if isempty(flag)
        flag = true;
        load 'datafiles/f13.mat' xopt p s R25 R50 R100 m w;
        c = cumsum(s);
    end
    
    [~, pop_size] = size(fp);
    fp = fp - repmat(xopt, 1, pop_size);
    fv = 0;
    for i = 1 : length(s)
        if i == 1
            ldim = 1;
        else
            ldim = c(i - 1) - ((i - 1) * m) + 1;
        end
        udim = c(i) - ((i - 1) * m);
        if s(i) == 25
            fv_sub = schwefel(R25 * fp(p(ldim : udim), :));
        elseif s(i) == 50
            fv_sub = schwefel(R50 * fp(p(ldim : udim), :));
        elseif s(i) == 100
            fv_sub = schwefel(R100 * fp(p(ldim : udim), :));
        end
        fv = fv + w(i) * fv_sub;
    end
end

function fv = f14(fp)
    persistent xopt p s R25 R50 R100 m c w flag;
    if isempty(flag)
        flag = true;
        load 'datafiles/f14.mat' xopt p s R25 R50 R100 m w;
        c = cumsum(s);
    end

    [~, pop_size] = size(fp);
    fv = 0;
    for i = 1 : length(s)
        if i == 1
            ldim = 1;
            ldimshift = 1;
        else
            ldim = c(i - 1) - ((i - 1) * m) + 1;
            ldimshift = c(i - 1) + 1;
        end
        udim = c(i) - ((i - 1) * m);
        udimshift = c(i);
        z = fp(p(ldim : udim), :) - repmat(xopt(ldimshift : udimshift), ...
            1, pop_size);
        if s(i) == 25
            fv_sub = schwefel(R25 * z);
        elseif s(i) == 50
            fv_sub = schwefel(R50 * z);
        elseif s(i) == 100
            fv_sub = schwefel(R100 * z);
        end
        fv = fv + w(i) * fv_sub;
    end
end

function fv = f15(fp)
    persistent xopt flag;
    if isempty(flag)
        flag = true;
        load 'datafiles/f15.mat' xopt;
    end
    
    [~, pop_size] = size(fp);
    fv = schwefel(fp - repmat(xopt, 1, pop_size));
end

% ----------------------------------------------------------------------- %
function fp = T_asy(fp, beta)
    [fun_dim, pop_size] = size(fp);
    exponent = repmat(beta * linspace(0, 1, fun_dim)', 1, pop_size); 
    fp(fp > 0) = fp(fp > 0) .^ (1 + exponent(fp > 0) .* sqrt(fp(fp > 0)));  
end

function fp = T_diag(fp, alpha)
    [fun_dim, popsize] = size(fp);
    scales = repmat(sqrt(alpha) .^ linspace(0, 1, fun_dim)', 1, popsize); 
    fp = scales .* fp;
end

function fp_tmp = T_irreg(fp)
   fp_tmp = fp;
   
   fp_tmp(fp > 0) = log(fp(fp > 0)) / 0.1;
   fp_tmp(fp < 0) = log(-fp(fp < 0)) / 0.1;
   
   fp_tmp(fp > 0) = exp(fp_tmp(fp > 0) + 0.49 * (sin(fp_tmp(fp > 0)) ...
       + sin(0.79 * fp_tmp(fp > 0)))) .^ 0.1;
   fp_tmp(fp < 0) = -exp(fp_tmp(fp < 0) + 0.49 * (sin(0.55 * ...
       fp_tmp(fp < 0)) + sin(0.31 * fp_tmp(fp < 0)))) .^ 0.1;
end
