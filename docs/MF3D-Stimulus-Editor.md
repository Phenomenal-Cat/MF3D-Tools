### Contents
* [Getting started](#getting-started)<br>
* [Stimulus selection](#stimulus-selection)<br>
* [Preview panel](#preview-panel)<br>
* [Image masking](#image-masking)<br>
* [Cropping and rescaling]<br>
* [Image analysis]<br>

We provide a graphical user interface (GUI) programmed in Matlab ([`MF3D_StimEditor.m`]()) to help users of the MF3D  R1 stimulus set select, load, edit, analyse and save the images that they wish to use in their experiments. The GUI is intended to provide an easy way for users to select subsets of the 14,000 images and apply simple image manipulations without requiring them to write their own code. However, the code can easily be adapted by users who wish to perform other operations that are not currently implemented in the GUI.

---

## Getting started

After the MF3D R1 stimulus set has been downloaded from Figshare, the folders must be unzipped and reorganized into the directory structure that the GUI expects. To simplify this process, we've provided a script ([`MF3D_Reorganize.m`]()) that will perform these steps for you, which only needs to be run the first time you use the GUI and accompanying code. Follow these steps:
* Download the MF3D R1 stimulus set from Figshare by selecting the 'Download All' button
* Download or clone this GitHub repository
* Open Matlab, navigate to the 'MF3D' folder and run [`MF3D_Reorganize.m`]()
* The script requires permissions to move the code and image files around

The parameters used to generate each image in the MF3D R1 stimulus set are provided in the accompanying spreadsheets (.csv files) - one for the expression set and another for the identity set. When the GUI is initialized it first reads these data into Matlab. 

---

## Stimulus selection

The stimulus set contains 14,000 images, which is more than a single experiment is likely to need. In order to simplify the selection of a subset of the stimuli, the top panel of the GUI allows the selection by stimuli by a variety of parameters. The drop down menu at the top left allows you to select between the 'Expressions' and 'Identities' subsets, and will activate and deactivate the corresponding parameter lists. Multiple rows can be selected in each active parameter list, and the total number of images currently selected appears in the top right hand corner of the GUI.

![](https://user-images.githubusercontent.com/7523776/58993609-fe80d180-87bb-11e9-8e0f-c058aacfd92a.png)

---

## Preview panel

Whenever the stimulus selection is changed, the list of selected images is updated in the dropdown menu of the `Preview panel`. Selected images can be previewed by either selecting the file name in the dropdown menu, or using the slider to scroll through the selected images.

---

## Image masking

Each color image in the MF3D R1 stimulus set has a corresponding label map, which can be used to mask parts of the image in order to create new variations. In the `Masking panel` of the stimulus editor GUI users can select color-coded parts of the face, body and background to toggle on or off, which will update the `Preview panel` image. Additional controls to the left of the `Masking panel` provide the following functionality:
* `Apply Smoothing`: Apply image smoothing to the label map before masking the color image. This option reduces pixelated edges in the alpha transparency layer of the final images, as can be seen in the `Preview panel`. 
* `Kernel width`: Sets the width of the smoothing kernel (pixels) applied to the label map before masking. 
* `Background`: Sets the type of background to use for the output images. The default is transparent (same as input images), but it can also be set to use a solid color or a Fourier scrambled version of the original image.
* `Ellipse crop`: Displays an ellipse in the `Preview panel` that can be dragged, scaled and resized with the mouse. Pixels outside of the ellipse will have alpha transparency values of 0 (fully transparent) when saved.
* `Isotropic`: Maintain a 1:1 aspect ratio ellipse (i.e. circular) crop.
* `Cyclopean center`: this will center the cropping ellipse on the 'cyclopean eye' (indicated in the `Preview panel` by a white astrisk) by finding the centroid of each group of pixels belonging to the 'eye' label group (indicated by red astrisks) and calculating the mid-point. Turning this option on will cause the location of the avatar's body on the screen to shift as the head turns, but will keep the eyes either side of the centre on the horizontal meridian of the screen across head angles.
* `Radius (px)`: Sets the radius of the elliptical crop selection in pixels.

![](https://user-images.githubusercontent.com/7523776/58993441-8b775b00-87bb-11e9-957f-ff30e3ec5f67.png)

---

## Cropping and rescaling

---

## Image analysis

---

