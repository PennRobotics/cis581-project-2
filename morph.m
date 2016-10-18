function [morphed_im] = morph(im1, im2, im1_pts, im2_pts, warp_frac, dissolve_frac)
% im1: H1 x W1 x 3 representing first image
% im2: H2 x W2 x 3 representing second image
% im1_pts: N x 2 matrix with first image correspondences
% im2_pts: N x 2 matrix with second image correspondences
% warp_frac: 1 x M vector containing shape warping parameter [0, 1]
% dissolve_frac: 1 x M vector containing color blending parameter [0, 1]
% morphed_im: M cells, each containing a morphed image frame

morphed_im = cell(1, 60);
figure(2)

for M = 1 : size(warp_frac, 2)
  [im1_width, im1_height, ~] = size(im1);
  [im2_width, im2_height, ~] = size(im2);

  % Control points
  im_pts_avg = (im1_pts + im2_pts) / 2;
  tri = delaunay(im_pts_avg(:, 1), im_pts_avg(:, 2));

  im_warp_pts = (1 - warp_frac(M)) * im1_pts + (warp_frac(M)) * im2_pts;

  im1_warp = zeros(im1_width, im1_height, 3, 'double');
  im2_warp = zeros(im2_width, im2_height, 3, 'double');

  T1 = zeros(3, 3, size(tri, 1));
  T2 = zeros(3, 3, size(tri, 1));

%  morphed_im = zeros(im1_width, im1_height, 3, 'double');

  trimesh(tri,im_warp_pts(:,1),im_warp_pts(:,2))
  pause(0.05)

  for n = 1 : size(tri, 1)
    x = im_warp_pts(tri(n, :), 1);
    y = im_warp_pts(tri(n, :), 2);
%    morphed_im(round(x), round(y), [1 1 1]') = 1;
  end


  for tri_idx = 1 : size(tri, 1)
    a = im1_pts(tri(tri_idx, :), :);
    b = im_warp_pts(tri(tri_idx, :), :);
    c = im2_pts(tri(tri_idx, :), :);

    tri_start = [a'; 1 1 1];
    tri_warp = [b'; 1 1 1];
    tri_end = [c'; 1 1 1];

    T1(:, :, tri_idx) = tri_start * inv(tri_warp);
    T2(:, :, tri_idx) = tri_end * inv(tri_warp);
  end

%  all_points = [kron(ones(im1_width,1),[1:im1_height]'), repmat([1:im1_height]',im1_width,1)];
%  tri_idx = tsearchn(im_warp_pts, tri, all_points);
%  for i = 1 : size(all_points, 1)
%    tri_idx(i)
%  end


%  im1_hsv = rgb2hsv(im1);  % output is type double
%  im2_hsv = rgb2hsv(im2);

  % x = 1:60;
  % p = 1.10 ./ (1 + exp(-(-3+0.1*x))) - .05;
  % q = 1 - p;

  %% IMAGE ONE
  % Create triangles for the current frame using warp_frac

  % Determine which triangle the current pixel is in using tsearchn

  % Use interp2 to get the correct fraction of colors from neighbors
% TODO(brwr):  im1_warp = interp2()

  %% IMAGE TWO
  im2_warp = zeros(im1_width, im1_height, 3, 'double');


  % TODO(brwr): Convert to RGB

%  morphed_im = uint8((1 - dissolve_frac) * im1_warp + (dissolve_frac) * im2_warp);
  current_frame(:, :, 1) = [1 1; 1 1; 0 0; 0 0];
  current_frame(:, :, 2) = [1 1; 0 0; 1 1; 0 0];
  current_frame(:, :, 3) = [1 0; 1 0; 1 0; 1 0];
  morphed_im{M} = current_frame;
  disp('it')
end
end
