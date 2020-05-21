### Overview
We provide a graphical user interface (GUI) programmed in Matlab (MF3D_ParamEstimtion.m) to allow collaborators to estimate the temporal dynamics of facial motion from video footage of macaque monkeys. The GUI is intended to be used on short video clips that have been pre-selected as containing an individual facial movement, expression or vocalization of interest. The GUI requires users to scroll through the clip and manually input information about the various facial parameters, either by tracking the position of facial landmarks across frames, or by estimating their change over time subjectively. 


The GUI saves the time courses for all tracked parameters to a spreadsheet (.csv format). While the avatar Blender file is not yet publicly released, collaborators can send us their time course data, which we read into Blender via a Python script and apply as keyframes for generating video animations of the macaque avatar.


