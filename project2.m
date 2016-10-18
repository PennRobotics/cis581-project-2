%% INITIALIZE
clear all
DO_TRIG = 1;
POINTS_SAVED = 1;

img_from = (imread('bwright.jpg'));
img_to = (imread('bfrank.jpg'));

% Gather control points
if (POINTS_SAVED)
  load('im_pts.mat');
else
  [im1_pts, im2_pts] = click_correspondences(img_from, img_to);
end

time = [0, 0.00001, 0.99999, 1];
colorRange = [0, 0, 1, 1];
timeInterp = linspace(0, 1, 60);
colorInterp = spline(time, colorRange, timeInterp);

img_morphed = morph(img_from, img_to, im1_pts, im2_pts, timeInterp, colorInterp);

for idx = 1:60;
  current_frame = img_morphed{idx};
  imagesc(current_frame);
  pause(0.1)
end

return  % TODO(brwr))

% Figure
h = figure(2); clf;
whitebg(h,[0 0 0]);


%% EVAL
if DO_TRIG
    fname = 'Project2_trig.avi';
else
    fname = 'Project2_tps.avi';
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

% Warp reference images
if (do_trig)
  img_ref(1) = {morph(img, img, p1, cell2mat(p2(1)), tri, 1, 0)};
  img_ref(2) = {morph(img, img, p1, cell2mat(p2(2)), tri, 1, 0)};
  img_ref(3) = {morph(img, img, p1, cell2mat(p2(3)), tri, 1, 0)};
  img_ref(4) = {morph(img, img, p1, cell2mat(p2(4)), tri, 1, 0)};
  img_ref(5) = {cell2mat(img_ref(1))};
else
  img_ref(1) = {morph_tps_wrapper(img, img, p1, cell2mat(p2(1)), 1, 0)};
  img_ref(2) = {morph_tps_wrapper(img, img, p1, cell2mat(p2(2)), 1, 0)};
  img_ref(3) = {morph_tps_wrapper(img, img, p1, cell2mat(p2(3)), 1, 0)};
  img_ref(4) = {morph_tps_wrapper(img, img, p1, cell2mat(p2(4)), 1, 0)};
  img_ref(5) = {cell2mat(img_ref(1))};
end

% Morph iteration
for j=1:4
  for w=0:0.1:1
    img_source = cell2mat(img_ref(j));
    p_source = cell2mat(p2(j));
    img_dest = cell2mat(img_ref(j+1));
    p_dest = cell2mat(p2(j+1));
    if (do_trig == 0)
      img_morphed = morph_tps_wrapper(img_source, img_dest, p_source, p_dest, w, w);
    else
      img_morphed = morph(img_source, img_dest, p_source, p_dest, tri, w, w);
    end
    % if image type is double, modify the following line accordingly if necessary
    imagesc(img_morphed);
    axis image; axis off;drawnow;
    try
        % VideoWriter based video creation
        h_avi.writeVideo(getframe(gcf));
    catch
        % Fallback deprecated avifile based video creation
        h_avi = addframe(h_avi, getframe(gcf));
    end
  end
end
try
    % VideoWriter based video creation
    h_avi.close();
catch
    % Fallback deprecated avifile based video creation
    h_avi = close(h_avi);
end
clear h_avi;
