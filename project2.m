% Project II - Image Morphing
% Author: Brian Wright (University of Pennsylvania)

%% INITIALIZE
clear all
DO_TRIG = 0;
POINTS_SAVED = 1;

img_from = (imread('bwright.jpg'));
img_to = (imread('bfrank.jpg'));

% Gather control points
if (POINTS_SAVED)
  load('im_pts.mat');
else
  [im1_pts, im2_pts] = click_correspondences(img_from, img_to);
end

% The color interpolation starts and ends slowly (cubic spline)
time = [0, 0.00001, 0.99999, 1];
colorRange = [0, 0, 1, 1];
timeInterp = linspace(0, 1, 60);
colorInterp = spline(time, colorRange, timeInterp);

if DO_TRIG
  img_morphed = morph(img_from, img_to, im1_pts, im2_pts, timeInterp, colorInterp);
  fname = 'project2_trig.avi';
else
  img_morphed = morph_tps_wrapper(img_from, img_to, im1_pts, im2_pts, timeInterp, colorInterp);
  fname = 'project2_tps.avi';
end

try
  % VideoWriter based video creation
  h_avi = VideoWriter(fname, 'Uncompressed AVI');
  h_avi.FrameRate = 10;
  h_avi.open();
catch
  % Fallback deprecated avifile based video creation
  h_avi = avifile(fname,'fps',10);
end

for idx = 1:60;
  current_frame = img_morphed{idx};
  h = figure(2); clf
  whitebg(h,[0 0 0]);
  imagesc(current_frame);
  try
    % VideoWriter based video creation
    h_avi.writeVideo(getframe(gcf));
  catch
    % Fallback deprecated avifile based video creation
    h_avi = addframe(h_avi, getframe(gcf));
  end
  pause(0.1)
end

try
  % VideoWriter based video creation
  h_avi.close();
catch
  % Fallback deprecated avifile based video creation
  h_avi = close(h_avi);
end

clear h_avi;
