function [a1, ax, ay, w] = est_tps(ctr_pts, target_value)
% Estimate Thin-Plate Spline (TPS) Parameters
% Author: Brian Wright
%
% ctr_pts: N x 2 with corresponding points in second image
% target_value: N x 1 representing point position x or y in first image
% a1: TPS parameter (double)
% ax: TPS parameter (double)
% ay: TPS parameter (double)
% w: N x 1 containing TPS parameters

U = @(r) -r.^2 .* log(r.^2);  % Anonymous function: part of the TPS equation

num_ctr_pts = size(ctr_pts, 1);

Mx = repmat(ctr_pts(:, 1), 1, num_ctr_pts);
My = repmat(ctr_pts(:, 2), 1, num_ctr_pts);

K = U(abs(eps + (Mx - Mx') + i*(My - My')));  % Epsilon added to condition matrix
P = [ones(num_ctr_pts, 1), ctr_pts];

% Details in "Approximate Thin Plate Spline Mappings" by G. Donato and S. Belongie
A = [K, P; P', zeros(3)];
v = [target_value; zeros(3, 1)];
lambda = 1e-9;  % Lambda should be sufficiently small; value given during review

result = pinv(A + lambda * eye(num_ctr_pts + 3)) * v;

a1 = result(end-2);
ax = result(end-1);
ay = result(end);
result(end-2:end) = [];
w = result;
end
