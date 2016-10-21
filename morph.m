function [morphed_im] = morph(im1, im2, im1_pts, im2_pts, warp_frac, dissolve_frac)
% im1: H1 x W1 x 3 representing first image
% im2: H2 x W2 x 3 representing second image
% im1_pts: N x 2 matrix with first image correspondences
% im2_pts: N x 2 matrix with second image correspondences
% warp_frac: 1 x M vector containing shape warping parameter [0, 1]
% dissolve_frac: 1 x M vector containing color blending parameter [0, 1]
% morphed_im: M cells, each containing a morphed image frame

% Check input conditions
% assert(size(warp_frac, 1) == size(dissolve_frac, 1), 'Warp and dissolve vectors have different sizes')
% assert(size(warp_frac, 2) == size(dissolve_frac, 2), 'Warp and dissolve vectors have different sizes')
% assert(size(im1_pts, 1) == size(im2_pts, 1), 'Number of correspondences is not the same for each image')
% assert(size(im1_pts, 2) == size(im2_pts, 2), 'Number of correspondences is not the same for each image')
% assert(size(im1, 3) == 3, 'Color channels missing from source image')
% assert(size(im2, 3) == 3, 'Color channels missing from target image')

morphed_im = cell(1, 60);  % Preallocate and set data type of output variable

[im1_width, im1_height, ~] = size(im1);
[im2_width, im2_height, ~] = size(im2);

im1_dbl = double(im1);
im2_dbl = double(im2);

% Match output image size to input image size by padding
if (im1_width > im2_width)
  im2 = padarray(im2, [im1_width - im2_width, 0], 'symmetric', 'post')
elseif (im2_width > im1_width)
  im1 = padarray(im1, [im2_width - im1_width, 0], 'symmetric', 'post')
end
if (im1_height > im2_height)
  im2 = padarray(im2, [0, im1_height - im2_height], 'symmetric', 'post')
elseif (im2_height > im1_height)
  im1 = padarray(im1, [0, im2_height - im1_height], 'symmetric', 'post')
end

% Delaunay triangulation control points are calculated mid-warp
im_pts_avg = (im1_pts + im2_pts) / 2;
tri = delaunay(im_pts_avg(:, 1), im_pts_avg(:, 2));
num_tri = size(tri, 1);

% Cycle through each desired output frame
for M = 1 : size(warp_frac, 2)

  % Preallocate each array
  current_frame = zeros(im1_width, im1_height, 3, 'double');
  im1_warp = zeros(im1_width, im1_height, 3, 'double');
  im2_warp = zeros(im2_width, im2_height, 3, 'double');
  T1 = zeros(3, 3, num_tri);
  T2 = zeros(3, 3, num_tri);

  % Get warp points for the current frame by linear interpolation
  im_warp_pts = (1 - warp_frac(M)) * im1_pts + (warp_frac(M)) * im2_pts;

  % Calculate transform matrices for each Delaunay triangle
  for this_tri_idx = 1 : num_tri
    this_tri = tri(this_tri_idx, :);

    a_tri = im1_pts(this_tri, :);
    b_tri = im_warp_pts(this_tri, :);
    c_tri = im2_pts(this_tri, :);

    T_tri_start = [a_tri'; 1 1 1];
    T_tri_warp  = [b_tri'; 1 1 1];
    T_tri_end   = [c_tri'; 1 1 1];

    T1(:, :, this_tri_idx) = T_tri_start * pinv(T_tri_warp);
    T2(:, :, this_tri_idx) = T_tri_end   * pinv(T_tri_warp);
  end

  parfor i = 1: im1_width
    for j = 1: im1_height
      pixel = [i, j];
      % Locate the corresponding triangle in source and target image
      pixel_tri_idx = tsearchn(im_warp_pts, tri, pixel);
      for chan = 1 : 3
        % Find coordinate of pixel using a coordinate transform
        im1_loc = T1(:, :, pixel_tri_idx) * [pixel, 1]';
        im2_loc = T2(:, :, pixel_tri_idx) * [pixel, 1]';
        % Choose pixel values based on nearest pixels in each image (source and target)
        im1_level = interp2(im1_dbl(:, :, chan), im1_loc(1, 1), im1_loc(2, 1), 'linear');
        im2_level = interp2(im2_dbl(:, :, chan), im2_loc(1, 1), im2_loc(2, 1), 'linear');
        im1_warp(j, i, chan) = im1_level;
        im2_warp(j, i, chan) = im2_level;
      end
    end
  end

  % Dissolve each warped frame by linear interpolation
  current_frame = (1 - dissolve_frac(M)) * im1_warp + (dissolve_frac(M)) * im2_warp;
  morphed_im{M} = uint8(current_frame);
end
end
