function [opt_fp, opt_fv, run_time, num_fe] = ...
    SWRS(fhd, fun_ind, fun_dim, slb, sub, pop_size, num_fe, max_fe, rsip)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% Solis-Wets Random Seach [SWRS].
%
% -----------------
% || INPUT  || <---
% -----------------
%   fhd        <--- str2func, function handler
%   fun_ind    <--- matrix(1, 1), function index
%   fun_dim    <--- matrix(1, 1), function dimension
%   slb        <--- matrix(pop_size, fun_dim), search lower bound
%   sub        <--- matrix(pop_size, fun_dim), search upper bound
%   pop_size   <--- matrix(1, 1), population size
%   num_fe     <--- matrix(1, 1), initial number of function evaluation
%   max_fe     <--- matrix(1, 1), maximum of function evaluation
%   rsip       <--- matrix(1, 1), rand seed for initializing the population
%
% -----------------
% || OUTPUT || --->
% -----------------
%   opt_fp     ---> matrix(1, fun_dim), optimal function position
%   opt_fv     ---> matrix(1, 1), optimal function value
%   run_time   ---> matrix(1, 1), run time
%   num_fe     ---> matrix(1, 1), final number of function evaluation
%
% ----------
% Reference:
% ----------
%   1. Solis FJ, Wets RJ. Minimization by random search techniques. 
%       Mathematics of operations research. 1981 Feb;6(1):19-30.
%   2. Alikhani MG, Javadian N, Tavakkoli-Moghaddam R.
%       A novel hybrid approach combining electromagnetism-like method with 
%       Solis and Wets local search for continuous optimization problems.
%       Journal of Global Optimization. 2009 Jun 1;44(2):227.
%   3. LaTorre A, Muelas S, Pena JM. Large scale global optimization: 
%       Experimental results with mos-based hybrid algorithms. In 2013 
%       IEEE Congress on Evolutionary Computation (CEC). IEEE.
%   4. The MATLAB code origined from Yijun Yang [OPAL-CS-SUSTC, 2017] and was
%       modified further by Qiqi Duan [OPAL-CS-SUSTC, 2017] according to Ref.2. 
%       However, algorithm parameters are set according to Ref.3.
% *********************************************************************** %
    % initialize experimental parameters
    run_time_start = tic;
    RandStream.setGlobalStream(RandStream('mt19937ar', 'Seed', 'shuffle'));

    % initialize algorithmic parameters
    norm_mean = zeros(1, fun_dim); % p
    norm_std = 2.4; % p, delta
    max_fail = 5; % MAXF, maxFailed
    max_success = 5; % MAXS, MaxSuccess
    fail_num = 0;
    success_num = 0;
    success_std_factor = 4; % expf, adjustSueeess
    fail_std_factor = 0.75; % conf, adjustFailed
    
    opt_fp = slb + (sub - slb) .* rand(RandStream('mt19937ar', 'Seed', rsip), fun_dim, pop_size)';
    opt_fv = feval(fhd, opt_fp, fun_ind);
    num_fe = num_fe + pop_size;
    
    while num_fe < max_fe
        norm_vect = normrnd(norm_mean, norm_std); % D
        fp_new = opt_fp + norm_vect;
        fv_new = feval(fhd, fp_new, fun_ind);
        num_fe = num_fe + pop_size;
        
        if fv_new < opt_fv
            opt_fp = fp_new;
            opt_fv = fv_new;
            fail_num = 0;
            success_num = success_num + 1;
            norm_mean = 0.4 * norm_vect + 0.2 * norm_mean;
        else
            fp_new = opt_fp - norm_vect;
            fv_new = feval(fhd, fp_new, fun_ind);
            num_fe = num_fe + pop_size;
            if fv_new < opt_fv
                opt_fp = fp_new;
                opt_fv = fv_new;
                fail_num = 0;
                success_num = success_num + 1;
                norm_mean = norm_mean - 0.4 * norm_vect;
            else
                fail_num = fail_num + 1;
                success_num = 0;
                norm_mean = 0.5 * norm_mean;
            end
        end
        
        if success_num >= max_success
            fail_num = 0;
            success_num = 0;
            norm_std = success_std_factor * norm_std;
        end
        
        if fail_num >= max_fail
            fail_num = 0;
            success_num = 0;
            norm_std = fail_std_factor * norm_std;
        end

        run_time = toc(run_time_start);
    end
end
