function mean_std = load_MOS_data()
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% Load MOS data on CEC2013-2015 LSGO Benchmark Functions.
%
% ----------
% Reference:
% ----------
%   1. LaTorre A, Muelas S, Pena J M. Large scale global optimization: Experimental results with mos-based hybrid algorithm.
%       Evolutionary Computation (CEC), 2013 IEEE Congress on. IEEE, 2013: 2742-2749.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %

    %% Best, Median, Worst, Mean, Std
    MOS = [0.00e+00 7.40e+02 8.20e-13 1.10e+08 5.25e+06 1.95e+01 3.49e+03 3.26e+12 2.63e+08 5.92e+02 2.06e+07 2.22e-01 1.52e+06 1.54e+07 2.03e+06
           0.00e+00 8.36e+02 9.10e-13 1.56e+08 6.79e+06 1.39e+05 1.62e+04 8.08e+12 3.87e+08 1.18e+06 4.48e+07 2.46e+02 3.30e+06 2.42e+07 2.38e+06
           0.00e+00 9.28e+02 1.00e-12 5.22e+08 8.56e+06 2.31e+05 3.73e+04 1.32e+13 5.42e+08 1.23e+06 9.50e+07 1.17e+03 6.16e+06 4.46e+07 2.88e+06
           0.00e+00 8.32e+02 9.17e-13 1.74e+08 6.94e+06 1.48e+05 1.62e+04 8.00e+12 3.83e+08 9.02e+05 5.22e+07 2.47e+02 3.40e+06 2.56e+07 2.35e+06
           0.00e+00 4.48e+01 5.12e-14 7.87e+07 8.85e+05 6.43e+04 9.10e+03 3.07e+12 6.29e+07 5.07e+05 2.05e+07 2.54e+02 1.06e+06 7.94e+06 1.94e+05];
    
    %%
    mean_std = MOS(4 : 5, :)'; % 4 : 5 ---> Mean, Std
    save('MOS.mat', 'mean_std', '-v7.3');
end
