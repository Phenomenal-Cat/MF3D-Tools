# RTMF3D: Real-Time Macaque Face 3D

[TOC]

---

### Adaptive stimulus optimization

([DiMattina & Zhang, 2013](https://doi.org/10.3389/fncir.2013.00101)).

genetic algorithms ([Forrest, 1993](DOI: 10.1126/science.8346439))

Application of this approach to studying single unit responses in the macaque brain was pioneered by [Connor](https://krieger.jhu.edu/mbi/directory/ed-connor/) and colleagues, who used a genetic algorithm to iteratively adapt 3D visual stimuli in order to maximize firing rates of neurons in macaque inferotemporal (IT) cortex ([Yamane et al., 2008](https://doi.org/10.1038/nn.2202); [Hung et al., 2012](https://doi.org/10.1016/j.neuron.2012.04.029); [Vaziri et al., 2014](https://doi.org/10.1016/j.neuron.2014.08.043)). Variations of this approach have since been used to study the visual preferences of neurons in the macaque 'face patch' regions of IT cortex ([Chang & Tsao, 2017](https://doi.org/10.1016/j.cell.2017.05.011); [Ponce et al., 2019](https://doi.org/10.1016/j.cell.2019.04.005)). Similarly, 

Leopold et al., 2006; 



---

### UPBGE

We utilize the [UPBGE](https://upbge.org/) Blender game engine of the open-source 3D graphics software [Blender](www.blender.org) to parametrically vary multiple aspects of facial appearance in real-time, based on online analysis of neural spiking responses. On each screen refresh interval, UPBGE updates the parameters of the virtual scene based on an incoming vector of float values vreceived from the experimental control computer via [UDP]() connection.  



A stimulus subspace is defined by the selection of N dimensions that affect facial appearance in the pixel-domain (see **Table 1**).



| Dim. | Category              | Description                         | Unit    | Range   |
| ---- | --------------------- | ----------------------------------- | ------- | ------- |
| 1    | Spatial - Allocentric | Body azimuth angle                  | Degrees |         |
| 2    | Spatial - Allocentric | Body elevation angle                | Degrees |         |
| 3    | Spatial - Allocentric | Head azimuth angle                  | Degrees |         |
| 4    | Spatial - Allocentric | Head elevation angle                | Degrees |         |
| 5    | Spatial - Allocentric | Eye gaze azimuth angle              | Degrees |         |
| 6    | Spatial - Allocentric | Eye gaze elevation angle            | Degrees |         |
| 7    | Social                | Eye lid closure                     | Percent | 0 - 100 |
| 8    | Social                | Pupil dilation                      | Percent | 0 - 100 |
| 9    | Social                | Brow raise                          | Percent | 0 - 100 |
| 10   | Social                | Mouth open                          | Percent | 0 - 100 |
| 11   | Social                | Lip retraction - pout               | Percent | 0 - 100 |
| 12   | Social                | Ear flap                            | Percent | 0 - 100 |
| 13   | Face shape            | Principal component 1               | S.D.    | +/- 3   |
| 14   | Face shape            | Principal component 2               | S.D.    | +/- 3   |
| 15   | Face shape            | Face shape - principal component 3  | S.D.    | +/- 3   |
| 16   | Face shape            | Face shape - principal component 4  | S.D.    | +/- 3   |
| 17   | Face shape            | Face shape - principal component 5  | S.D.    | +/- 3   |
| 18   | Face shape            | Face shape - principal component 6  | S.D.    | +/- 3   |
| 19   | Face shape            | Face shape - principal component 7  | S.D.    | +/- 3   |
| 20   | Face shape            | Face shape - principal component 8  | S.D.    | +/- 3   |
| 21   | Face shape            | Face shape - principal component 9  | S.D.    | +/- 3   |
| 22   | Face shape            | Face shape - principal component 10 | S.D.    | +/- 3   |
| 23   | Texture               | Lighting direction                  |         |         |
| 24   |                       |                                     |         |         |

