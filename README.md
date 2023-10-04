# OpenSCAD to Sprite Sheet

This takes a `OpenSCAD` model and exports `$ROTS` rotations as individual frames. 

The model is rendered in different poses such as wheels turned, body tilted, car or shadow. These are controlled by shell script variables that are either passed to the model in the call to OpenSCAD.

The process is clever enough to only render models that have changed since last build, those whose modified date is newer than the existing generated images for that model.

### Optimisations

As many things are done in parallel as possible. It would be great if OpenSCAD could produce a sprite sheet which would remove the overhead of having to render many frames, write them to disk, then have another process read them back in and stitch them together.

## Post Processing

After exporting all frames there is some `image magick` work to process the files as follows:
1. stitch frames together into a single sprite sheet
2. split sprite sheet into RGBA channels
3. process channels to recolour and dither as required
4. recombine processed channels into new sprite sheet image

## Notes

It was made for my game [Daily Driver](https://gingerbeardman.itch.io/daily-driver) so a lot of the values are set to produce tiny, 1-bit, dithered sprites across several different poses, resulting in sprite sheet with 990 frames each for car and shadow totalling 1980 frames per car.

## Example Model

![](_car.png)

## Example Output

![](car-table-38-38.png)
