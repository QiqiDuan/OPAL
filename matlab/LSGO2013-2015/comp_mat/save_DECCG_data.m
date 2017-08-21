DECCG = load_DECCG_data();
DECCG = DECCG(4 : 5, :)'; % 4 : 5 ---> Mean, Std
save('DECCG.mat', 'DECCG', '-v7.3');
