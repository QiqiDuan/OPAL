% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% Run Script for comparing RS_cc with NelderMead_cc.
%     1. median run_time,
%     2. median opt_fv [the Wilcoxon rank-sum test],
%     3. median num_fe.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %

clear all;
close all;
clc;

%% set experimental parameters

algo_name = {'RS_cc', 'PSOGNT_cc'};
opt_results = {['main_' algo_name{1}], ['main_' algo_name{2}]};
fig_legends = strrep(algo_name, '_', '\_');
fig_colors = {'m'; 'b'};
num_funs = 15;
x_axis = 1 : num_funs;
fun_ind_start = 1;
fun_ind_end = 15;
num_trials = 25;
max_fe = 3 * (10 ^ 6);
comp_results = mfilename;
if ~exist(comp_results, 'dir')
    mkdir(comp_results);
end

%% plot median run_time
fig_ind = 100;
figure(fig_ind);
run_time_sum = zeros(num_trials, num_funs, length(algo_name));
for algo_ind = 1 : length(algo_name)
    for fun_ind = 1 : num_funs
        load(sprintf('../%s/Fun%02d_Dim%02d.mat', opt_results{algo_ind}, fun_ind, 1000), 'run_time');
        run_time_sum(:, fun_ind, algo_ind) = run_time / 3600; % hour
    end
    fprintf(sprintf('Total run time [hour] for %s : %5.2f\n', algo_name{algo_ind}, sum(sum(run_time_sum(:, :, algo_ind)))));
    scatter(x_axis, median(run_time_sum(:, :, algo_ind), 1), fig_colors{algo_ind}, 'filled');
    hold on;
end
fig_title = sprintf('Median Run Time');
title(fig_title);
legend(fig_legends{1}, fig_legends{2});
xlabel('function index');
ylabel('run time [hour]');
set(gca, 'XTick', x_axis);
saveas(fig_ind, ['./' comp_results '/' fig_title '.fig']);
hold off;

fig_ind = 101;
figure(fig_ind);
fig_title = sprintf('Boxplot for Run Time');
for algo_ind = 1 : length(algo_name)
    subplot(length(algo_name), 1, algo_ind);
    boxplot(run_time_sum(:, :, algo_ind), 'colors', fig_colors{algo_ind});
    if algo_ind == 1
        title(fig_title);
    else
        xlabel('function index');
    end
    ylabel('run time [hour]');
    set(gca, 'XTick', x_axis);
end
saveas(fig_ind, ['./' comp_results '/' fig_title '.fig']);
hold off;

%% median opt_fv [the Wilcoxon rank-sum test]
ind_fig = 200;
figure(ind_fig);
opt_fv_sum = zeros(num_trials, num_funs, length(algo_name));
for algo_ind = 1 : length(algo_name)
    for fun_ind = 1 : num_funs
        load(sprintf('../%s/Fun%02d_Dim%02d.mat', opt_results{algo_ind}, fun_ind, 1000), 'opt_fv');
       opt_fv_sum(:, fun_ind, algo_ind) = opt_fv;
    end
    scatter(x_axis, log(median(opt_fv_sum(:, :, algo_ind), 1)), fig_colors{algo_ind}, 'filled');
    hold on;
end
fig_title = sprintf('Median Optimal Function Value');
title(fig_title);
xlabel('function index');
ylabel('optimal function value [log]');
set(gca, 'XTick', x_axis);
legend(fig_legends{1}, fig_legends{2});
saveas(ind_fig, ['./' comp_results '/' fig_title '.fig']);
hold off;

fig_ind = 201;
figure(fig_ind);
fig_title = sprintf('Boxplot for Optimal Function Value');
for algo_ind = 1 : length(algo_name)
    subplot(length(algo_name), 1, algo_ind);
    boxplot(opt_fv_sum(:, :, algo_ind), 'colors', fig_colors{algo_ind});
    if algo_ind == 1
        title(fig_title);
    else
        xlabel('function index');
    end
    ylabel('function value');
    set(gca, 'XTick', x_axis);
end
saveas(fig_ind, ['./' comp_results '/' fig_title '.fig']);
hold off;

better_ind = median(opt_fv_sum(:, :, 2), 1) < median(opt_fv_sum(:, :, 1), 1);
fprintf(sprintf('Total number of better results for %s : %02d\n', algo_name{2}, sum(better_ind)));

ind_sigf_better = Inf * ones(num_funs, 1);
ind_sigf_equal  = Inf * ones(num_funs, 1);
ind_sgnf_worse  = Inf * ones(num_funs, 1);

for fun_ind = 1 : num_funs
    [~, ind_sigf_equal(fun_ind, 1)] = ranksum(opt_fv_sum(:, fun_ind, 1), opt_fv_sum(:, fun_ind, 2));
    % perform a rightsided test to assess the decrease in median
    [~, ind_sigf_better(fun_ind, 1)] = ranksum(opt_fv_sum(:, fun_ind, 1), opt_fv_sum(:, fun_ind, 2), 'tail', 'right');
    % perform a leftsided test to assess the increase in median
    [~, ind_sgnf_worse(fun_ind, 1)] = ranksum(opt_fv_sum(:, fun_ind, 1), opt_fv_sum(:, fun_ind, 2), 'tail', 'left');
end
fprintf(sprintf('Total number of significantly better for %s : %02d\n', algo_name{2}, sum(ind_sigf_better)));
fprintf(sprintf('Total number of significantly equal  for %s : %02d\n', algo_name{2}, sum(ind_sigf_equal == 0)));
fprintf(sprintf('Total number of significantly worse  for %s : %02d\n', algo_name{2}, sum(ind_sgnf_worse)));

% plot convergence curve
fig_ind = 202;
figure(fig_ind);
for fun_ind = 1 : num_funs
    subplot(3, 5, fun_ind);
    for algo_ind = 1 : length(algo_name)
        load(sprintf('../%s/Fun%02d_Dim%02d.mat', opt_results{algo_ind}, fun_ind, 1000), 'in_seq', 'fv_seq');
        plot(mean(in_seq, 1), log(mean(fv_seq, 1)), fig_colors{algo_ind});
        title(sprintf('F%02d', fun_ind));
        hold on;
    end
end
saveas(fig_ind, ['./' comp_results '/Convergence Curve.fig']);

%% median num_fe
num_fe_sum = zeros(num_trials, num_funs, length(algo_name));
for algo_ind = 1 : length(algo_name)
    for fun_ind = 1 : num_funs
        load(sprintf('../%s/Fun%02d_Dim%02d.mat', opt_results{algo_ind}, fun_ind, 1000), 'num_fe');
        num_fe_sum(:, fun_ind, algo_ind) = num_fe;
        if max(num_fe_sum(:, fun_ind, algo_ind)) > max_fe
            fprintf(sprintf('%s - %i : %i\n', algo_name{algo_ind}, fun_ind, max(num_fe_sum(:, fun_ind, algo_ind)) - max_fe));
        end
    end
end
