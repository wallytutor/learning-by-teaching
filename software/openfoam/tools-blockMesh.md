# BlockMesh

Although #OpenFOAM/snappyHexMesh  is a pretty powerful tool, it relies on the simpler #OpenFOAM/blockMesh utility for background meshing generation. By itself, `blockMesh` is not very useful for other things than conceiving simple domains for conceptual applications mainly in academic research.

In its simplest use, `blockMesh` can be used to create a simple bounding box around the geometry to be castellated and snapped; there might be other cases where *intelligent* grading of bounding box meshes can be useful and this document seeks to document the use of the tool to cover those ends in a better way than its official documentation does.

By the end the reader should be able to check the following boxes:

- [ ] Declaring vertices
- [ ] Creating blocks
- [ ] Simple grading of blocks
- [ ] Multiple grading of blocks
- [ ] Edges
- [ ] Named boundary
- [ ] Merging patch pairs

## Simple bounding box

...

## Including simple grading

...

## More complex grading

...

## Merging blocks

...

## Creating edges

...
