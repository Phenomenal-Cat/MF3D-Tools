function MF3D_Reorganize(MF3D_root)

%========================== MF3D_Reorganize.m =============================
% Ths Matlab function reorganizes the downloaded image files in the MF3D R1
% stimulus set into the directory structure expected by the MF3D_StimEditor
% GUI. See https://github.com/MonkeyGone2Heaven/MF3D-Tools/wiki/MF3D-Stimulus-Editor
% for further details.
%
% Written by murphyap@nih.gov
%==========================================================================

if ~exist('MF3D_root','var') || ~isfolder(MF3D_root)
    MF3D_root           = uigetdir(cd, 'Select MF3D_R1 download directory');
end
MF3D_ExpDir         = fullfile(MF3D_root, 'MF3D_Expressions');
MF3D_ExpDirRGB      = fullfile(MF3D_ExpDir, 'ColorImages');
MF3D_ExpDirLabel    = fullfile(MF3D_ExpDir, 'LabelMaps');
MF3D_IdDir          = fullfile(MF3D_root, 'MF3D_Identities');
MF3D_IdDirRGB       = fullfile(MF3D_IdDir, 'ColorImages');
MF3D_IdDirLabel     = fullfile(MF3D_IdDir, 'LabelMaps');

IdentityFiles       = {'SD-4','SD-3','SD-2','SD-1','SD0','SD1','SD2','SD3','SD4','Labels'};
ExpressionFiles     = {'Coo','Fear','Neutral','Threat','Tongue','Yawn','Labels'};

%========= Move expression files
if ~isfolder(MF3D_ExpDirRGB)
    mkdir(MF3D_ExpDirRGB);
end
for exp = 1:numel(ExpressionFiles)-1
    SourceDir = fullfile(MF3D_ExpDir, ExpressionFiles{exp});
    if ~isfolder(SourceDir)
        error('MF3D directory ''%s'' was not found!\nComplete download or update MF3D root directory.', SourceDir);
    end
    movefile(SourceDir, MF3D_ExpDirRGB)
end
if ~isfolder(MF3D_ExpDirLabel)
    mkdir(MF3D_ExpDirLabel);
end
SourceDir = fullfile(MF3D_ExpDir, ExpressionFiles{exp+1});
movefile(SourceDir, MF3D_ExpDirLabel);

%========= Move identity files
if ~isfolder(MF3D_IdDirRGB)
    mkdir(MF3D_IdDirRGB);
end
for id = 1:numel(IdentityFiles)-1
    SourceDir = fullfile(MF3D_IdDir, IdentityFiles{id});
    if ~isfolder(SourceDir)
        error('MF3D directory ''%s'' was not found!', SourceDir);
    end
    movefile(SourceDir, MF3D_IdDirRGB)
end
if ~isfolder(MF3D_IdDirLabel)
    mkdir(MF3D_IdDirLabel);
end
SourceDir = fullfile(MF3D_IdDir, IdentityFiles{id+1});
movefile(SourceDir, MF3D_IdDirLabel);
