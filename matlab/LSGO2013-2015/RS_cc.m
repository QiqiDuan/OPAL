function [opt_fp, opt_fv, run_time, num_fe, fv_seq, in_seq] = ...
    RS_cc(fhd, fun_ind, fun_dim, slb, sub, pop_size, num_fe, max_fe, rsip, interval_fe)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% RS with Convergence Curve data [i.e. RS_cc].
%
% -----------------
% || INPUT  || <---
% -----------------
%   fhd        <--- str2func, function handler
%   fun_ind    <--- matrix(1, 1), function index
%   fun_dim    <--- matrix(1, 1), function dimension
%   slb        <--- matrix(pop_size, fun_dim), search lower bound
%   sub        <--- matrix(pop_size, fun_dim), search upper bound
%   pop_size   <--- matrix(1, 1), population size
%   num_fe     <--- matrix(1, 1), initial number of function evaluation
%   max_fe     <--- matrix(1, 1), maximum of function evaluation
%   rsip       <--- matrix(1, 1), rand seed for initializing the population
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
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
    % initialize experimental parameters
    run_time_start = tic;
    RandStream.setGlobalStream(RandStream('mt19937ar', 'Seed', 'shuffle'));
    
    % --------------------- %
    in_seq = num_fe + 1;
    in_seq_start = num_fe + 1;
    % --------------------- %

    % initialize algorithmic parameters
    fp = slb + (sub - slb) .* rand(RandStream('mt19937ar', 'Seed', rsip), fun_dim, pop_size)';
    fv = feval(fhd, fp, fun_ind);
    num_fe = num_fe + pop_size;
    
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
    [opt_fv, curr_min_ind] = min(fv);
    opt_fp = fp(curr_min_ind, :);
    % --------------------- %
    
    while num_fe < max_fe
        % --------------------- %
        opt_fv_bak = opt_fv;
        in_seq_start = num_fe + 1;
        % --------------------- %
        
        fp = slb + (sub - slb) .* rand(pop_size, fun_dim);
        fv = feval(fhd, fp, fun_ind);
        num_fe = num_fe + pop_size;
        
        % --------------------- %
        fv_seq_cache = fv;
        % --------------------- %
        
        [curr_min_fv, curr_min_ind] = min(fv);
        if curr_min_fv < opt_fv
            opt_fv = curr_min_fv;
            opt_fp = fp(curr_min_ind, :);
        end
        
        % --------------------- %
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
    
    run_time = toc(run_time_start);
end
