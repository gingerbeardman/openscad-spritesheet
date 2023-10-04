# OpenSCAD to Sprite Sheet

This takes a [OpenSCAD](https://github.com/openscad/openscad) model and exports `$ROTS` rotations as individual frames. 

The model is rendered in different poses such as wheels turned, body tilted, car or shadow. These are controlled by shell script variables that are either passed to the model in the call to OpenSCAD.

The process is clever enough to only render models that have changed since last build, those whose modified date is newer than the existing generated sprite sheet for that model.

## Post Processing

After exporting all frames there is some `image magick` work to process the files as follows:
1. stitch frames together into a single sprite sheet
2. split sprite sheet into RGBA channels
3. process channels to recolour and dither as required
4. recombine processed channels into new sprite sheet image

You can [read about that in an old blog post of mine](https://blog.gingerbeardman.com/2021/06/05/channelling-rgb-into-1bit/).

## Notes

This workflow was made for my game [Daily Driver](https://gingerbeardman.itch.io/daily-driver) so a lot of the values are set to produce tiny, 1-bit, dithered sprites across several different poses, resulting in sprite sheet with 990 frames each for car and shadow totalling 1980 frames per model.

## Optimisations

As many things are done in parallel as possible using shell script backgrounding, but there is still room for improvement. 

It would be great if OpenSCAD could produce a sprite sheet which would remove the overhead of having to render many frames, write them to disk, then have another process read them back in and stitch them together.

## Benchmarks

A full build of 36 cars is as follows:

- 3GHz 6-core Intel Mac mini 32GB
  - 100% CPU for ~26 minutes
- M1 Pro 10-core MacBook Pro 16GB
  - 70% CPU for ~9 mins
  - about 3x speedup
  - approx 16 seconds per car

That's parallel 3D rendering, PNG writing & compositing & processing, and copying of ~140K files (which takes up ~0.5GB of disk space).

----

## Example Model

Not to scale! Sizes of features are exagerated to allow for them to appear correct when rendered at a very small size.

![](_car.png)

## Example Output

990 frames each for car and shadow, total of 1980 frames per sprite sheet. Each sprite sheet takes up about ~400KB of RAM on Playdate, and only one is loaded at a time.

![](car-table-38-38.png)
