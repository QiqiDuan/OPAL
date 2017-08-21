% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% Run *SWRS.m* for the minimization of *rosenbrock*.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %

clear all;
close all;
clc;

%%
fun_dim_list = [2, 10 .^ (1 : 3)];
fhd = str2func('rosenbrock');
fun_ind = 0;
max_fe = 1e6;
num_trials = 5;
slb = -10;
sub = 10;
pop_size = 1;
opt_fv_sum = Inf * ones(num_trials, length(fun_dim_list));
num_fe_sum = Inf * ones(num_trials, length(fun_dim_list));
for i = 1 : length(fun_dim_list)
    for trial_ind = 1 : num_trials
        num_fe = 0;
        fun_dim = fun_dim_list(i);
        rsip = 20170821 + fun_dim + trial_ind;
        [opt_fp, opt_fv_sum(trial_ind, i), ~, num_fe_sum(trial_ind, i)] = ...
            SWRS(fhd, fun_ind, fun_dim, slb, sub, pop_size, num_fe, max_fe, rsip);
        fprintf('fun_dim = %05d : opt_fp = %09.2e || num_fe = %07d [%+11.2e ... %+11.2e]\n', ...
            fun_dim, opt_fv_sum(trial_ind, i), num_fe_sum(trial_ind, i), opt_fp(1, 1), opt_fp(1, end));
    end
end

fprintf('\n\n\n');

for i = 1 : length(fun_dim_list)
    fprintf('fun_dim = %07d :: max(opt_fv) = %5.2e median(opt_fv) = %5.2e min(opt_fv) = %5.2e max(num_fe) = %5.2e median(num_fe) = %5.2e min(num_fe) = %5.2e\n', ...
        fun_dim_list(i), max(opt_fv_sum(:, i)), median(opt_fv_sum(:, i)), min(opt_fv_sum(:, i)),max(num_fe_sum(:, i)), median(num_fe_sum(:, i)), min(num_fe_sum(:, i)));
end