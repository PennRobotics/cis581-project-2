# Image Morphing
*Brian Wright, University of Pennsylvania*  
These Matlab scripts create intermediate frames which transition visually from
one photograph to another. The image shape is warped and colors are dissolved
using a manual mapping between image features. As an example, a human face might
have features such as corners of eyes, the tip of the nose, and the perimeter of
the mouth.

Two warp methods are implemented: Delaunay triangulation and thin-plate splines

Delauney triangulization is used to connect features in a mesh. Implementation
of this algorithm uses Thales' theorem to ensure triangles do not contain
illegal edges: a circle created using three endpoints of a triangle should not
contain any other points. This mesh is then deformed to reach similar features
in the second photograph.

Thin-plate splines are a type of kernel used in a radial basis function. There
is a shift in each pixel from the unwarped image to the warped image based on
the pixel's distance from each control point. This creates a smoother warping
field than the triangulation method: There are no discontinuities along the
boundaries between control points.

This repository contains several sample files. These include a Matlab script
that morphs the author's face into Benjamin Franklin's face. Another morphs from
Jim Carrey into John Cena. Pictures were preprocessed to have similar image
characteristics---hue, lightness, feature size. There is also a sample image---
a colored diamond---that is converted into a video using a script provided in
the CIS 581 course by Jianbo Shi. The AVI videos generated by each script are
included.
