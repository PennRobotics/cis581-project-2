function [morphed_im] = morph_tps_wrapper(im1, ...
                                          im2, ...
                                          im1_pts, ...
                                          im2_pts, ...
                                          warp_frac, ...
                                          dissolve_frac)
% Thin-plate spline wrapper which calls estimation and morph routines
% Author: Brian Wright
%
% im1: H1 x W1 x 3 representing first image
% im2: H2 x W2 x 3 representing second image
% im1_pts: N x 2 matrix with first image correspondences
% im2_pts: N x 2 matrix with second image correspondences
% warp_frac: 1 x M vector containing shape warping parameter [0, 1]
% dissolve_frac: 1 x M vector containing color blending parameter [0, 1]
% morphed_im: M cells, each containing a thin-plate spline morphed image frame

% Check input conditions
assert(size(warp_frac, 1) == size(dissolve_frac, 1), 'Warp and dissolve vectors have different sizes')
assert(size(warp_frac, 2) == size(dissolve_frac, 2), 'Warp and dissolve vectors have different sizes')
assert(size(im1_pts, 1) == size(im2_pts, 1), 'Number of correspondences is not the same for each image')
assert(size(im1_pts, 2) == size(im2_pts, 2), 'Number of correspondences is not the same for each image')
assert(size(im1, 3) == 3, 'Color channels missing from source image')
assert(size(im2, 3) == 3, 'Color channels missing from target image')

morphed_im = cell(1, length(dissolve_frac));  % Preallocate and set data type of output variable

[im1_height, im1_width, ~] = size(im1);
[im2_height, im2_width, ~] = size(im2);

% Match output image size to input image size by padding
if (im1_width > im2_width)
  im2 = padarray(im2, [0, im1_width - im2_width], 'symmetric', 'post');
elseif (im2_width > im1_width)
  im1 = padarray(im1, [0, im2_width - im1_width], 'symmetric', 'post');
end
if (im1_height > im2_height)
  im2 = padarray(im2, [im1_height - im2_height, 0], 'symmetric', 'post');
elseif (im2_height > im1_height)
  im1 = padarray(im1, [im2_height - im1_height, 0], 'symmetric', 'post');
end

% Repeat measurements to account for source or target image padding
[im_height, im_width, ~] = size(im1);

% Convert image to HSV space
im1_dbl = double(im1);
im2_dbl = double(im2);

% Cycle through each desired output frame
for M = 1 : size(warp_frac, 2)

  % Get warp points for the current frame by linear interpolation
  im_warp_pts = (1 - warp_frac(M)) * im1_pts + (warp_frac(M)) * im2_pts;

  % Thin-plate splines used to generate the warped source image
  im1_pts_x = im1_pts(:, 1);
  im1_pts_y = im1_pts(:, 2);
  [a1_x, ax_x, ay_x, w_x] = est_tps(im_warp_pts, im1_pts_x);
  [a1_y, ax_y, ay_y, w_y] = est_tps(im_warp_pts, im1_pts_y);
  im1_warp = morph_tps(im1, a1_x, ax_x, ay_x, w_x, a1_y, ax_y, ay_y, w_y, im_warp_pts, size(im1));

  % Thin-plate splines used to generate the warped target image
  im2_pts_x = im2_pts(:, 1);
  im2_pts_y = im2_pts(:, 2);
  [a1_x, ax_x, ay_x, w_x] = est_tps(im_warp_pts, im2_pts_x);
  [a1_y, ax_y, ay_y, w_y] = est_tps(im_warp_pts, im2_pts_y);
  im2_warp = morph_tps(im2, a1_x, ax_x, ay_x, w_x, a1_y, ax_y, ay_y, w_y, im_warp_pts, size(im2));

  % Dissolve each warped frame by linear interpolation
  current_frame = (1 - dissolve_frac(M)) * im1_warp + (dissolve_frac(M)) * im2_warp;
  morphed_im{M} = uint8(current_frame);
end
end
