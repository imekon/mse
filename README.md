# mse
Model Scene Editor

What is Model Scene Editor?

A long time ago, I became interested in raytracing, and came across something called DKBTrace, by David K Buck. It was superseded by POVray and required a text scene file to create the amazing scenes possible with it.

I tried to use it, but quickly became frustrated with the lack of a preview mode and the number of completely dark scenes I would create as I had the camera and lights in the wrong places!

I was using an Acorn Archimedes at the time, a RISC based home computer with a powerful desktop (better than Windows 3.1!). It had a C compiler and a toolkit for GUI applications so I started thinking about creating a scene editor for POVray.

Creating perspective views of a 3D scene is basically displaying an image where x, y coordinates are divided by z, giving the depth of field. It seemed simple enough 8), so I began looking into it.

I quickly descovered that there was much more to it than just dividing by z! There was translation, rotation and scaling, then adjusting the scene according to the location of the camera and the point the camera is looking at!

I began reading some basic 3D graphics books and came up with a number of processing functions to do translation, scaling and rotation, plus the perspective view. That made the drawing part of Model Scene Editor.

I then had to create all the individual objects in MSE; spheres, planes, cubes etc. These proved to be very time consuming. Meanwhile I was descovering that the Archimedes platform with no floating point acceleration to be a major hindrance... the Intel 486 DX with it's flaoting point was beckoning...

I started with Visual C++ V1.5 (a Microsoft product) and converted from C to C++ and learnt about inheritance and other related topics... unfortunately, I got bogged down again. It was taking 40 minutes to build MSE, as I made changes to one key header file.

I came across Delphi 1.0 on the front of a magazine and tried it, liked it, bought the V2.0 product and started converting to Delphi's Object Pascal.

Borland are not kidding when they call the Delphi product Rapid Application Development! My build times dropped from 40 minutes to 40 seconds! I created the same objects and went beyond what I could achieve with Visual C++ in a few months. Then I started on even more complex objects: torii and lathes, and found Delphi was the perfect tool to create the GUI and the new shapes I wanted in the editor.

The latest changes in MSE have centralised the way certain shapes are constructed out of triangles. A sphere, for instance, is a specific form of 'solid object', as in 'solid of revolution' or 'swept object'. A torus is a circle swept around like a lathe. By building objects out of each other, I radically recreated my shape engine.

Delphi has speeded this process considerably. It has a few weaknesses - certainly circular unit references are a pain but not insurmountable. It is a fast compiler and linker and produces efficient code.

This is a project I started in 1996; I'm reloading it into Delphi Berlin 10.2 Update 2

Pete Goodwin 2017
mse@imekon.org

