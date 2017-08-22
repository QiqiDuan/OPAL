function PSOGNT_cc = load_PSOGNT_cc_data()
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% Load PSOGNT_cc data on CEC2013-2015 LSGO Benchmark Functions.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
    algo_name = 'PSOGNT_cc';
    opt_results = ['main_' algo_name];
    num_funs = 15;
    PSOGNT_cc = Inf * ones(num_funs, 2);
    for fun_ind = 1 : num_funs
        load(sprintf('../%s/Fun%02d_Dim%02d.mat', opt_results, fun_ind, 1000), 'opt_fv');
        PSOGNT_cc(fun_ind, 1) = mean(opt_fv);
        PSOGNT_cc(fun_ind, 2) = std(opt_fv);
    end
end
