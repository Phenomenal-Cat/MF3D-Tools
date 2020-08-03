MF3D Release 1
==============

What's in MF3D R1?
------------------

MF3D R1 is a publicaly released stimulus set for the macaque research
community that consists of 14,000 static renders of the macaque avatar,
saved as high resolution (3840 x 2160 pixels, 32-bit) RGBA images in
.png format (`Figure 1A, i <>`__) and a smaller sample of animated video
clips. The inclusion of the alpha transparency channel allows for
compositing of multiple images into a frame, including backgrounds, as
well as making it easy to generate control stimuli with identical
silhouettes. The high resolution permits down-sampling or cropping as
appropriate for the display size being used.

The virtual scene was configured such that the avatar will appear at
real-world retinal size when images are presented at full-screen on a
27” monitor with 16:9 aspect ratio, at 57cm viewing distance from the
subject. For each 2D colour image, we additionally provide a label map
image, which is an indexed image that assigns each pixel an integer
value depending on the anatomical region of the avatar it belongs to
(`Figure 1A, ii <>`__). Label maps can be used to analyse subjects’ gaze
in free-viewing paradigms (`Figure 1A, iii-iv <>`__), for
gaze-contingent reward schedules, or for generating novel stimuli by
masking specific structures in the corresponding colour image (`Figure
1A, v <>`__).

Expression subset
-----------------

The static stimuli of MF3D release 1 are divided into two collections:
1) variable expressions with fixed identity (corresponding to real
individual M02); and 2) variable identities with fixed expression
(neutral). For the expression set, we varied head orientation (±90°
azimuth x ±30° elevation in 10° increments = 133 orientations; `Figure
1B, i <>`__), facial expression type (neutral plus bared-teeth ‘fear
grimace’, open-mouthed threat, coo, yawn, and tongue-protrusion = 5) and
the intensity of the expression (25, 50, 75 and 100% = 4; `Figure 1B,
ii <>`__). We additionally include the neutral expression with open and
closed eyes, as well as azimuth rotations beyond 90° (100 to 260° in 10°
increments) for a total of 2,926 colour images. In order to maintain
naturalistic poses, head orientation was varied through a combination of
neck (±30° azimuth and elevation) and body (±60° azimuth) orientations.

| |image0|
| **Figure 1B, Expression stimuli.** **i.** All head orientations
  rendered for each expression condition (neutral expression shown for
  illustration): 19 azimuth angles (-90 to +90° in 10° increments) x 7
  elevation angles (-30 to +30° in 10° increments) for 133 unique head
  orientations. **ii.** Five facial expressions (rows) rendered at four
  levels of intensity (columns), at each of the head orientations
  illustrated in **i**, for a total of 2,793 unique colour images. 

Identity subset
---------------

For the identity set, we selected a subset of head orientations (±90°
azimuth x ±30° elevation in 30° increments = 21 orientations; `Figure
1C, i <>`__), and co-varied facial morphology based on distinct
trajectories within PCA-space (n = 65; `Figure 1C, ii <>`__), including
each of the first five PCs (which together account for 75% of the sample
variance in facial morphology), with distinctiveness (Euclidean distance
from the average face, ±4σ in 1σ increments = 8 levels, excluding the
mean; `Figure 1C, iii <>`__) for a total of 10,941 identity images.

.. figure:: https://user-images.githubusercontent.com/7523776/58966855-0bcc9a80-8781-11e9-868d-4effb756136d.png
   :alt: 

**Figure 1C. Identity stimuli. i.** All head orientations rendered for
each identity condition (average identity shown for illustration): 7
azimuth angles x 3 elevation angles for 21 head orientations. **ii.**
Identity trajectories through face space were selected through all
pairwise combinations of the first 5 principal components from the PCA
(which cumulatively account for 75% of the sample variance in facial
morphology), at 3 polar angles for a total of 65 unique trajectories.
**iii.** Identities were rendered at eight levels of distinctiveness
(±4σ from the sample mean in 1σ increments) along each identity
trajectory (shown here for the first 5 PCs), plus the sample mean for a
total of 10,941 unique colour images.

Animation subset
----------------

For studies requiring more naturalistic stimuli, we also have the
ability to generate a virtually limitless number of animations that
promise great flexibility for studying dynamic facial behaviour. Here we
have included a small selection of short animations (2 seconds or less
per clip) as a proof of concept, which are rendered at 3840 x 2160
pixels and 60 frames per second, encoded with H.264
perceptually-lossless compression and saved in .mp4 format with a black
background. For each action sequence, animations are rendered at 5
different head azimuth angles (-60, to 60° in 30° increments). All
animations feature identical start and end frames, which allows the
possibility of stitching multiple clips together using video editing
software (such as the video editor included in Blender), to produce
longer, seamless movies containing various permutations of action
sequences. We provide a `Python
script <https://github.com/MonkeyGone2Heaven/MF3D-Tools/blob/master/MF3D_ConcatClips_Demo.py>`__
to demonstrate automated compilation of animation clips using Blender's
video sequence editor. The animations were produced by manually coding
video footage of real Rhesus macaques performing facial expressions and
vocalizations.

**Figure 1D. Animated stimuli.** A subset of frames from an example
animation sequence included in the MF3D R1 stimulus set is rendered at 5
different head azimuth orientations (rows). Bottom panel: Accompanying
audio waveform and spectrogram for this particular animation, which
depicts a ‘scream’ vocalization.

.. |image0| image:: https://user-images.githubusercontent.com/7523776/58966854-0bcc9a80-8781-11e9-82ad-bc2b22616581.png
