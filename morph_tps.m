function [morphed_im] = morph_tps(im_source, ...
                                  a1_x, ...
                                  ax_x, ...
                                  ay_x, ...
                                  w_x, ...
                                  a1_y, ...
                                  ax_y, ...
                                  ay_y, ...
                                  w_y, ...
                                  ctr_pts, ...
                                  sz)
% Morph an image using thin-plate spline parameters
% Author: Brian Wright
%
% im_source: Hs x Ws x 3 matrix representing the unwarped image
% a1_x, ax_x, ay_x, w_x: scalars solved in the x-direction
% a1_y, ax_y, ay_y, w_y: scalars solved in the y-direction
% ctr_ptrs: N x 2 coordinate pairs of points in target image
% sz: 1 x 2 vector containing the target image size
% morphed_im: Ht x Wt x 3 morphed image

% Create a list for every pixel for vector operations
x_point_mat = ndgrid(1:sz(2), 1:sz(1))';
y_point_mat = ndgrid(1:sz(1), 1:sz(2));

x_points = x_point_mat(:);
y_points = y_point_mat(:);

num_ctr_pts = size(ctr_pts, 1);

% Enumerate control point coords and pixel coords
Mx = repmat(ctr_pts(:, 1), 1, length(x_points));
My = repmat(ctr_pts(:, 2), 1, length(y_points));
Px = repmat(x_points, 1, num_ctr_pts)';
Py = repmat(y_points, 1, num_ctr_pts)';

% Anonymous function for use in the TPS equation
U = @(r) -r.^2 .* log(r.^2);
sum_U = U(abs(eps + (Mx - Px) + i*(My - Py)));

% Solve TPS equation for all pixels
F_x = a1_x + (ax_x * x_points) + (ay_x * y_points) + (sum_U' * w_x);
F_y = a1_y + (ax_y * x_points) + (ay_y * y_points) + (sum_U' * w_y);

% Keep warped edge pixel coordinates within range of unwarped image size
F_x(F_x < 1) = 1;
F_y(F_y < 1) = 1;
F_x(F_x > sz(2)) = sz(2);
F_y(F_y > sz(1)) = sz(1);

% Convert unwarped image variable type and preallocate warped image
im_dbl = double(im_source);
morphed_im = zeros(sz, 'double');

% Fill in the warped images using linear interpolation (inverse warping)
for chan = 1:3
  im_warp_pixel_vect = interp2(im_dbl(:, :, chan), F_x, F_y, 'linear');
  morphed_im(:, :, chan) = reshape(im_warp_pixel_vect', sz(1), sz(2));
end
end
