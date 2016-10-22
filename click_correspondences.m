function [im1_pts, im2_pts] = click_correspondences(im1, im2)
% Get Cartesian points for features shared by the source and target image
% Author: Brian Wright
%
% Displays two images and collects (x, y) coordinate pairs
% for common features in each image. This function outputs
% a list of (x, y) pairs for the original image and another
% list of (x, y) pairs for the target (morphed) image.

% This function was used to generate im_pts.mat
clear im1_pts im2_pts
[im1_pts, im2_pts] = cpselect(im1, im2, 'Wait', true);

save('im_pts_NEW.mat', 'im1_pts', 'im2_pts');
end
