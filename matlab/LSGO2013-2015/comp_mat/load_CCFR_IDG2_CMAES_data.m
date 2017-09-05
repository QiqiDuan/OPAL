function CCFR_IDG2_CMAES = load_CCFR_IDG2_CMAES_data()
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% Load CCFR_IDG2_CMAES data on CEC2013-2015 LSGO Benchmark Functions.
%
% ----------
% Reference:
% ----------
%   1. Yang M, Omidvar MN, Li C, Li X, Cai Z, Kazimipour B, Yao X. 
%       Efficient Resource Allocation in Cooperative Co-evolution for Large-scale Global Optimization.
%       IEEE Transactions on Evolutionary Computation. 2016 Dec 15.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
    % CCFR_IDG2_CMAES [mean + std] + MA-SW-Chains [mean + std] + MOS [mean + std]
    CCFR_IDG2_CMAES = [...
        5.52e-17 5.70e-18 8.49e-13 1.09e-12 1.27e-22 7.41e-23; ...
        4.35e+02 3.55e+01 1.22e+03 1.14e+02 8.32e+02 4.48e+01; ...
        2.04e+01 5.30e-02 2.14e+01 5.62e-02 9.18e-13 5.12e-14; ...
        5.58e+03 2.73e+04 4.58e+09 2.46e+09 1.74e+08 7.87e+07; ...
        2.19e+06 3.11e+05 1.87e+06 3.06e+05 6.94e+06 8.85e+05; ...
        9.99e+05 1.26e+04 1.01e+06 1.53e+04 1.48e+05 6.43e+04; ...
        2.22e-08 4.21e-08 3.45e+06 1.27e+06 1.62e+04 9.10e+03; ...
        4.89e+03 1.23e+03 4.85e+13 1.02e+13 8.00e+12 3.07e+12; ...
        1.59e+08 3.33e+07 1.07e+08 1.68e+07 3.83e+08 6.29e+07; ...
        9.11e+07 1.35e+06 9.18e+07 1.06e+06 9.02e+05 5.07e+05; ...
        4.64e-05 7.47e-05 2.19e+08 2.98e+07 5.22e+07 2.05e+07; ...
        1.01e+03 5.20e+01 1.25e+03 1.05e+02 2.47e+02 2.54e+02; ...
        2.58e+06 3.00e+05 1.98e+07 1.82e+06 3.40e+06 1.06e+06; ...
        3.63e+07 3.21e+06 1.36e+08 2.11e+07 2.56e+07 7.94e+06; ...
        2.80e+06 2.77e+05 5.71e+06 7.57e+05 2.35e+06 1.94e+05];
    
    %% compare
    % CCFR_IDG2_CMAES < MA-SW-Chains : 13
    % CCFR_IDG2_CMAES < MOS : 8
end
