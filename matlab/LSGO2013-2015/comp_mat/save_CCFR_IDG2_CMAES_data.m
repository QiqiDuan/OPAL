CCFR_IDG2_CMAES = load_CCFR_IDG2_CMAES_data();
CCFR_IDG2_CMAES = CCFR_IDG2_CMAES(:, 1 : 2); % 1 : 2 ---> Mean, Std
save('CCFR_IDG2_CMAES.mat', 'CCFR_IDG2_CMAES', '-v7.3');
