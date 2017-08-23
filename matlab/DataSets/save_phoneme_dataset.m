function phoneme = save_phoneme_dataset()
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% Run Script for Saving the Phoneme Dataset.
%
% ----------
% Reference:
% ----------
%   1. https://www.elen.ucl.ac.be/neural-nets/Research/Projects/ELENA/databases/REAL/phoneme/phoneme.txt
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
    dataset = 'phoneme';
    dataset_filename = [dataset '.dat'];
    dataset_filename_txt = [dataset_filename '.txt'];
    if ~exist(dataset_filename_txt, 'file')
        movefile(dataset_filename, dataset_filename_txt);
    else
        phoneme = load(dataset_filename_txt);
        save([dataset '.mat'], 'phoneme');
    end
end
