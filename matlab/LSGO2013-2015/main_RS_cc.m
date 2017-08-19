% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% Run Script for *RS_cc.m* on CEC2013-2015 LSGO Benchmark Functions.
%
% ----------
% Reference:
% ----------
%   1. https://titan.csit.rmit.edu.au/~e46507/ieee-lsgo/
%   2. http://staff.ustc.edu.cn/~ketang/lsgo2015.html
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %

clear all;
close all;
clc;

%% set experimental parameters

% set a random seed for initializing the population and getting a starting 
%   point repeatable when plotting the convergence curve. It is suggested 
%   to set it in the form of date (i.e. YYYYMMDD)
rand_seed_for_init_pop = 20170807; % 2017-08-07 ---> YYYY-MM-DD

% set a folder for saving all data generated
opt_results = mfilename; % named after the script name
if ~exist(opt_results, 'dir')
    mkdir(opt_results);
end

fhd = str2func('benchmark_func');
num_funs = 15;
fun_ind_start = 1;
fun_ind_end = 15;
num_trials = 25;
max_fe = 3 * (10 ^ 6);
pop_size = 200;
fun_dim = 1000 * ones(1, num_funs);
fun_dim(1, 13 : 14) = 905;
sb = [100 5 32 100 5 32 100 100 5 32 100 100 100 100 100];
interval_fe = 1000; % interval of function evaluation for convergence curve

%% optimize
for fun_ind = fun_ind_start : fun_ind_end
    opt_fp = Inf * ones(num_trials, fun_dim(1, fun_ind));
    opt_fv = Inf * ones(num_trials, 1);
    run_time = Inf * ones(num_trials, 1);
    num_fe = Inf * ones(num_trials, 1);
    
    % --------------------- %
    if rem(max_fe, interval_fe) == 0
        fv_seq_length = floor(max_fe / interval_fe) + 1;
    else
        fv_seq_length = floor(max_fe / interval_fe) + 2;
    end
    fv_seq = Inf * ones(num_trials, fv_seq_length);
    in_seq = Inf * ones(num_trials, fv_seq_length);
    % --------------------- %
    
    for trial_ind = 1 : num_trials
        fprintf(sprintf('fun_ind = %02d && trial_ind = %02d ', fun_ind, trial_ind));
        
        % generate different random seeds for different trials of different
        %   functions, but with repeatable starting points
        rsip = rand_seed_for_init_pop + 1e2 * fun_ind + trial_ind;
        sub = sb(1, fun_ind) * ones(pop_size, fun_dim(1, fun_ind));
        slb = -1 * sub;
        [opt_fp(trial_ind, :), opt_fv(trial_ind, 1), run_time(trial_ind, 1), num_fe(trial_ind, 1), fv_seq(trial_ind, :), in_seq(trial_ind, :)] = ...
            RS_cc(fhd, fun_ind, fun_dim(1, fun_ind), slb, sub, pop_size, 0, max_fe, rsip, interval_fe);
        fprintf(sprintf('run_time = %7.2f opt_fv = %7.5e\n', run_time(trial_ind, 1), opt_fv(trial_ind, 1)));
    end
    
    fprintf('\n');
    
    % save all important data generated in the form of *.mat
    save(sprintf('./%s/Fun%02d_Dim%02d.mat', opt_results, fun_ind, 1000), ...
        'opt_fp', 'opt_fv', 'run_time', 'num_fe', 'fv_seq', 'in_seq', '-v7.3');
end
