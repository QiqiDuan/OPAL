function [opt_fp, opt_fv, run_time, num_fe, fv_seq, in_seq] = ...
    PSOGNT_cc(fhd, fun_ind, fun_dim, slb, sub, pop_size, num_fe, max_fe, rsip, interval_fe)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% PSOGNT with the Convergence Curve data [i.e. PSOGNT_cc].
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
%   num_fe     ---> matrix(1, 1), final number of function evaluation
%   fv_seq     ---> matrix(1, ?), function value sequence for convergence curve, 
%                   the length of which is set by *max_fe* and *interval_fe*.
%                   the first value corresponds to the first function evaluation,
%                   the last value corresponds to the last function evaluation.
%   in_seq     ---> matrix(1, ?), interval sequence for convergence curve
%
% ----------
% Reference:
% ----------
%   1. Eberhart R, Kennedy J. A new optimizer using particle swarm theory.
%       Micro Machine and Human Science, 
%       Proceedings of the Sixth International Symposium on. IEEE, 1995: 39-43.
%   2. Shi Y, Eberhart R. A modified particle swarm optimizer.
%       Evolutionary Computation Proceedings, 
%       IEEE World Congress on Computational Intelligence. 1998: 69-73.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
    % initialize experimental parameters
    run_time_start = tic;
    RandStream.setGlobalStream(RandStream('mt19937ar', 'Seed', 'shuffle'));

    % --------------------- %
    in_seq = num_fe + 1;
    in_seq_start = num_fe + 1;
    % --------------------- %

    % initialize algorithmic parameters
    w = linspace(0.9, 0.4, ceil((max_fe - num_fe) / pop_size)); % inertia_weights linearly decresing
    c1 = 2.0; % cognition learning parameter
    c2 = 2.0; % social learning parameter
    vlb = 0.01 * slb; % velocity lower bounds
    vub = 0.01 * sub; % velocity upper bounds
    v = vlb + (vub - vlb) .* rand(pop_size, fun_dim); % velocities
    x = slb + (sub - slb) .* rand(RandStream('mt19937ar', 'Seed', rsip), fun_dim, pop_size)'; % positions
    fv = feval(fhd, x, fun_ind);
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
        fv_seq = cat(2, fv_seq, fv_seq_cache(1, in_seq_cache_true));
        in_seq = cat(2, in_seq, in_seq_cache(1, in_seq_cache_true));
    end
    % --------------------- %
    
    % initialize the individually-best positions and function values
    pi = x;
    pi_fv = fv;
    
    % initialize the globally-best positions and function values
    [opt_fv, pg_ind] = min(pi_fv);
    pg = repmat(x(pg_ind, :), pop_size, 1);
    
    w_ind = 1;
    while num_fe < max_fe % synchronously update
        % --------------------- %
        opt_fv_bak = opt_fv;
        in_seq_start = num_fe + 1;
        % --------------------- %
        
        % update the velocities
        v = w(w_ind) .* v ...
           + c1 .* rand(pop_size, fun_dim) .* (pi - x) ...
           + c2 .* rand(pop_size, fun_dim) .* (pg - x);
        w_ind = w_ind + 1;

        % limit the velocity lower and upper bounds
        v = (v < vlb) .* vlb + (v >= vlb) .* v; 
        v = (v > vub) .* vub + (v <= vub) .* v;

        % update the positions
        x = x + v;

        % limit the search lower and upper bounds via re-initialization
        x_rand = slb + (sub - slb) .* rand(pop_size, fun_dim);
        x = (x < slb) .* x_rand + (x >= slb) .* x;
        x = (x > sub) .* x_rand + (x <= sub) .* x;

        % evaluate
        fv = feval(fhd, x, fun_ind);
        num_fe = num_fe + pop_size;

        % --------------------- %
        fv_seq_cache = fv;
        % --------------------- %
        
        % update the individually-best positions and function values
        pi_ind = fv < pi_fv;
        pi(pi_ind, :) = x(pi_ind, :);
        pi_fv(pi_ind) = fv(pi_ind);

        % update the globally-best positions and function values
        [curr_min_fv, curr_min_ind] = min(fv);
        if curr_min_fv < opt_fv
            opt_fv = curr_min_fv;
            pg = repmat(x(curr_min_ind, :), pop_size, 1);
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
            fv_seq = cat(2, fv_seq, fv_seq_cache(1, in_seq_cache_true));
            in_seq = cat(2, in_seq, in_seq_cache(1, in_seq_cache_true));
        end
        % --------------------- %
    end
    
    opt_fp = pg(1, :);
    run_time = toc(run_time_start);
end
