### About the MF3D Tools repository
This GitHub repository contains code (Matlab and Python) to facilitate the selection, loading, editing, analysis and saving of images and animations from the [MF3D stimulus set](https://figshare.com/projects/MF3D_Release_1_A_visual_stimulus_set_of_parametrically_controlled_CGI_macaque_faces_for_research/64544). The images and animations themselves are hosted on figshare and must be downloaded separately for this code to be of use:
* [MF3D Expression set](https://doi.org/10.6084/m9.figshare.8226029)
* [MF3D Identities set](https://doi.org/10.6084/m9.figshare.8226311)
* [MF3D Animations set](https://doi.org/10.6084/m9.figshare.8226317)

The code in this repository is licensed under GNU General Public License [GNU GPLv3](https://choosealicense.com/licenses/gpl-3.0/#), while the media provided in the MF3D R1 stimulus set is licensed under Creative Commons [CC BY-NC 4.0](http://creativecommons.org/licenses/by-nc/4.0/).
If you use any content from the stimulus set in your research, we ask that you cite the following publication:

> [**Murphy AP & Leopold DA (2019)**. A parameterized digital 3D model of the Rhesus macaque face for investigating the visual processing of social cues. _J.Neurosci.Methods_, 324: 108309. DOI: 10.1016/j.jneumeth.2019.06.001](https://doi.org/10.1016/j.jneumeth.2019.06.001)

<a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/"><img alt="Creative Commons License" style="vertical-align:left;margin:10px" src="https://i.creativecommons.org/l/by-nc/4.0/88x31.png" /></a>This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/">Creative Commons Attribution-NonCommercial 4.0 International License</a>.

---

### MF3D R1 Stimulus Set

The macaque face 3D (MF3D) stimulus set release #1 (R1) is the first database of computer generated images of a parametrically controlled, anatomically accurate, 3D avatar of the Rhesus macaque face and head. The intended use of the database is for visual stimulation in behavioural and neuroscientific studies involving Rhesus macaque subjects. An overview of the contents of the stimulus set can be found [here](https://github.com/MonkeyGone2Heaven/MF3D/wiki/MF3D-Release-%231), while full details of how the images were generated are available in the associated publication cited above. 

![](https://user-images.githubusercontent.com/7523776/58911022-ef7b2000-86e4-11e9-8a6a-ef9a44206a4e.png)

---

### Feature Overview

The following video animations demonstrate some of the parameters of the 3D macaque avatar that can be controlled (click images to open videos).

#### **Facial expression, gaze and lighting**<br>

<iframe class="float-left" src="https://player.vimeo.com/video/326460055?color=ff9933&byline=0&portrait=0" width="500" height="281" frameborder="0" allow="autoplay; fullscreen" allowfullscreen></iframe>

This video demonstrates how our macaque model of emotional facial expressions (for a single identity) can be continuously and parametrically varied to adjust appearance. The model was constructed using computed tomography (CT) data from a real Rhesus macaque, acquired under anesthesia, and edited and rigged by a professional digital artist. In addition to control of various facial expressions, the model's head and eye gaze direction can be programmatically controlled, as well as other variables such as environmental lighting and surface coloration, amongst others.<br>

---

#### **Facial dynamics estimation**<br>

<iframe class="float-left" src="https://player.vimeo.com/video/329805226?color=ff9933&byline=0&portrait=0" width="500" height="281" frameborder="0" allow="autoplay; fullscreen" allowfullscreen></iframe>

In order to simulate naturalistic facial dynamics in the macaque avatar, we estimate the time courses of facial motion from video footage of real animals. Applying these time courses to the animation of bones and shape keys of the model, we can mimic the facial motion of the original clip, while retaining independent control over a wide range of other variables. The output animation can be rendered at a higher resolution and frame rate (using interpolation) than the input video. (Original video footage in the left panel is used with permission of Off The Fence™).<br>

---

#### **Identity morphing**<br>

<iframe class="float-left" src="https://player.vimeo.com/video/323447440?loop=1&color=ff9933&byline=0&portrait=0" width="500" height="281" frameborder="0" allow="autoplay; fullscreen" allowfullscreen></iframe>

This video demonstrates how the model of individual variations in cranio-facial morphology (3D shape) can be continuously and parametrically varied to adjust appearance, as in the [MF3D R1 Identity](https://doi.org/10.6084/m9.figshare.8226311) stimulus set. The statistical model was constructed through principal component analysis (PCA) of the 3D surface reconstructions of 23 real Rhesus monkeys from computed tomography (CT) data acquired under anesthesia. The 3D plot in the top right corner illustrates the first three principal components of this 'face-space', where the origin of the plot represents the sample average face.

---

#### **Animated sequences**<br>

<iframe class="float-left" src="https://player.vimeo.com/video/394782616?color=ff9933&byline=0&portrait=0" width="500" height="281" frameborder="0" style="text-align:left" allow="autoplay; fullscreen" allowfullscreen></iframe>
<p>This video demonstrates how animation clips from the [MF3D R1 Animation](https://figshare.com/articles/MF3D_R1_Animations/8226317) stimulus set can be combined to form a longer continuous animation sequence for use in experiments that require more naturalistic dynamics. This example was generated using the Python script [`MF3D_ConcatClips_Demo.py`](https://github.com/MonkeyGone2Heaven/MF3D-Tools/blob/master/MF3D_Blender/MF3D_ConcatClips_Demo.py) to control Blender's video sequence editor.</p>
<div class="clear"></div> 









