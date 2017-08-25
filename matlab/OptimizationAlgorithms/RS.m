function [opt_fp, opt_fv, run_time, num_fe] = ...
    RS(fhd, fun_ind, fun_dim, slb, sub, pop_size, num_fe, max_fe, rsip)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% Random Search [RS] based on the parallel population, where all
%   individuals are independent each other during iterations.
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
%
% -----------------
% || OUTPUT || --->
% -----------------
%   opt_fp     ---> matrix(1, fun_dim), optimal function position
%   opt_fv     ---> matrix(1, 1), optimal function value
%   run_time   ---> matrix(1, 1), run time
%   num_fe     ---> matrix(1, 1), final number of function evaluation
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
    % initialize experimental parameters
    run_time_start = tic;
    RandStream.setGlobalStream(RandStream('mt19937ar', 'Seed', 'shuffle'));
    
    % initialize algorithmic parameters
    fp = slb + (sub - slb) .* rand(RandStream('mt19937ar', 'Seed', rsip), fun_dim, pop_size)';
    fv = feval(fhd, fp, fun_ind);
    num_fe = num_fe + pop_size;
    opt_fv = min(fv);
    
    while num_fe < max_fe
        fp = slb + (sub - slb) .* rand(pop_size, fun_dim);
        fv = feval(fhd, fp, fun_ind);
        num_fe = num_fe + pop_size;
        
        [curr_min_fv, curr_min_ind] = min(fv);
        if curr_min_fv < opt_fv
            opt_fv = curr_min_fv;
            opt_fp = fp(curr_min_ind, :);
        end
    end
    
    run_time = toc(run_time_start);
end
