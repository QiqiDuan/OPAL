function main_comp(algo_list)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% Main program for comparing different optimization algorithms based on the
%   following three performance metrics:
%       1. median run_time,
%       2. median opt_fv [the Wilcoxon rank-sum test],
%       3. median num_fe.
%
% -----------------
% || INPUT  || <---
% -----------------
%   algo_list  <--- string cell(1, ?), algorithm list
%
% --------
% Example:
% --------
%   >> main_comp({'RS' 'RS_cc'}); % 78.94 vs. 78.52
%   >> main_comp({'NelderMead' 'NelderMead_cc'}); % 115.91 vs. 115.82
%   >> main_comp({'PSOGNT' 'PSOGNT_cc'}); % 95.33 vs. 84.83
%   >> main_comp({'SWRS' 'SWRS_cc'}); % 385.80 vs. 473.79
%   >> main_comp({'RS', 'NelderMead', 'PSOGNT', 'SWRS'});
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
    warning('off','all');
    
    opt_results = cell(1, length(algo_list));
    for algo_ind = 1 : length(algo_list)
        opt_results(1, algo_ind) = {['main_' algo_list{1, algo_ind}]};
    end
    
    fig_legends = strrep(algo_list, '_', '\_');
    num_funs = 15;
    x_axis = 1 : num_funs;
    num_trials = 25;
    max_fe = 3 * (10 ^ 6);
    
    comp_results = [mfilename '_' datestr(now,'yyyy-mm-dd_HH-MM-SS')];
    if ~exist(comp_results, 'dir')
        mkdir(comp_results);
    end
    
    %% plot median run_time
    fig_ind = 100;
    figure(fig_ind);
    fig_title = sprintf('Total Run Time');
    run_time_sum = zeros(num_trials, num_funs, length(algo_list));
    for algo_ind = 1 : length(algo_list)
        for fun_ind = 1 : num_funs
            load(sprintf('../%s/Fun%02d_Dim%02d.mat', opt_results{1, algo_ind}, fun_ind, 1000), 'run_time');
            run_time_sum(:, fun_ind, algo_ind) = run_time / 3600; % hour
        end
        fprintf(sprintf('Total run time [hour] for %s : %5.2f\n', algo_list{1, algo_ind}, sum(sum(run_time_sum(:, :, algo_ind)))));
        scatter(x_axis, sum(run_time_sum(:, :, algo_ind), 1), 'filled');
        hold on;
    end
    title(fig_title);
    legend(fig_legends);
    xlabel('Function Index');
    ylabel('Run Time [Hour]');
    set(gca, 'XTick', x_axis);
    saveas(fig_ind, ['./' comp_results '/' fig_title '.fig']);
    hold off;
    
    fig_ind = 101;
    figure(fig_ind);
    fig_title = sprintf('Boxplot for Run Time');
    for algo_ind = 1 : length(algo_list)
        subplot(length(algo_list), 1, algo_ind);
        boxplot(run_time_sum(:, :, algo_ind));
        title(strrep(algo_list{1, algo_ind}, '_', '\_'));
        if algo_ind == length(algo_list)
            xlabel('Function Index');
        end
        ylabel('Run Time [Hour]');
        ylim([0, max(run_time_sum(:)) * 1.2]);
        set(gca, 'XTick', x_axis);
    end
    saveas(fig_ind, ['./' comp_results '/' fig_title '.fig']);
    hold off;
    
    %% plot median opt_fv [the Wilcoxon rank-sum test]
    ind_fig = 200;
    figure(ind_fig);
    fig_title = sprintf('Median Final Function Value');
    opt_fv_sum = zeros(num_trials, num_funs, length(algo_list));
    for algo_ind = 1 : length(algo_list)
        for fun_ind = 1 : num_funs
            load(sprintf('../%s/Fun%02d_Dim%02d.mat', opt_results{1, algo_ind}, fun_ind, 1000), 'opt_fv');
            opt_fv_sum(:, fun_ind, algo_ind) = opt_fv;
        end
        scatter(x_axis, median(opt_fv_sum(:, :, algo_ind), 1), 'filled');
        hold on;
    end
    title(fig_title);
    xlabel('Function Index');
    ylabel('Final Function Value');
    set(gca, 'XTick', x_axis);
    set(gca, 'YScale', 'log');
    legend(fig_legends);
    saveas(ind_fig, ['./' comp_results '/' fig_title '.fig']);
    hold off;
    
    fig_ind = 201;
    figure(fig_ind);
    fig_title = sprintf('Boxplot for Final Function Value');
    for algo_ind = 1 : length(algo_list)
        subplot(length(algo_list), 1, algo_ind);
        boxplot(opt_fv_sum(:, :, algo_ind));
        title(strrep(algo_list{1, algo_ind}, '_', '\_'));
        if algo_ind == length(algo_list)
            xlabel('Function Index');
        end
        ylabel('Final Function Value');
        set(gca, 'XTick', x_axis);
        set(gca, 'YScale', 'log');
    end
    saveas(fig_ind, ['./' comp_results '/' fig_title '.fig']);
    hold off;

    for base_ind = 2 : length(algo_list)
        fprintf(newline);
        for comp_ind = 1 : (base_ind - 1)
            fprintf(sprintf('%s vs. %s\n', algo_list{1, base_ind}, algo_list{1, comp_ind}));
            ind_sigf_better = Inf * ones(num_funs, 1);
            ind_sigf_equal  = Inf * ones(num_funs, 1);
            ind_sgnf_worse  = Inf * ones(num_funs, 1);
            for fun_ind = 1 : num_funs
                [~, ind_sigf_equal(fun_ind, 1)] = ranksum(opt_fv_sum(:, fun_ind, comp_ind), opt_fv_sum(:, fun_ind, base_ind));
                % perform a rightsided test to assess the decrease in median
                [~, ind_sigf_better(fun_ind, 1)] = ranksum(opt_fv_sum(:, fun_ind, comp_ind), opt_fv_sum(:, fun_ind, base_ind), 'tail', 'right');
                % perform a leftsided test to assess the increase in median
                [~, ind_sgnf_worse(fun_ind, 1)] = ranksum(opt_fv_sum(:, fun_ind, comp_ind), opt_fv_sum(:, fun_ind, base_ind), 'tail', 'left');
            end
            fprintf(sprintf('Total number of significantly better for %s : %02d\n', algo_list{1, base_ind}, sum(ind_sigf_better)));
            fprintf(sprintf('Total number of significantly equal  for %s : %02d\n', algo_list{1, base_ind}, sum(ind_sigf_equal == 0)));
            fprintf(sprintf('Total number of significantly worse  for %s : %02d\n', algo_list{1, base_ind}, sum(ind_sgnf_worse)));
        end
    end
    
    %% median num_fe
    fprintf(newline);
    num_fe_sum = zeros(num_trials, num_funs, length(algo_list));
    for algo_ind = 1 : length(algo_list)
        for fun_ind = 1 : num_funs
           load(sprintf('../%s/Fun%02d_Dim%02d.mat', opt_results{1, algo_ind}, fun_ind, 1000), 'num_fe');
           num_fe_sum(:, fun_ind, algo_ind) = num_fe;
           if max(num_fe_sum(:, fun_ind, algo_ind)) > max_fe
               fprintf(sprintf('algo_name [%s] - fun_ind [%i] : %i\n', algo_list{1, algo_ind}, fun_ind, max(num_fe_sum(:, fun_ind, algo_ind)) - max_fe));
           end
        end
    end
end
