
%========================== MF3D_Reorganize.m =============================
% Ths Matlab function 
%
% See https://github.com/MonkeyGone2Heaven/MF3D-Tools/wiki/MF3D-Stimulus-Editor
% for further instructions.
%
% Written by murphyap@nih.gov
%==========================================================================


Params.RootDir          = uigetdir(cd, 'Select directory containing downloaded MF3D R1 .zip files');

Params.ExpDir           = fullfile(Params.RootDir, 'MF3D_Expressions');
Params.ExpSummaryFile   = fullfile(Params.ExpDir, 'MF3D_ExpressionSet_Summary.csv');
Params.IdDir            = fullfile(Params.RootDir, 'MF3D_Identities');
Params.IdSummaryFile    = fullfile(Params.IdDir, 'MF3D_IdentitySet_Summary.csv');