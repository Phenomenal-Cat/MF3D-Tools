
#====================== MF3D_LoadStaticImages ======================
# This script demonstrates how to load a subset of the MF3D static 
# images, perform edits (crop, background change, mask, etc.) and
# output the edited files or a movie of randomized stimulus presentation. 
#===================================================================

import bpy
import os
import random

#======= Construct list of filenames matching selection criteria
def GetFilenames(PCas, PCbs, Angs, SDs, Haz, Hel):
   Filenames = []
   for el in Hel:
      for az in Haz:
         for PCa in PCas:
            for PCb in PCbs:
               for ang in Angs:
                  for sd in SDs:
                     if (PCa == PCb):
                        Filenames.append('MF3D_PC%d=%.2f_Haz%d_Hel%d_Gaz0_Gel0_RGBA.png' % (PCa, sd, az, el))
                     elif (PCa < PCb):
                        Filenames.append('MF3D_PC%d+PC%d_(%.1fdeg)=%.2f_Haz%d_Hel%d_Gaz0_Gel0_RGBA.png' % (PCa, PCb, ang, sd, az, el))
                     elif (PCa > PCb):
                        Filenames.append('MF3D_PC%d-PC%d_(%.1fdeg)=%.2f_Haz%d_Hel%d_Gaz0_Gel0_RGBA.png' % (PCa, PCb, ang, sd, az, el))
                                
   return Filenames

#======= Load image files to Video Sequence Editor
def LoadImagesToVSE(ImDir, Filenames, FrameStart, StimDurfr):
    
   ImChannel = 2
   for f in range(0, len(Filenames)):
        Fullfile = os.path.join(ImDir, Filenames[f])
        if os.path.isfile(Fullfile):
            seq = SE.sequences.new_image("Stim{:03d}".format(f+1), Fullfile, ImChannel, FrameStart[f])    # Add image
            seq.frame_final_duration = StimDurfr
            if ImCrop == 1:
                seq.use_crop = True
                GetCropDims(seq, Xdim, Ydim)
                
            seq.use_translation = True
            seq.blend_type = 'ALPHA_OVER'
            
        else:
            print("File {} was not found! Skipping...".format(Fullfile))
            break

#======== Calculate frame start and end position for each image
def GetFramePos(Filenames, StimDurMs, ISI):
    FPS         = S.render.fps
    StimDurfr   = round(StimDurMs/10**3*FPS, 0)
    ISIfr       = round(ISI/10**3*FPS)
    FrameStart  = []
    for f in range(0, len(Filenames)):
        FrameStart.append(f*(StimDurfr + ISIfr)+1)
    
    return FrameStart, StimDurfr

#======== Calculate crop dimensions
def GetCropDims(seq, Xdim, Ydim):
    InputX = 3840
    InputY = 2160
    OffsetsX = (InputX-Xdim)/2
    OffsetsY = (InputY-Ydim)/2
    seq.crop.min_x = OffsetsX
    seq.crop.max_x = OffsetsX
    seq.crop.max_y = OffsetsY
    seq.crop.min_y = OffsetsY
    
    
#======== Add background and foreground images    
def AddImageOverlays(BackgroundRGB, BkgIm=[], FrgIm=[]):
    Bkg     = SE.sequences.new_effect('Background', 'COLOR', 1, 1, frame_end = S.frame_end)       # Background
    SE.sequences_all["Background"].color = (BackgroundRGB);
    
    #Frg     = SE.sequences.new_image('Foreground', FrgIm, 3, 1)                      # Foreground
    #SE.sequences_all["Foreground"].blend_type               = 'ALPHA_OVER'
    #SE.sequences_all["Foreground"].frame_final_end          = len(FrameOrder)+1


#======= Set stimulus selection criteria
ImDir = '/Volumes/Seagate Backup 3/NIH_Stimuli/MF3D_R1/MF3D_Identities/ColorImages/'
OutputDir = '/Volumes/Seagate Backup 3/NIH_Stimuli/AvatarRenders/FlashFaceDistortion/'
Haz  = [0]
Hel  = [0]
SDs  = [-2, 2]
Angs = [22.5, 45, 67.5]
PCas = [1,2,3,4,5]
PCbs = [1,2,3,4,5]
MovieName = 'FFDE_macaque_Haz%d_SD%d_random.mp4' % (Haz[0], SDs[1])

#======= Set stimulus appearance
BackgroundRGB       = (0.5, 0.5, 0.5)
StimDurMs  = 250
ISI        = 0
ImCrop     = 1
ImMask     = 0
ImResize   = 1
Xdim       = 1000
Ydim       = 1000

#======= Prepare Video Sequence Editor
S  = bpy.context.scene
if not S.sequence_editor:                                   # If sequence editor doesn't exist...
    SE = S.sequence_editor_create()                         # Create sequence editor
else:
    SE = bpy.context.scene.sequence_editor
#S.render.image_settings.file_format    = 'H264'            # Set render format
S.render.image_settings.file_format     = 'FFMPEG'          # Set render format
S.render.ffmpeg.audio_codec             = 'MP3'                 
S.render.ffmpeg.format                  = 'MPEG4'
S.render.ffmpeg.codec                   = 'H264'
S.render.ffmpeg.constant_rate_factor    = 'PERC_LOSSLESS'
    
#======= Set output parameters
if ImResize == 1:
    S.render.resolution_x           = Xdim
    S.render.resolution_y           = Ydim
else:
    S.render.resolution_x           = 3840
    S.render.resolution_y           = 2160
    
S.render.resolution_percentage  = 100
S.render.fps                    = 60
S.render.fps_base               = 1.0
S.frame_start                   = 1             # Which frame number to start animation render from


#======= Apply functions
Filenames = GetFilenames(PCas, PCbs, Angs, SDs, Haz, Hel)           # Get list of image filenames
random.shuffle(Filenames)                                           # Randomize image order
[FrameStart, StimDurfr] = GetFramePos(Filenames, StimDurMs, ISI)    # Get frame position for each stimulus
S.frame_end = FrameStart[-1]+StimDurfr                              # Set total animation length
LoadImagesToVSE(ImDir, Filenames, FrameStart, StimDurfr)            # Add images to VSE
AddImageOverlays(BackgroundRGB)

#======= Export as movie
S.render.filepath   = os.path.join(OutputDir,  MovieName)       # Set output filename
#bpy.ops.render.render(animation = True)                                         # Render animation 