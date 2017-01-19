Readme file for Model Scene Editor
==================================

Version 0.13

(c) Copyright Pete Goodwin 1996, 1999

Model is available from http://www.netcomuk.co.uk/~pgoodw

Latest release

Version 0.13
============

The testure editor has been revised.

Version 0.11
============

This version has culling of objects too close to the camera, halos and a new toolbar look.

Version 0.9
===========

Camera view
-----------

Camera view can be confused by objects close to the camera (observer). You'll get strange effects, like odd points where an object converges!

Map Editing
-----------

This version has a new map editor.

SMPL support
------------

Megahedron is a 3D Graphics engine that understands SMPL (pronounced 'simple'). Model can now output SMPL scenes.

VRML support
------------

Model can output VRML V1.0 format files

Group/CSG objects
-----------------

Group objects can be manipulated with the group editor - you can now add/remove objects from groups.

Heightfield fixes
-----------------

'smooth true' changed to 'smooth'

Julia Fractal
-------------

For Quaternion, functions limited to cube and sqr.

Hidden line removal
-------------------

I changed to 'Painters Algorithm' to do the hidden line removal in the Camera view - this works much better but isn't perfect. Large objects (i.e. with a small number of triangles) won't work properly. This is true of planes and cubes.

Undo buffer
-----------

I added the undo buffer in this version - it was something everyone requested, so I looked into creating this.

It handles up to 1000 operations (I might make this configurable).

Undo will be per view, not global. The seperate editors will have their own Undo buffers. The global undo buffer won't handle the individual editor undo details.

Unfinished pieces
-----------------

Animation and Halos.

Version 0.8
===========

File handling
-------------

Handling has improved but still has problems with modified files.

Textures if modified, will be saved on exiting.

Textures have been updated - colour maps have a new editor. Turbulence has been added where it is relevant.

Polygon editor is working. When you create a polygon, you are offered a choice of starting shapes.

Extrusion editor has been added. Extrusions are polygon objects. Note: if you create a shape like this:

			+---+
		       /   /
		      /   /
		      |  /
		      |  \
		      |   \
                      +----+

it is possible the extrusion editor may incorrectly fill the shape with triangles that lie outside the shape.

Solid editor is working, the select/move (drag) has been combined. Click on a point then simply drag it. Surface of Revolution (Use SOR) has been added to the Solid editor.

Bicubic patch editor is working.

Lathe is a new object and its editor is working. It is very similar to the Solid Editor.

Torus is now created as a torus and not a disk.

The main window remembers its last position.

Translate now works by dragging from anywhere on the object, rather than snapping to the center of the object. Scale is similar. Rotate is still 'absolute', i.e. not relative to the starting position.

Hidden line removal is present but doesn't work properly.

Paste Multiple is present but doesn't work properly.

Ungroup does nothing. Currently there is no way to ungroup any union, merge, difference etc. Also, you can't edit a group.

Version 0.6
===========

File handling
-------------

File handling is primitive - you can open and save. Model doesn't keep track of certain modifications to a scene, so it's best to constantly keep saving scenes.

Gallery Objects can be created and used, but there isn't any way to load or save them as yet.

Textures are automatically loaded - however if you modify them you should save before you exit - Model currently doesn't keep track of changes.

The various editors
-------------------

The Polygon Editor displays but doesn't really edit very well.

The Solid Editor should be working ok.

The Bicubic Patch editor is unfinished and not working.

The Texture editors should be working, however I've not had a lot of
time to test them!

Pete.
