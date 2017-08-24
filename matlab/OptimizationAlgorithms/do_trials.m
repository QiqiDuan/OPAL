function do_trials(algo_name, fun_name, fun_dim_list, pop_size_list)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% Do Trials.
%
% -----------------
% || INPUT  || <---
% -----------------
%   algo_name  <--- string, algorithm name
%   fun_name   <--- function name
%   fun_dim_list<-- matrix(1, ?), function dimension list
%   pop_size_list<- matrix(1, ?), population size list
%
% --------
% Example:
% --------
%   >> do_trials('NelderMead', 'sphere', [2 10 100 1000], [2 10 100 1000] + 1);
%   >> do_trials('NelderMead', 'rosenbrock', [2 10 100 1000], [2 10 100 1000] + 1);
%
%   >> do_trials('SWRS', 'sphere', [2 10 100 1000], [1 1 1 1]);
%   >> do_trials('SWRS', 'rosenbrock', [2 10 100 1000], [1 1 1 1]);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
    num_trials = 3;
    opt_fv_sum = Inf * ones(num_trials, length(fun_dim_list));
    num_fe_sum = Inf * ones(num_trials, length(fun_dim_list));
    for i = 1 : length(fun_dim_list)
        for trial_ind = 1 : num_trials
            fun_dim = fun_dim_list(i);
            rsip = 20170824 + fun_dim + trial_ind;
            [opt_fp, opt_fv_sum(trial_ind, i), ~, num_fe_sum(trial_ind, i)] = ...
                feval(str2func(algo_name), str2func(fun_name), 0, fun_dim, -100, 100, pop_size_list(i), 0, 5e4, rsip);
            fprintf('fun_dim = %05d : opt_fp = %09.2e || num_fe = %07d [%+11.2e ... %+11.2e]\n', ...
                fun_dim, opt_fv_sum(trial_ind, i), num_fe_sum(trial_ind, i), opt_fp(1, 1), opt_fp(1, end));
        end
    end
    fprintf('\n');
    for i = 1 : length(fun_dim_list)
        fprintf('fun_dim = %07d : max(opt_fv) = %5.2e median(opt_fv) = %5.2e min(opt_fv) = %5.2e max(num_fe) = %5.2e median(num_fe) = %5.2e min(num_fe) = %5.2e\n', ...
            fun_dim_list(i), max(opt_fv_sum(:, i)), median(opt_fv_sum(:, i)), min(opt_fv_sum(:, i)),max(num_fe_sum(:, i)), median(num_fe_sum(:, i)), min(num_fe_sum(:, i)));
    end
end
