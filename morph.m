function [morphed_im] = morph(im1, im2, im1_pts, im2_pts, tri, warp_frac, dissolve_frac)

im1_pts;
im2_pts;

tri;

%{
time = [0, 0.0001, 59.9999, 60];
mesh = [from from to to; from from to to; . . . ; from from to to];
timeInterp = 0:60;
meshInterp = spline(time, mesh, timeInterp);
%}

im1_warp = im1;  % TODO(brwr)
im2_warp = im2;  % TODO(brwr)

warp_frac;

morphed_im = (1 - dissolve_frac) * im1_warp + (dissolve_frac) * im2_warp;

end
