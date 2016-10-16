function [morphed_im] = morph(im1, im2, im1_pts, im2_pts, tri, warp_frac, dissolve_frac)

[im1_width, im1_height, ~] = size(im1);
[im2_width, im2_height, ~] = size(im2);

a = [0 0;0 1;1 0];  % TODO(brwr)
c = [0 0;0 1;1 0];

tri_from = [a'; 1 1 1];
tri_to = [c'; 1 1 1];
T1 = tri_from * inv(tri_to);
T2 = tri_to * inv(tri_from);

im1_warp = zeros(im1_width, im1_height, 3, 'double');
im2_warp = zeros(im2_width, im2_height, 3, 'double');
im_warp_pts = (1 - warp_frac) * im1_pts + (warp_frac) * im2_pts;

% Convert to HSV
% Exponential blending of sat and val channels
% Bt = -log((1-t)*e^-x + (t)*e^-y)
% Cubic spline blend of hue
%   Ensure shortest distance of hue

%% IMAGE ONE
    % Create triangles for the current frame using warp_frac
    % Determine which triangle the current pixel is in using tsearchn
    % Use the transformation matrix to find the exact from coordinate
    % Use interp2 to get the correct fraction of colors from neighbors

%% IMAGE TWO
im2_warp = zeros(im1_width, im1_height, 3, 'double');
% TODO(brwr): For-loops might not be necessary!)
for i = 1:im2_width
  for j = 1:im2_height

  end
end


for this_tri = 1:size(tri, 1)
  A = [];  % TODO(brwr): Homogeneous transform from triangle 1 to triangle 2
end

% Convert to RGB

morphed_im = (1 - dissolve_frac) * im1_warp + (dissolve_frac) * im2_warp;

end
