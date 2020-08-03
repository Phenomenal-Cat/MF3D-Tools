#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
MF3D_AutoSegment.py

Created 06/01/2020

@author: Aidan Murphy (NIF, NIMH)
"""

import slicer
import vtk
import os


RootDir     = '/Volumes/Seagate Backup 3/NIF_StaffScientist/MRI datasets/MacaqueInfant/iMF3D/'
InputDir    = os.path.join(RootDir, '01_MRIVolumes')
OutputDir   = os.path.join(RootDir, '02_Segmentations')
TestFile    = os.path.join(InputDir, '001_12months_T1_ORIG.nrrd')

# Load volume and get info
loadedVolumeNode = slicer.util.loadVolume(TestFile, returnNode = True)
vol=slicer.util.getNode('*ORIG')
VoxelSize = vol.GetSpacing()
Origin = vol.GetOrigin()
VolDims = vol.GetImageData().GetDimensions()
 
# Create segmentation
segmentationNode = slicer.mrmlScene.AddNewNodeByClass("vtkMRMLSegmentationNode")
segmentationNode.CreateDefaultDisplayNodes() # only needed for display
segmentationNode.SetReferenceImageGeometryParameterFromVolumeNode(loadedVolumeNode)
addedSegmentID = segmentationNode.GetSegmentation().AddEmptySegment("skin")

# Create segment editor to get access to effects
segmentEditorWidget = slicer.qMRMLSegmentEditorWidget()
segmentEditorWidget.setMRMLScene(slicer.mrmlScene)
segmentEditorNode = slicer.mrmlScene.AddNewNodeByClass("vtkMRMLSegmentEditorNode")
segmentEditorWidget.setMRMLSegmentEditorNode(segmentEditorNode)
segmentEditorWidget.setSegmentationNode(segmentationNode)
segmentEditorWidget.setMasterVolumeNode(loadedVolumeNode)


# Thresholding
segmentEditorWidget.setActiveEffectByName("Threshold")
effect = segmentEditorWidget.activeEffect()
effect.setParameter("MinimumThreshold","35")
effect.setParameter("MaximumThreshold","695")
effect.self().onApply()

# Smoothing
segmentEditorWidget.setActiveEffectByName("Smoothing")
effect = segmentEditorWidget.activeEffect()
effect.setParameter("SmoothingMethod", "MEDIAN")
effect.setParameter("KernelSizeMm", 3)
effect.self().onApply()

# Clean up
segmentEditorWidget = None
slicer.mrmlScene.RemoveNode(segmentEditorNode)

# Make segmentation results visible in 3D
segmentationNode.CreateClosedSurfaceRepresentation()

# Make sure surface mesh cells are consistently oriented
surfaceMesh = segmentationNode.GetClosedSurfaceRepresentation(addedSegmentID)
normals = vtk.vtkPolyDataNormals()
normals.AutoOrientNormalsOn()
normals.ConsistencyOn()
normals.SetInputData(surfaceMesh)
normals.Update()
surfaceMesh = normals.GetOutput()


# Save model to STL file
def exportModel():
    writer = vtk.vtkSTLWriter()
    writer.SetInputData(surfaceMesh)
    writer.SetFileName(os.path.join(OutputDir, 'TEST.stl'))
    writer.Update()

# Save segmentation label map to .nrrd / .nii volume
def exportLabelmap():
    segmentationNode = slicer.mrmlScene.GetFirstNodeByClass("vtkMRMLSegmentationNode")
    referenceVolumeNode = slicer.mrmlScene.GetFirstNodeByClass("vtkMRMLScalarVolumeNode")
    labelmapVolumeNode = slicer.mrmlScene.AddNewNodeByClass('vtkMRMLLabelMapVolumeNode')
    slicer.modules.segmentations.logic().ExportVisibleSegmentsToLabelmapNode(segmentationNode, labelmapVolumeNode, loadedVolumeNode)
    filepath = OutputDir + "/" + referenceVolumeNode.GetName()+"-label.nrrd"
    slicer.util.saveNode(labelmapVolumeNode, filepath)
    slicer.mrmlScene.RemoveNode(labelmapVolumeNode.GetDisplayNode().GetColorNode())
    slicer.mrmlScene.RemoveNode(labelmapVolumeNode)
    slicer.util.delayDisplay("Segmentation saved to "+filepath)