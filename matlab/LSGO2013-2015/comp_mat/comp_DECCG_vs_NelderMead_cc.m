% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% Run Script for comparing DECCG with NelderMead_cc.
%     1. opt_fv [mean + std]
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %

clear all;
close all;
clc;

%% set experimental parameters

base_line = 'DECCG';
comp_line = 'NelderMead_cc';
load([base_line '.mat']);
load([comp_line '.mat']);
mean_base_line = DECCG(:, 1)';
std_base_line = DECCG(:, 2)';
mean_comp_line = NelderMead_cc(:, 1)';
std_comp_line = NelderMead_cc(:, 2)';
[~, num_funs] = size(mean_base_line);
x_axis = 1 : num_funs;

%% compare
% mean
scatter(x_axis, log(mean_base_line), 'm', 'filled');
hold on;
scatter(x_axis, log(mean_comp_line), 'b', 'filled');
legend(strrep(base_line, '_', '\_'), strrep(comp_line, '_', '\_'));
xlabel('function index');
ylabel('optimal function value [log]');
set(gca, 'XTick', x_axis);
hold off;

fprintf(sprintf('Total number of better mean results for %s : %02d\n', ...
    comp_line, sum(mean_comp_line < mean_base_line)));
for fun_ind = 1 : num_funs
    if mean_comp_line(1, fun_ind) < mean_base_line(1, fun_ind)
        fprintf(sprintf('FunInd = %02i : %7.5e < %7.5e\n', ...
            fun_ind, mean_comp_line(1, fun_ind), mean_base_line(1, fun_ind)));
    end
end

% std
fprintf(sprintf('Total number of better std results for %s : %02d\n', ...
    comp_line, sum(std_comp_line < std_base_line)));
for fun_ind = 1 : num_funs
    if std_comp_line(1, fun_ind) < std_base_line(1, fun_ind)
        fprintf(sprintf('FunInd = %02i : %7.5e < %7.5e\n', ...
            fun_ind, std_comp_line(1, fun_ind), std_base_line(1, fun_ind)));
    end
end
