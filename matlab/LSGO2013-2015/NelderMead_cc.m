function [opt_fp, opt_fv, run_time, num_fe, fv_seq, in_seq] = ...
    NelderMead_cc(fhd, fun_ind, fp, num_fe, max_fe, interval_fe)
% *********************************************************************** %
% NELDERMEAD with the Convergence Curve data.
%
% -----------------
% || INPUT  || <---
% -----------------
%   fhd        <--- str2func, function handler
%   fun_ind    <--- matrix(1, 1), function index
%   fp         <--- matrix(fun_dim + 1, fun_dim), initial simplex
%   num_fe     <--- matrix(1, 1), initial number of function evaluation 
%   max_fe     <--- matrix(1, 1), maximum of function evaluation
%   interval_fe<--- matrix(1, 1), interval of function evaluation for convergence curve
%
% -----------------
% || OUTPUT || --->
% -----------------
%   opt_fp     ---> matrix(1, fun_dim), optimal function position
%   opt_fv     ---> matrix(1, 1), optimal function value
%   run_time   ---> matrix(1, 1), run time
%   num_fe     ---> matrix(1, 1), final number of function evaluation, 
%                   which might exceed *max_fe*
%   fv_seq     ---> matrix(1, ?), function value sequence for convergence curve, 
%                   the length of which is set by *max_fe* and *interval_fe*.
%                   the first value corresponds to the first function evaluation,
%                   the last value corresponds to the last function evaluation.
%   in_seq     ---> matrix(1, ?), interval sequence for convergence curve
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
    
    % --------------------- %
    in_seq = num_fe + 1;
    in_seq_start = num_fe + 1;
    % --------------------- %
    
    % initialize algorithmic parameters
    alpha = 1.0;
    gamma = 2.0;
    beta = 0.5;
    
    [num_simplex, fun_dim] = size(fp);
    fv = feval(fhd, fp, fun_ind);
    num_fe = num_fe + num_simplex;
    
    % --------------------- %
    fv_seq = fv(1, 1);
    in_seq_end = num_fe;
    in_seq_cache = in_seq_start : in_seq_end;
    in_seq_cache_true = false(1, length(in_seq_cache));
    fv_seq_cache = fv;
    for cache_ind = 1 : length(in_seq_cache)
        if in_seq_cache(1, cache_ind) <= max_fe
            if rem(in_seq_cache(1, cache_ind), interval_fe) == 0 || in_seq_cache(1, cache_ind) == max_fe
                in_seq_cache_true(1, cache_ind) = true;
            end
        end
    end
    if sum(in_seq_cache_true) > 0
        for cache_ind = 1 : (length(fv_seq_cache) - 1)
            if fv_seq_cache(1, cache_ind) < fv_seq_cache(1, cache_ind + 1)
                fv_seq_cache(cache_ind + 1) = fv_seq_cache(cache_ind);
            end
        end
        fv_seq = [fv_seq fv_seq_cache(1, in_seq_cache_true)];
        in_seq = [in_seq in_seq_cache(1, in_seq_cache_true)];
    end
    [opt_fv, ~] = min(fv);
    % --------------------- %
    
    [fv, sort_idx] = sort(fv);
    fp = fp(sort_idx, :);
    
    while num_fe < max_fe
        % --------------------- %
        opt_fv_bak = opt_fv;
        in_seq_start = num_fe + 1;
        % --------------------- %
        
        centroid = mean(fp(1 : fun_dim, :), 1);

        P_a = (1 + alpha) * centroid - alpha * fp(num_simplex, :); % P_a == P*  fp(num_simplex, :) == Ph
        y_a = feval(fhd, P_a, fun_ind); % y_a == y*
        num_fe = num_fe + 1;
        
        % --------------------- %
        fv_seq_cache = y_a;
        % --------------------- %
        
        if y_a < fv(1, 1) % obtain the best result
            P_aa = (1 + gamma) * P_a - gamma * centroid;
            y_aa = feval(fhd, P_aa, fun_ind); % y_aa == y**
            num_fe = num_fe + 1;
            
            % --------------------- %
            fv_seq_cache = [fv_seq_cache y_aa];
            % --------------------- %
            
            if y_aa < y_a % again obtain the best result
                fp(num_simplex, :) = P_aa;
                fv(1, num_simplex) = y_aa;
            else % cannot again obtain the best result
                fp(num_simplex, :) = P_a;
                fv(1, num_simplex) = y_a;
            end
        elseif (fv(1, 1) <= y_a) && (y_a <= fv(1, fun_dim)) % obtain the middle result
            fp(num_simplex, :) = P_a;
            fv(1, num_simplex) = y_a;
        else % obtain the second worst or the worst result
            if (fv(1, fun_dim) < y_a) && (y_a < fv(1, num_simplex)) % obtain the second worst result
                fp(num_simplex, :) = P_a;
                fv(1, num_simplex) = y_a;
            end
            
            P_aa = beta * fp(num_simplex, :) + (1 - beta) * centroid;
            y_aa = feval(fhd, P_aa, fun_ind);
            num_fe = num_fe + 1;
            
            % --------------------- %
            fv_seq_cache = [fv_seq_cache y_aa];
            % --------------------- %
            
            if y_aa < y_a % again obtain the second worst result
                fp(num_simplex, :) = P_aa;
                fv(1, num_simplex) = y_aa;
            else % again obtain the worst result
                fp = (fp + repmat(fp(1, :), num_simplex, 1)) / 2.0;
                fv = feval(fhd, fp, fun_ind);
                num_fe = num_fe + num_simplex;
                
                % --------------------- %
                fv_seq_cache = [fv_seq_cache fv];
                % --------------------- %
            end
        end
        
        [fv, sort_idx] = sort(fv);
        fp = fp(sort_idx, :);
        
        % --------------------- %
        opt_fv = fv(1, 1);
        in_seq_end = num_fe;
        in_seq_cache = in_seq_start : in_seq_end;
        in_seq_cache_true = false(1, length(in_seq_cache));
        for cache_ind = 1 : length(in_seq_cache)
            if in_seq_cache(1, cache_ind) <= max_fe
                if rem(in_seq_cache(1, cache_ind), interval_fe) == 0 || in_seq_cache(1, cache_ind) == max_fe
                    in_seq_cache_true(1, cache_ind) = true;
                end
            end
        end
        if sum(in_seq_cache_true) > 0
            if opt_fv_bak < fv_seq_cache(1, 1)
                fv_seq_cache(1, 1) = opt_fv_bak;
            end
            for cache_ind = 1 : (length(fv_seq_cache) - 1)
                if fv_seq_cache(1, cache_ind) < fv_seq_cache(1, cache_ind + 1)
                    fv_seq_cache(cache_ind + 1) = fv_seq_cache(cache_ind);
                end
            end
            fv_seq = [fv_seq fv_seq_cache(1, in_seq_cache_true)];
            in_seq = [in_seq in_seq_cache(1, in_seq_cache_true)];
        end
        % --------------------- %
    end
    
    opt_fp = fp(1, :);
    opt_fv = fv(1);
    
    run_time = toc(run_time_start);
end
