
#====================== MF3D_MaskImages.py ======================
# This script demonstrates how to use the MF3D label maps to mask
# stimulus images in the Blender compositor.


import bpy
import os
from mathDynamics import MathDynamics

#def maskImage(ImFile, LabelFile, LabelSelection):

#======== Face part settings
LabelNames      = ['Background', 'Eyes', 'InnerEye', 'OuterEye', 'Head', 'Ears', 'Body', 'Nose', 'OuterMouth', 'InnerMouth']
LabelIDs        = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]


LabelSelection  = [1,2,3, 7, 8, 9]  # These parts will be visible
DemoImFilePrefix = 'MF3D_Mean_Haz0_Hel0_Gaz0_Gel0'
MF3Ddir = '/Volumes/Seagate Backup 3/NIH_Stimuli/MF3D_R1/MF3D_Identities/'
ImFile = os.path.join(MF3Ddir, 'ColorImages', DemoImFilePrefix + '_RGBA.png')
LabelFile = os.path.join(MF3Ddir, 'LabelMaps', DemoImFilePrefix + '_label.hdr')

#======== Prepare compositing
bpy.context.scene.use_nodes = True          # Enable nodes
tree = bpy.context.scene.node_tree          # Get node tree handle
for node in tree.nodes:                     # Remove current nodes
    tree.nodes.remove(node)
links = tree.links                          # create link nodes
    
#===== create input RGBA image node
image_node = tree.nodes.new(type='CompositorNodeImage')
bpy.data.images.load(ImFile, check_existing=False)
ImageIm = os.path.split(ImFile)
image_node.image = bpy.data.images[ImageIm[1]]
image_node.location = 0,400

#===== create input Label image node
label_node = tree.nodes.new(type='CompositorNodeImage')
bpy.data.images.load(LabelFile, check_existing=False)
LabelIm = os.path.split(LabelFile)
label_node.image = bpy.data.images[LabelIm[1]]
label_node.location = 0,0

#===== create output node
comp_node = tree.nodes.new('CompositorNodeComposite')   
comp_node.location = 600,400
link = links.new(image_node.outputs[0], comp_node.inputs[0])

#===== create math node
#math_node = tree.nodes.new(type='CompositorNodeMath')
MathDynamics()
math_node = tree.nodes.new(type='MathsDynamic')
#math_node.selectOperator = 'ADD'
math_node.inputSockets = len(LabelSelection)+1
math_node.location = 400, 200
link = links.new(math_node.outputs[0], comp_node.inputs[1])

#===== create ID mask nodes for each label
link = links.new(image_node.outputs[0], comp_node.inputs[0])
n = 0
for l in LabelSelection:
    mask_node = tree.nodes.new(type='CompositorNodeIDMask')
    mask_node.index = l
    mask_node.location = 200, 400-(n*150)
    link = links.new(label_node.outputs[0], mask_node.inputs[0])
    link = links.new(mask_node.outputs[0], math_node.inputs[n])
    n=n+1



