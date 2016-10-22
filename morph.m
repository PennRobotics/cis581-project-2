function [morphed_im] = morph(im1, im2, im1_pts, im2_pts, warp_frac, dissolve_frac)
% Triangulation used to morph a source image into a target image
% Author: Brian Wright
%
% im1: H1 x W1 x 3 representing first image
% im2: H2 x W2 x 3 representing second image
% im1_pts: N x 2 matrix with first image correspondences
% im2_pts: N x 2 matrix with second image correspondences
% warp_frac: 1 x M vector containing shape warping parameter [0, 1]
% dissolve_frac: 1 x M vector containing color blending parameter [0, 1]
% morphed_im: M cells, each containing a morphed image frame

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

im1_dbl = double(im1);
im2_dbl = double(im2);

% Delaunay triangulation control points are calculated mid-warp
im_pts_avg = (im1_pts + im2_pts) / 2;
tri = delaunay(im_pts_avg(:, 1), im_pts_avg(:, 2));
num_tri = size(tri, 1);

% Cycle through each desired output frame
for M = 1 : size(warp_frac, 2)

  % Get warp points for the current frame by linear interpolation
  im_warp_pts = (1 - warp_frac(M)) * im1_pts + (warp_frac(M)) * im2_pts;

  % Create a list for every pixel for vector operations
  x_points = ndgrid(1:im_width, 1:im_height)';
  y_points = ndgrid(1:im_height, 1:im_width);
  point_list = [x_points(:), y_points(:)];
  source_coords = zeros(size(point_list));
  target_coords = zeros(size(point_list));

  % Find the triangle to which each pixel belongs
  point_tri_links = tsearchn(im_warp_pts, tri, point_list);

  % Augment the point list for transformation matrix operations
  point_list = [point_list, ones(size(x_points(:)))];

  % Calculate transform matrices for each Delaunay triangle
  for this_tri_idx = 1 : num_tri
    this_tri = tri(this_tri_idx, :);

    a_tri = im1_pts(this_tri, :);
    b_tri = im_warp_pts(this_tri, :);
    c_tri = im2_pts(this_tri, :);

    T_tri_start = [a_tri'; 1 1 1];
    T_tri_warp  = [b_tri'; 1 1 1];
    T_tri_end   = [c_tri'; 1 1 1];

    T1 = T_tri_start * pinv(T_tri_warp);
    T2 = T_tri_end   * pinv(T_tri_warp);

    source_coord_list = point_list * T1';
    target_coord_list = point_list * T2';

    % Create a list of coordinates mapping the unwarped and warped images
    source_coords(point_tri_links == this_tri_idx, :) = source_coord_list(point_tri_links == this_tri_idx, 1:2);
    target_coords(point_tri_links == this_tri_idx, :) = target_coord_list(point_tri_links == this_tri_idx, 1:2);
  end

  % Fill in the warped images using linear interpolation (inverse warping)
  for chan = 1:3
    im1_warp_pixel_vect = interp2(im1_dbl(:, :, chan), source_coords(:, 1), source_coords(:, 2), 'linear');
    im2_warp_pixel_vect = interp2(im2_dbl(:, :, chan), target_coords(:, 1), target_coords(:, 2), 'linear');
    im1_warp(:, :, chan) = reshape(im1_warp_pixel_vect', im_height, im_width);
    im2_warp(:, :, chan) = reshape(im2_warp_pixel_vect', im_height, im_width);
  end

  % Dissolve each warped frame by linear interpolation
  current_frame = (1 - dissolve_frac(M)) * im1_warp + (dissolve_frac(M)) * im2_warp;
  morphed_im{M} = uint8(current_frame);
end
end
