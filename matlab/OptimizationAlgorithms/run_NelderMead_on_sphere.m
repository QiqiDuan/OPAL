% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% Run *NelderMead.m* for the minimization of *sphere*.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %

clear all;
close all;
clc;

%%
fun_dim_list = [2, 10 .^ (1 : 3)];
fhd = str2func('sphere');
fun_ind = 0;
max_fe = 1e5;
num_trials = 3;
slb = -100;
sub = 100;
opt_fv_sum = Inf * ones(num_trials, length(fun_dim_list));
num_fe_sum = Inf * ones(num_trials, length(fun_dim_list));
for i = 1 : length(fun_dim_list)
    for trial_ind = 1 : num_trials
        fun_dim = fun_dim_list(i);
        ini_seed = 20170821 + fun_dim + trial_ind;
        fp = slb + rand(RandStream('mt19937ar', 'Seed', ini_seed), fun_dim, fun_dim + 1)' * (sub - slb);
        [opt_fp, opt_fv_sum(trial_ind, i), ~, num_fe_sum(trial_ind, i)] = NelderMead(fhd, fun_ind, fp, 0, max_fe);
        fprintf('fun_dim = %05d :: opt_fp = %09.2e || num_fe = %07d [%+11.2e ... %+11.2e]\n', ...
            fun_dim, opt_fv_sum(trial_ind, i), num_fe_sum(trial_ind, i), opt_fp(1, 1), opt_fp(1, end));
    end
end

fprintf('\n\n\n');

for i = 1 : length(fun_dim_list)
    fprintf('fun_dim = %07d : max(opt_fv) = %5.2e median(opt_fv) = %5.2e min(opt_fv) = %5.2e max(num_fe) = %5.2e median(num_fe) = %5.2e min(num_fe) = %5.2e\n', ...
        fun_dim_list(i), max(opt_fv_sum(:, i)), median(opt_fv_sum(:, i)), min(opt_fv_sum(:, i)),max(num_fe_sum(:, i)), median(num_fe_sum(:, i)), min(num_fe_sum(:, i)));
end
