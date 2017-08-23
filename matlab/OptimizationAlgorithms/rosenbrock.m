function [fv, fun_ind] = rosenbrock(fp, fun_ind)
    [~, fun_dim] = size(fp);
    fv = (100 * sum((fp(:, 1 : (fun_dim - 1)) .^ 2 - fp(:, 2 : fun_dim)) .^ 2, 2) + sum((fp(:, 1 : (fun_dim - 1)) - 1) .^ 2, 2))';
end
