function CCFR_IDG2 = load_CCFR_IDG2_data()
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% Load CCFR_IDG2 data on CEC2013-2015 LSGO Benchmark Functions.
%
% ----------
% Reference:
% ----------
%   1. Yang M, Omidvar MN, Li C, Li X, Cai Z, Kazimipour B, Yao X. 
%       Efficient Resource Allocation in Cooperative Co-evolution for Large-scale Global Optimization.
%       IEEE Transactions on Evolutionary Computation. 2016 Dec 15.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %                     
    % CCFR-IDG2 [mean + std] + MA-SW-Chains [mean + std] + MOS [mean + std]
    CCFR_IDG2 = [1.77e-05 4.52e-06 8.49e-13 1.09e-12 1.27e-22 7.41e-23; ...
                 3.64e+02 2.06e+01 1.22e+03 1.14e+02 8.32e+02 4.48e+01; ...
                 2.07e+01 1.21e-02 2.14e+01 5.62e-02 9.18e-13 5.12e-14; ...
                 9.56e+07 4.03e+07 4.58e+09 2.46e+09 1.74e+08 7.87e+07; ...
                 2.80e+06 3.18e+05 1.87e+06 3.06e+05 6.94e+06 8.85e+05; ...
                 1.06e+06 1.05e+03 1.01e+06 1.53e+04 1.48e+05 6.43e+04; ...
                 2.03e+07 2.94e+07 3.45e+06 1.27e+06 1.62e+04 9.10e+03; ...
                 6.63e+10 9.52e+10 4.85e+13 1.02e+13 8.00e+12 3.07e+12; ...
                 1.89e+08 2.83e+07 1.07e+08 1.68e+07 3.83e+08 6.29e+07; ...
                 9.48e+07 1.82e+05 9.18e+07 1.06e+06 9.02e+05 5.07e+05; ...
                 4.17e+08 3.43e+08 2.19e+08 2.98e+07 5.22e+07 2.05e+07; ...
                 1.56e+09 1.58e+09 1.25e+03 1.05e+02 2.47e+02 2.54e+02; ...
                 1.21e+09 6.00e+08 1.98e+07 1.82e+06 3.40e+06 1.06e+06; ...
                 3.39e+09 3.06e+09 1.36e+08 2.11e+07 2.56e+07 7.94e+06; ...
                 9.82e+06 3.69e+06 5.71e+06 7.57e+05 2.35e+06 1.94e+05];
    
    %% compare
    % CCFR_IDG2 < MA-SW-Chains : 4
    % CCFR_IDG2 < MOS : 5
end
