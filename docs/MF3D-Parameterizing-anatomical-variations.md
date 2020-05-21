[TOC]

---

### Parameterizing anatomical variations

One of the earliest studies of variation in anatomical proportions was by the German Renaissance artist [Albrecht Dürer (1528)](https://www.nlm.nih.gov/exhibition/historicalanatomies/durer_bio.html), who described the application of [deformation grids](https://www.virtual-anthropology.com/virtual-anthropology/compare/geometric-morphometrics/thin-plate-spline/) to mathematically describe variation in human facial anatomy.

![https://www.virtual-anthropology.com/wp-content/uploads/2017/02/thinplatespline1.jpg]

D'Arcy Thompson's (1917) Cartesian transformation

---

### PCA-based 'Face-space'

A pioneering study by [Blanz & Vetter (1999)]() was the first to apply this PCA-based approcah to 3D face data acquired through laser scans of 200 human participants. which lead to the commercially released as [FaceGen]().



An important step in is to establish point-to-point correspondences between samples. This can be acheived using thin plate spline (TPS) methods ([Chen et al., 2017](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0185567)). 

The commerical software [Wrap3](https://www.russian3dscanner.com/) provides a graphical user interface for users to manually select corresponding vertices o

[SlicerMorph](https://slicermorph.github.io/) module 

---

### Craniofacial morphology analysis for MF3D

The method for creating the macaque face-space used to generate identity variations in MF3D is described in [Murphy & Leopold (2019)](https://doi.org/10.1016/j.jneumeth.2019.06.001) and illustrated in figure 5 from that paper (below). Corresponding vertices were manually selected on the low-poly (50,000 verts) base mesh topology (created from individual M02 of the database) and the high-poly raw surface meshes of each other individual (panel A). 

The warping process produces a surface mesh with topology A and morphology B (bottom left), which can then be manually edited (bottom right). 

B. Sample mean mesh surface. C. First five principal components (mean ± 2σ) of macaque face-space. D. Locations of original sample identities (n = 23) projected into principal component face-space (first 3 PC dimensions only). E. Distribution of CT scan voxel volume for each individual plotted against their Euclidean distance from the sample mean (σ). F. Percentage of variance in sample cranio-facial morphology explained by each principal component. G. Distributions of demographic variables for Rhesus macaque CT data sample (see also Table 1). H. Age trajectory through face-space for males calculated by averaging 5 youngest (2nd column) and 5 oldest (4th column) males, and extrapolating. I. Sexual dimorphism trajectory through face-space calculated by averaging 5 males (2nd column) and 5 females (4th column), and extrapolating. Colour map indicates the displacement of each vertex relative to the mean (middle column) for each mesh. Meshes were aligned via Procrustes method.

<figure>
    <img src='https://ars.els-cdn.com/content/image/1-s2.0-S0165027019301591-gr5_lrg.jpg' />
    <figcaption> <b>Morphable face model construction from Murphy & Leopold (2019)
    </figcaption>
    </font>
</figure>


