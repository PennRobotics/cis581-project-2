function [im1_pts, im2_pts] = click_correspondences(im1, im2)
% This function was used to generate im_pts.mat

clear im1_pts im2_pts
[im1_pts, im2_pts] = cpselect(im1, im2, 'Wait', true);

save('im_pts_NEW.mat', 'im1_pts', 'im2_pts');

end
