# Image Morphing
*Brian Wright, University of Pennsylvania*
These Matlab scripts create intermediate frames which transition visually from
one photograph to another. The image shape is warped and colors are dissolved
using a manual mapping between image features. As an example, a human face might
have features such as corners of eyes, the tip of the nose, and the perimeter of
the mouth.

Delauney triangulization is used to connect features in a mesh. Implementation
of this algorithm uses Thales' theorem to ensure triangles do not contain
illegal edges: a circle created using three endpoints of a triangle should not
contain any other points. This mesh is then deformed to reach similar features
in the second photograph.
