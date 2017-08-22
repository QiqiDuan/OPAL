CCFR_IDG2 = load_CCFR_IDG2_data();
CCFR_IDG2 = CCFR_IDG2(:, 1: 2); % 1 : 2 ---> Mean, Std
save('CCFR_IDG2.mat', 'CCFR_IDG2', '-v7.3');
