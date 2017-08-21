% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% Run Script for *PSOGNT.m* on CEC2013-2015 LSGO Benchmark Functions.
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

rand_seed_for_init_pop = 20170807;
opt_results = mfilename;
if ~exist(opt_results, 'dir')
    mkdir(opt_results);
end
fhd = str2func('benchmark_func');
num_funs = 15;
fun_ind_start = 1;
fun_ind_end = 15;
num_trials = 25;
max_fe = 3 * (10 ^ 6);
pop_size = 100;
fun_dim = 1000 * ones(1, num_funs);
fun_dim(1, 13 : 14) = 905;
sb = [100 5 32 100 5 32 100 100 5 32 100 100 100 100 100];

%% optimize
for fun_ind = fun_ind_start : fun_ind_end
    opt_fp = Inf * ones(num_trials, fun_dim(1, fun_ind));
    opt_fv = Inf * ones(num_trials, 1);
    run_time = Inf * ones(num_trials, 1);
    num_fe = Inf * ones(num_trials, 1);

    for trial_ind = 1 : num_trials
        fprintf(sprintf('fun_ind = %02d && trial_ind = %02d ', fun_ind, trial_ind));
        rsip = rand_seed_for_init_pop + 1e2 * fun_ind + trial_ind;
        sub = sb(1, fun_ind) * ones(pop_size, fun_dim(1, fun_ind));
        slb = -1 * sub;
        [opt_fp(trial_ind, :), opt_fv(trial_ind, 1), run_time(trial_ind, 1), num_fe(trial_ind, 1)] = ...
            PSOGNT(fhd, fun_ind, fun_dim(1, fun_ind), slb, sub, pop_size, 0, max_fe, rsip);
        fprintf(sprintf('run_time = %7.2f opt_fv = %7.5e num_fe = %09d\n', ...
            run_time(trial_ind, 1), opt_fv(trial_ind, 1), num_fe(trial_ind, :)));
    end
    
    fprintf('\n');
    
    save(sprintf('./%s/Fun%02d_Dim%02d.mat', opt_results, fun_ind, 1000), ...
        'opt_fp', 'opt_fv', 'run_time', 'num_fe', '-v7.3');
end
