function mean_std = load_meanstd_data(algo_name)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% Load *mean+std* data on CEC2013-2015 LSGO Benchmark Functions.
%
% -----------------
% || INPUT  || <---
% -----------------
%   algo_name  <--- string, algorithm name
%
% --------
% Example:
% --------
%   >> load_meanstd_data('RS_cc');
%   >> load_meanstd_data('NelderMead_cc');
%   >> load_meanstd_data('PSOGNT_cc');
%   >> load_meanstd_data('SWRS_cc');
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
    %%
    opt_results = ['main_' algo_name];
    num_funs = 15;
    mean_std = Inf * ones(num_funs, 2);
    for fun_ind = 1 : num_funs
        load(sprintf('../%s/Fun%02d_Dim%02d.mat', opt_results, fun_ind, 1000), 'opt_fv');
        mean_std(fun_ind, 1) = mean(opt_fv);
        mean_std(fun_ind, 2) = std(opt_fv);
    end
    
    %%
    save([algo_name '.mat'], 'mean_std', '-v7.3');
end
