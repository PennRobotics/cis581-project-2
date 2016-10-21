%% INITIALIZE
clear all
DO_TRIG = 1;
POINTS_SAVED = 1;

img_from = (imread('jimcarrey.jpg'));
img_to = (imread('johncena.jpg'));

% Gather control points
if (POINTS_SAVED)
  load('carrey.mat');
else
  [im1_pts, im2_pts] = click_correspondences(img_from, img_to);
end

timeInterp = linspace(0, 1, 60);
colorInterp = linspace(0, 1, 60).^10;

img_morphed = morph(img_from, img_to, im1_pts, im2_pts, timeInterp, colorInterp);

if DO_TRIG
  fname = 'carrey.avi';
else
  fname = 'carrey_tps.avi';
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
