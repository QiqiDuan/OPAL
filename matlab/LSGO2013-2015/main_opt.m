% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% Run Script for Checking Optimal Function Positions and Function Values Given
%   on CEC2013-2015 LSGO Benchmark Functions.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %

clear all;
close all;
clc;

%% set experimental parameters

fhd = str2func('benchmark_func');
num_funs = 15;
num_trials = 25;
fun_dim = 1000 * ones(1, num_funs);
fun_dim(1, 13 : 14) = 905;
sb = [100 5 32 100 5 32 100 100 5 32 100 100 100 100 100];

%% optimize
run_time = zeros(num_funs, num_trials);
for fun_ind = 1 : num_funs
    load(sprintf('datafiles/f%02d.mat', fun_ind));
    sub = sb(1, fun_ind);
    slb = -sub;
    for trial_ind = 1 : num_trials
        run_time_start = tic;
        fprintf(sprintf('fun_ind = %02d && trial_ind = %02d : ', fun_ind, trial_ind));
        if fun_ind == 12
            fv = feval(fhd, xopt' + 1, fun_ind); % an exception
        elseif fun_ind == 13 || fun_ind == 14
            fv = feval(fhd, xopt(1 : fun_dim(1, fun_ind), :)', fun_ind);
        else
            fv = feval(fhd, xopt', fun_ind);
        end
        fprintf(sprintf('opt_fv = %7.5e\n', fv));
        if lb ~= slb || ub ~= sub || any(xopt < slb) || any(xopt> sub)
            if fun_ind == 12
            else
                error('ERROR :: the search bound is not correct.');
            end
        end
        run_time(fun_ind, trial_ind) = toc(run_time_start);
    end
end

boxplot(run_time)
