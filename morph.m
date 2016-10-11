function [morphed_im] = morph(im1, im2, im1_pts, im2_pts, tri, warp_frac, dissolve_frac)

im1_pts;
im2_pts;

tri;

im1_warp = im1;  % TODO(brwr)
im2_warp = im2;  % TODO(brwr)

warp_frac;

morphed_im = (1 - dissolve_frac) * im1_warp + (dissolve_frac) * im2_warp;

end
