function [im1_pts, im2_pts] = click_correspondences(im1, im2)

clear fixedPoints movingPoints
cpselect(im1, im2);
im1_pts = fixedPoints;
im2_pts = movingPoints;

end
