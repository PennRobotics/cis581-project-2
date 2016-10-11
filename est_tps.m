function [a1, ax, ay, w] = est_tps(ctr_pts, target_value)

f = [v1 v2 . . . vp];  % TODO(brwr)

U = @(r) = -r.^2 .* log10(r.^2);
K = U(abs(target_value - ctr_pts));

P = []  % TODO(brwr)

A = [K, P; P', zeros(3, 3)];
v = [f 0 0 0]';

result = pinv(A + lambda * eye(p + 3, p + 3)) * v;

ax = result(end - 2);
ay = result(end - 1);
a1 = result(end);
result(end-2:) = [];
w = result;

end
