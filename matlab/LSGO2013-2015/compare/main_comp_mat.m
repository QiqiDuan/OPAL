function mean_sum = main_comp_mat(algo_list)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% Main program for comparing different optimization algorithms based on the
%   following two performance metrics:
%       1. mean,
%       2. std.
%
% -----------------
% || INPUT  || <---
% -----------------
%   algo_list  <--- string cell(1, ?), algorithm list
%
% --------
% Example:
% --------
%   >> mean_sum = main_comp_mat({'RS_cc', 'DECCG'});
%   >> mean_sum = main_comp_mat({'DECCG', 'SWRS_cc'});
%   >> mean_sum = main_comp_mat({'DECCG', 'MOS'});
%   >> mean_sum = main_comp_mat({'MOS', 'CCFR_IDG2', 'CCFR_IDG2_CMAES'});
%   >> mean_sum = main_comp_mat({'RS_cc', 'NelderMead_cc', 'PSOGNT_cc', 'SWRS_cc', 'DECCG', 'MOS', 'CCFR_IDG2', 'CCFR_IDG2_CMAES', 'DSPLSO'});
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
    %%
    num_funs = 15;
    mean_sum = Inf * ones(num_funs, length(algo_list));
    std_sum = Inf * ones(num_funs, length(algo_list));
    for algo_ind = 1 : length(algo_list)
        mean_std = Inf;
        load([algo_list{1, algo_ind} '.mat']);
        mean_sum(:, algo_ind) = mean_std(:, 1);
        std_sum(:, algo_ind) = mean_std(:, 2);
    end
    
    %% mean
    figure(100);
    mean_rank_sum = Inf * ones(num_funs, length(algo_list));
    for fun_ind = 1 : num_funs
        [~, sort_ind] = sort(mean_sum(fun_ind, :));
        mean_rank_sum(fun_ind, sort_ind) = 1 : length(algo_list);
    end
    
    algo_list_mean = algo_list;
    mean_rank_top = sum(mean_rank_sum, 1);
    for algo_ind = 1 : length(algo_list_mean)
        algo_list_mean{1, algo_ind} = [algo_list_mean{1, algo_ind} ' [' num2str(mean_rank_top(1, algo_ind)) ']'];
    end
    
    [~, mean_rank_top] = sort(mean_rank_top, 'descend');
    algo_list_mean = algo_list_mean(1, mean_rank_top);
    mean_rank_sum = mean_rank_sum(:, mean_rank_top);
    
    hm = heatmap(algo_list_mean, 1 : 15, mean_rank_sum, 'Colormap', cool, 'FontSize', 12);
    hm.Title = 'Heatmap for Mean-based Ranking';
    hm.XLabel = 'Optimization Algorithms';
    hm.YLabel = 'Function Index';
    
    %% std
    figure(200);
    std_rank_sum = Inf * ones(num_funs, length(algo_list));
    for fun_ind = 1 : num_funs
        [~, sort_ind] = sort(mean_sum(fun_ind, :));
        std_rank_sum(fun_ind, sort_ind) = 1 : length(algo_list);
    end
    
    algo_list_std = algo_list;
    std_rank_top = sum(std_rank_sum, 1);
    for algo_ind = 1 : length(algo_list_std)
        algo_list_std{1, algo_ind} = [algo_list_std{1, algo_ind} ' [' num2str(std_rank_top(1, algo_ind)) ']'];
    end
    
    [~, std_rank_top] = sort(std_rank_top, 'descend');
    algo_list_std = algo_list_std(1, std_rank_top);
    std_rank_sum = std_rank_sum(:, std_rank_top);
    
    hm = heatmap(algo_list_std, 1 : 15, std_rank_sum, 'Colormap', cool, 'FontSize', 12);
    hm.Title = 'Heatmap for Std-based Ranking';
    hm.XLabel = 'Optimization Algorithms';
    hm.YLabel = 'Function Index';
end
