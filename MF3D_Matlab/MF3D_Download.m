
%========================== MF3D_Download.m =============================
% Ths Matlab function downloads and unzips the MF3D R1 stimulus set from 
% Figshare.com, ready for reorganization of directories and use with the
% MF3D_StimEditor.m.
%
% See https://github.com/MonkeyGone2Heaven/MF3D-Tools/wiki/MF3D-Stimulus-Editor
% for further details.
%
% Written by murphyap@nih.gov
%==========================================================================

Destination     = uigetdir(cd, 'Select directory to create MF3D R1 in');
MF3D_root       = fullfile(Destination, 'MF3D_R1');
success         = mkdir(MF3D_root);

Selection       = questdlg('Which subsets of MF3D R1 do you want to download?', ...
                         'Select subsets', ...
                         'Expression', 'Identity', 'Both', 'Both');

%============= Download expressions
if any(strcmpi(Selection, {'Expression', 'Both'}))
    MF3D_ExpDir     = fullfile(MF3D_root, 'MF3D_Expressions');
    success         = mkdir(MF3D_ExpDir);
    fprintf('Downloading MF3D R1 Expression stimulus set (26.75 GB) to %s...\n', MF3D_ExpDir);
    ExpressionFiles = {'Summary.csv','Coo','Fear','Neutral','Threat','Tongue','Yawn','Labels'};
    ExpressionURLs  = {'https://ndownloader.figshare.com/files/15330218',...
                       'https://ndownloader.figshare.com/files/15330272',...
                       'https://ndownloader.figshare.com/files/15330389',...
                       'https://ndownloader.figshare.com/files/15330638',...
                       'https://ndownloader.figshare.com/files/15330641',...
                       'https://ndownloader.figshare.com/files/15330647',...
                       'https://ndownloader.figshare.com/files/15330698',...
                       'https://ndownloader.figshare.com/files/15330785'};

    wbh = waitbar(0);
    for exp = 1:numel(ExpressionURLs)
        String          = fprintf('Downloading and unzipping expression ''%s'' (%d / %d)...', ExpressionFiles{exp}, exp, numel(ExpressionURLs));
        waitbar(exp/ numel(ExpressionURLs), wbh, String);
        ExpFilenames{exp} = unzip(ExpressionURLs{exp}, MF3D_ExpDir);
    end
    fprintf('MF3D R1 Expression stimulus set download complete!\n')
end

%============= Download identities
if ny(strcmpi(Selection, {'Identity', 'Both'}))
    MF3D_IdDir     = fullfile(MF3D_root, 'MF3D_Identities');
    success         = mkdir(MF3D_IdDir);
    fprintf('Downloading MF3D R1 Identity stimulus set (26.75 GB) to %s...\n', MF3D_IdDir);
    IdentityFiles = {'Summary.csv','SD-4','SD-3','SD-2','SD-1','SD0','SD1','SD2','SD3','SD4','Labels'};
    IdentityURLs  = {  'https://ndownloader.figshare.com/files/15330716',...
                       'https://ndownloader.figshare.com/files/15371396',...
                       'https://ndownloader.figshare.com/files/15371444',...
                       'https://ndownloader.figshare.com/files/15371495',...
                       'https://ndownloader.figshare.com/files/15371522',...
                       'https://ndownloader.figshare.com/files/15371528',...
                       'https://ndownloader.figshare.com/files/15371531',...
                       'https://ndownloader.figshare.com/files/15371645',...
                       'https://ndownloader.figshare.com/files/15371708',...
                       'https://ndownloader.figshare.com/files/15371753',...
                       'https://ndownloader.figshare.com/files/15371270'};
    for id = 1:numel(IdentityURLs)
        String          = fprintf('Downloading and unzipping identity ''%s'' (%d / %d)...', IdentityFiles{id}, id, numel(IdentityURLs));
        waitbar(id/numel(IdentityURLs), wbh, String);
        IdFilenames{id} = unzip(IdentityURLs{id}, MF3D_IdDir);
    end
    fprintf('MF3D R1 Identity stimulus set download complete!\n')
end
