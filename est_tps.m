function [a1, ax, ay, w] = est_tps(ctr_pts, target_value)

% f = [v1 v2 . . . vp];  % TODO(brwr)

%disp(size(ctr_pts))
%disp(size(repmat(target_value, 1, 2)))

U = @(r) -r.^2 .* log10(r.^2);
reps = 2;  % TODO(brwr)
K = U(abs(repmat(target_value, 1, 2) - ctr_pts));

disp(size(K))

P = [0 0 0;0 0 0;0 0 0;0 0 0];  % TODO(brwr)

A = [K, P; P', zeros(3, 1)];
f = [1 1 1 1];  % TODO(brwr)
v = [f 0 0 0]';  % TODO(brwr)

lambda = 1e-6;  % should be sufficiently small; value given during review
p = 3;  % TODO(brwr)
result = pinv(A + lambda * eye(p + 3, p + 3)) * v;

ax = result(end-2);
ay = result(end-1);
a1 = result(end);
result(end-2:end) = [];
w = result;

end
