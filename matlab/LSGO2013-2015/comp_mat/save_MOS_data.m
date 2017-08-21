MOS = load_MOS_data();
MOS = MOS(4 : 5, :)'; % 4 : 5 ---> Mean, Std
save('MOS.mat', 'MOS', '-v7.3');
