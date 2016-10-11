function [morphed_im] = morph(im1, im2, im1_pts, im2_pts, tri, warp_frac, dissolve_frac)

im1_pts;
im2_pts;

tri;  % TODO(brwr): Double-check current pdf specification

%{
time = [0, 0.0001, 59.9999, 60];
mesh = [from from to to; from from to to; . . . ; from from to to];
timeInterp = 0:60;
meshInterp = spline(time, mesh, timeInterp);
%}

im1_warp = im1;  % TODO(brwr)
im2_warp = im2;  % TODO(brwr)

warp_frac;

im1_warp = zeros(N) * -1;
im2_warp = im1_warp;

for this_tri = 1:size(tri, 1)
  A = [];  % TODO(brwr): Homogeneous transform from triangle 1 to triangle 2
end

% TODO(brwr): Search for -1 and interpolate using filled neighbor pixels

morphed_im = (1 - dissolve_frac) * im1_warp + (dissolve_frac) * im2_warp;

end
