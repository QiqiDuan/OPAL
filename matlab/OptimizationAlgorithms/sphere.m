function [fv, fun_ind] = sphere(fp, fun_ind)
    fv = sum(fp .^ 2, 2)';
end
