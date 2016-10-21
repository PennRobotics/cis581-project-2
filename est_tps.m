function [a1, ax, ay, w] = est_tps(ctr_pts, target_value)
% ctr_pts: N x 2 with corresponding points in second image
% target_value: N x 1 representing point position x or y in first image
% a1: TPS parameter (double)
% ax: TPS parameter (double)
% ay: TPS parameter (double)
% w: N x 1 containing TPS parameters

disp(size(ctr_pts))
disp(size(repmat(target_value, 1, 2)))

% U = @(r) -r.^2 .* log10(r.^2);
% reps = 2;  % TODO(brwr)
% K = U(abs(repmat(target_value, 1, 2) - ctr_pts));
% 
% disp(size(K))
% 
% P = [0 0 0;0 0 0;0 0 0;0 0 0];  % TODO(brwr)
% 
% A = [K, P; P', zeros(3, 1)];
% f = [1 1 1 1];  % TODO(brwr)
% 
% lambda = 1e-6;  % should be sufficiently small; value given during review
% p = 3;  % TODO(brwr)
% result = pinv(A + lambda * eye(p + 3)) * target_value;
% 
% ax = result(end-2);
% ay = result(end-1);
% a1 = result(end);
% result(end-2:end) = [];
% w = result;

a1 = 1;
ax = 2;
ay = 3;
w = target_value;
end
