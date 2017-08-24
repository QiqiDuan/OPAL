function [opt_fp, opt_fv, run_time, num_fe] = ...
    NelderMead(fhd, fun_ind, fun_dim, slb, sub, pop_size, num_fe, max_fe, rsip)
% *********************************************************************** %
% Nelder-Mead Simplex Search Algorithm [NelderMead].
%
% -----------------
% || INPUT  || <---
% -----------------
%   fhd        <--- str2func, function handler
%   fun_ind    <--- matrix(1, 1), function index
%   fun_dim    <--- matrix(1, 1), function dimension
%   slb        <--- matrix(pop_size, fun_dim), search lower bound
%   sub        <--- matrix(pop_size, fun_dim), search upper bound
%   pop_size   <--- matrix(1, 1), population size which should be set to [fun_dim + 1]
%   num_fe     <--- matrix(1, 1), initial number of function evaluation
%   max_fe     <--- matrix(1, 1), maximum of function evaluation
%   rsip       <--- matrix(1, 1), rand seed for initializing the population
%
% -----------------
% || OUTPUT || --->
% -----------------
%   opt_fp     ---> matrix(1, fun_dim), optimal function position
%   opt_fv     ---> matrix(1, 1), optimal function value
%   run_time   ---> matrix(1, 1), run time
%   num_fe     ---> matrix(1, 1), final number of function evaluation
%
% ----------
% Reference:
% ----------
%   1. Nelder JA, Mead R. A simplex method for function minimization.
%       The computer journal. 1965 Jan 1;7(4):308-13.
%   2. http://people.sc.fsu.edu/~jburkardt/m_src/nelder_mead/nelder_mead.m
%   3. http://people.sc.fsu.edu/~jburkardt/m_src/asa047/nelmin.m
% *********************************************************************** %
    % initialize experimental parameters
    run_time_start = tic;
    
    % initialize algorithmic parameters
    alpha = 1.0;
    gamma = 2.0;
    beta = 0.5;
    
    fp = slb + (sub - slb) .* rand(RandStream('mt19937ar', 'Seed', rsip), fun_dim, pop_size)';
    fv = feval(fhd, fp, fun_ind);
    num_fe = num_fe + pop_size;
    [fv, sort_idx] = sort(fv);
    fp = fp(sort_idx, :);
    
    while num_fe < max_fe
        centroid = mean(fp(1 : fun_dim, :), 1);
        
        % P_a == P*  fp(pop_size, :) == Ph
        P_a = (1 + alpha) * centroid - alpha * fp(pop_size, :);
        y_a = feval(fhd, P_a, fun_ind); % y_a == y*
        num_fe = num_fe + 1;
        
        if y_a < fv(1, 1) % obtain the best result
            P_aa = (1 + gamma) * P_a - gamma * centroid;
            y_aa = feval(fhd, P_aa, fun_ind); % y_aa == y**
            num_fe = num_fe + 1;
            
            if y_aa < y_a % again obtain the best result
                fp(pop_size, :) = P_aa;
                fv(1, pop_size) = y_aa;
            else % cannot again obtain the best result
                fp(pop_size, :) = P_a;
                fv(1, pop_size) = y_a;
            end
        elseif (fv(1, 1) <= y_a) && (y_a <= fv(1, fun_dim)) % obtain the middle result
            fp(pop_size, :) = P_a;
            fv(1, pop_size) = y_a;
        else % obtain the second worst or the worst result
            if (fv(1, fun_dim) < y_a) && (y_a < fv(1, pop_size)) % obtain the second worst result
                fp(pop_size, :) = P_a;
                fv(1, pop_size) = y_a;
            end
            
            P_aa = beta * fp(pop_size, :) + (1 - beta) * centroid;
            y_aa = feval(fhd, P_aa, fun_ind);
            num_fe = num_fe + 1;
            
            if y_aa < y_a % again obtain the second worst result
                fp(pop_size, :) = P_aa;
                fv(1, pop_size) = y_aa;
            else % again obtain the worst result
                fp = (fp + repmat(fp(1, :), pop_size, 1)) / 2.0;
                fv = feval(fhd, fp, fun_ind);
                num_fe = num_fe + pop_size;
            end
        end
        
        [fv, sort_idx] = sort(fv);
        fp = fp(sort_idx, :);
    end
    
    opt_fp = fp(1, :);
    opt_fv = fv(1);
    
    run_time = toc(run_time_start);
end
