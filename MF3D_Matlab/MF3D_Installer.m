%=========================== MF3D_Installer.m =============================
% Ths GUI allows users to download, unzip and re-organize the MF3D R1 
% stimulus set from Figshare.com, ready for use with the MF3D_StimEditor.m.
% See https://mf3d.readthedocs.io/en/latest/MF3D-Stimulus-Editor.html
% for further details.
%
% Written by murphyap@nih.gov
%==========================================================================

function MF3D_Installer()

%============ Open GUI window
Fig.ScreenCenter    = get(0,'screensize')/2;
Fig.WinSize         = [500,300];
Fig.WinRect         = [Fig.ScreenCenter([3,4])-Fig.WinSize/2, Fig.WinSize];
Fig.Background      = [0.75, 0.75, 0.75];
Fig.ButtonBackground = [0.9,0.9,0.9];
Fig.TextColor       = [0,0,0];
Fig.FontSize        = 14;
Fig.OffOn           = {'off','on'};
Fig.fh      = figure('name','MF3D Installer',...
                     'Color',Fig.Background,...                  % Set the figure window background color
                     'Renderer','OpenGL',...                     % Use OpenGL renderer
                     'OuterPosition', Fig.WinRect,...            % position figure window
                     'NumberTitle','off',...                     % Remove the figure number from the title
                     'Resize','off',...                          % Turn off resizing of figure
                     'Menu','none','Toolbar','none');            % Turn off toolbars and menu

%============= Display logo image
LogoURL     = 'https://user-images.githubusercontent.com/7523776/76351398-c3c83e80-62e3-11ea-8091-65b2a4cff818.png';
[FigLogo,~,FigLogoAlpha] = imread(LogoURL);
LogoSize    = size(FigLogo);
Fig.LogoAxH = axes('Units','normalized','position',[0.05,0.7,0.25,0.25],'visible','off');
Fig.LogoH   = image(FigLogo, 'ButtonDownFcn', @MF3DHelp);                                      
set(Fig.LogoH, 'AlphaData',FigLogoAlpha)
axis equal tight off;                                           

%============= Add Help buttons
Fig.HelpLabels      = {'ReadTheDocs','GitHub','Figshare','Paper','Blender add-on', 'UPBGE'};
Fig.HelpIcons       = {'Readthedocs_Icon.png', 'GitHub_Icon.png', 'Figshare_Icon.png','DOI_Icon.png','Blender_Icon.png', 'upbge_Icon.png'};
Fig.ImDir           = fullfile(cd, '..', 'docs');
Fig.WebLinks        = { 'https://mf3d.readthedocs.io/en/latest/MF3D-Stimulus-Editor.html',...
                        'https://github.com/MonkeyGone2Heaven/MF3D-Tools',...
                        'https://figshare.com/projects/MF3D_Release_1_A_visual_stimulus_set_of_parametrically_controlled_CGI_macaque_faces_for_research/64544',...
                        'https://doi.org/10.1016/j.jneumeth.2019.06.001',...
                        'https://www.blender.org/',...
                        'https://upbge.org/'};
Xpos = linspace(0.32, 0.8, numel(Fig.HelpLabels));
for n = 1:numel(Fig.HelpLabels)                  
    CallbackStr{n}  = sprintf('web(''%s'');', Fig.WebLinks{n});   
    Im = imread(fullfile(Fig.ImDir, Fig.HelpIcons{n}), 'BackgroundColor', Fig.ButtonBackground);
    Im = imresize(Im, [30, NaN]);
    Fig.ButtonH(n) = uicontrol('Style','PushButton',...
                               'TooltipString',Fig.HelpLabels{n},...
                               'Fontsize', Fig.FontSize,...
                               'Cdata', Im,...
                               'HorizontalAlignment','Left',...
                               'parent',Fig.fh,...
                               'units','normalized',...
                               'position', [Xpos(n), 0.82, 0.08, 0.14],...
                               'background',Fig.ButtonBackground,...
                               'foreground',Fig.TextColor,...
                               'callback', CallbackStr{n});
end
uicontrol('Style', 'Text', ...
          'String', 'MF3D R1 Stimulus Set Installer GUI',...
          'Fontsize', Fig.FontSize,...
          'HorizontalAlignment','Left',...
          'parent',Fig.fh,...
          'units','normalized',...
           'position', [Xpos(1), 0.65, 0.5, 0.14],...
           'background',Fig.Background,...
           'foreground',Fig.TextColor);


%============= Stimulus set parameters
Exp.Msg      = 'Downloading MF3D R1 Expression stimulus set (10.97 GB) to %s...\n';
Exp.CsvFile  = 'MF3D_ExpressionSet_Summary.csv';
Exp.CsvID    = 15330218;
Exp.Files    = {'Coo','Fear','Neutral','Threat','Tongue','Yawn','Labels'};
Exp.IDs      = [15330272, 15330389, 15330638, 15330641, 15330647, 15330698, 15330785];

Id.Msg       = 'Downloading MF3D R1 Identity stimulus set (26.75 GB) to %s...\n';
Id.CsvFile   = 'MF3D_IdentitySet_Summary.csv'; 
Id.CsvID     = 15330716;
Id.Files     = {'SD-4','SD-3','SD-2','SD-1','SD0','SD1','SD2','SD3','SD4','Labels'};
Id.IDs       = [15371396, 15371444, 15371495, 15371522, 15371528, 15371531, 15371645, 15371708, 15371753, 15371270];

Ani.Msg      = 'Downloading MF3D R1 Animated stimulus set (615 MB) to %s...\n';
Ani.Files    = {'Animations'};
Ani.CsvFile  = 'MF3D_AnimatedSet_Summary.csv';
Ani.CsvID    = 8226317;
Ani.IDs      = [8226317];

Params.SubsetDirs       = {'MF3D_Expressions', 'MF3D_Identities', 'MF3D_Animations'};
Params.SubDirs          = {'ColorImages','LabelMaps'};
Params.SubsetStructs    = {Exp, Id, Ani};
Params.SubsetSelected   = [1,1,0];
Params.URLprefix        = 'https://ndownloader.figshare.com/files/';
Params.StimExt          = {'.png', '.png', '.mp4'};
Params.NoFiles          = [2799, 10941, 80];

%============= Add download selection
Fig.UIpanel1    = uipanel('title', [], 'Fontsize', Fig.FontSize, 'background',Fig.Background, 'parent', Fig.fh, 'position', [0.05, 0.15, 0.9, 0.5]);
Fig.Labels      = {'Install directory:', 'Expression', 'Identity', 'Animation'};
Fig.Strings     = {'', '', '', ''};
Fig.Tooltips    = {'Select desitnation directory to download MF3D stimuli to.',...
                   'Download MF3D R1 Expression stimulus set (10.97 GB)?',...
                   'Download MF3D R1 Identity stimulus set (26.75 GB)?',...
                   'Download MF3D R1 Animation stimulus set (615 MB)?'};
Fig.Defaults    = [1, Params.SubsetSelected];
Fig.Style       = {'Text', 'Checkbox', 'Checkbox', 'Checkbox'};
Ypos = linspace(0.75, 0.1, numel(Fig.Labels));
for n = 1:numel(Fig.Labels)
    Fig.SelectionH(n) = uicontrol('Style',Fig.Style{n},...
                                  'String',Fig.Labels{n},...
                                  'Value',Fig.Defaults(n),...
                                  'Fontsize', Fig.FontSize,...
                                  'HorizontalAlignment','Left',...
                                  'parent',Fig.UIpanel1,...
                                  'units','normalized',...
                                  'position', [0.05, Ypos(n), 0.25, 0.15],...
                                  'background',Fig.Background,...
                                  'foreground',Fig.TextColor,...
                                  'TooltipString', Fig.Tooltips{n},...
                                  'callback', {@SetSelect, n});
    if n == 1   % Destination folder
        Fig.SelectionField = uicontrol('Style','Edit',...
                                       'Fontsize', Fig.FontSize,...
                                       'HorizontalAlignment','Left',...
                                       'parent',Fig.UIpanel1,...
                                       'units','normalized',...
                                       'position', [0.35, Ypos(n), 0.48, 0.15],...
                                       'callback', {@SelectDir, 1});
       	Fig.SelectionButton = uicontrol('Style','PushButton',...
                                       'String', '...',...
                                       'Fontsize', 12,...
                                       'background', [0.8, 0.8, 0.8],...
                                       'HorizontalAlignment','Left',...
                                       'parent',Fig.UIpanel1,...
                                       'units','normalized',...
                                       'position', [0.85, Ypos(n), 0.1, 0.15],...
                                       'callback', {@SelectDir, 2});
    else
        Fig.CsvInstalled(n) = axes('parent',Fig.UIpanel1, 'position', [0.35, Ypos(n), 0.04, 0.1], 'ylim',[0,1], 'xlim',[0,1], 'xtick', [], 'ytick', [],'color',[1,1,1]);
        Fig.Reorg(n)        = axes('parent',Fig.UIpanel1, 'position', [0.4, Ypos(n), 0.04, 0.1], 'ylim',[0,1], 'xlim',[0,1], 'xtick', [], 'ytick', [],'color',[1,1,1]);
        Fig.InstallProg(n)  = axes('parent',Fig.UIpanel1, 'position', [0.45, Ypos(n), 0.5, 0.1], 'ylim',[0,1], 'xlim',[0,1], 'box', 'off', 'xtick', [], 'ytick', []);
        Fig.PatchH(n)       = patch([0,0,0,0],[0,1,1,0], [0,1,1,0], 'facecolor', [0,0,1], 'edgecolor', 'none');
        Fig.CompleteH(n)    = uicontrol('Style','Text', 'String', '0 %','Fontsize', 12, 'parent',Fig.UIpanel1, 'HorizontalAlignment','Left', 'position', [0.92, Ypos(n), 0.08, 0.15]);
        if Fig.Defaults(n) == 0
            set(Fig.PatchH(n), 'facecolor', [0.5,0.5,0.5]);
            set(Fig.InstallProg(n), 'color', [0.75,0.75,0.75]);
        end
    end
    
end

%============= Add download buttons
Fig.ButtonLabels    = {'Download', 'Reorganize', 'Exit'};
Fig.ButtonEnabled   = [0, 0, 1];
OffOn               = {'off','on'};
Xpos = linspace(0.1, 0.7, numel(Fig.ButtonLabels));
for n = 1:numel(Fig.ButtonLabels)
    Fig.OptionH(n) = uicontrol('Style', 'PushButton',...
                                  'String', Fig.ButtonLabels{n},...
                                  'Enable', OffOn{Fig.ButtonEnabled(n)+1},...
                                  'Fontsize', Fig.FontSize,...
                                  'HorizontalAlignment','Left',...
                                  'parent',Fig.fh,...
                                  'units','normalized',...
                                  'position', [Xpos(n), 0.03, 0.2, 0.1],...
                                  'callback', {@OptionButton, n});
end



%% ===================== Subfunctions and callbacks =======================

    %========= Toggle stimulus subset selection
    function SetSelect(hObj, Evnt, Indx)
        if get(hObj, 'value') == 1
            set(Fig.InstallProg(Indx), 'color', [1,1,1]);
            set(Fig.PatchH(Indx), 'facecolor', [0,0,1]);
            
        elseif get(hObj, 'value') == 0
            set(Fig.InstallProg(Indx), 'color', [0.75,0.75,0.75]); 
            set(Fig.PatchH(Indx), 'facecolor', [0.5,0.5,0.5]);
            
        end
    end

    %========= Select install destination
    function SelectDir(hObj, Evnt, Indx)
        switch Indx
            case 1
                path = get(hObj, 'string');
                if ~isdir(path)
                    warndlg('Invalid path name. Please select path to install MF3D stimulus folder');
                	path = uigetdir('Select path to install MF3D R1 stimuli in:');
                    set(Fig.SelectionField, 'string', path);
                end

            case 2 % Button select
                path = uigetdir('Select path to install MF3D R1 stimuli in:');
                set(Fig.SelectionField, 'string', path);
        end
        CheckPath(path);
        
    end

    %========= Logo clicked
    function MF3DHelp(hObj, Evnt, Indx)
        CallbackStr(3);
    end

    %========= Check for previous installations
    function CheckPath(path)
        MF3D_root       = fullfile(path, 'MF3D_R1');
        if isdir(MF3D_root)                                                 % If MF3D is already installed...
            set(Fig.SelectionField, 'backgroundcolor', [0,1,0]);            % Set field background color
            Params.SubsetSelected = cell2mat(get(Fig.SelectionH(2:4), 'value'));
            
            for s = 1:numel(Params.SubsetSelected)                          % For each stimulus subset...
                SubsetDir = fullfile(MF3D_root, Params.SubsetDirs{s});      % Get subset directory
                if isdir(SubsetDir)                                         % If subset directory already exists...
                    
                    %===== Check if .csv file already exists
                    if exist(fullfile(SubsetDir, Params.SubsetStructs{s}.CsvFile))  
                        set(Fig.CsvInstalled(s+1), 'color', [0,1,0]);               
                    else
                        set(Fig.CsvInstalled(s+1), 'color', [1,1,1]);
                    end
                    
                    %===== Check if downloaded content has been reorganized
                    if isdir(fullfile(SubsetDir, Params.SubDirs{1}))
                        set(Fig.Reorg(s+1), 'color', [0,1,0]); 
                        AllStim = dir(fullfile(SubsetDir, Params.SubDirs{1}, ['*', Params.StimExt{s}]));
                    else
                        set(Fig.Reorg(s+1), 'color', [1,1,1]);
                        AllStim = 0;
                    end
                    Prop = numel(AllStim)/Params.NoFiles(s);
                    UpdateProgress(s, Prop);
                end
     
            end
        else
            set(Fig.SelectionField, 'backgroundcolor', [1,1,1]);    % Set field background color
            
        end
        Params.RootDir = fullfile(path, 'MF3D_R1');
        set(Fig.OptionH(1), 'enable', Fig.OffOn{2});                    % Enable download button
    end

    %========= Option selection
    function OptionButton(hObj, Evnt, Indx)
        Params.SubsetSelected = cell2mat(get(Fig.SelectionH(2:4), 'value'));        % Check which stimulus subsets are selected
        switch Indx
            case 1 % Download
                for Subset = 1:3                                                    % For each stimulus subset...
                    if Params.SubsetSelected(Subset) == 1                           % If subset was selected in GUI...
                        DownloadMF3D(Subset);
                    end
                end
                
            case 2 % Reorganize
                for Subset = 1:3                                                    % For each stimulus subset...
                    if Params.SubsetSelected(Subset) == 1                           % If subset was selected in GUI...
                        ReorganizeMF3D(Subset);
                    end
                end
                
            case 3 % Exit
                close(Fig.fh);
        end
    
    end

    %======== Update GUI download progress bars
    function UpdateProgress(BarIndx, Prop)
        set(Fig.PatchH(BarIndx+1), 'xdata', [0, 0, Prop, Prop]);
        set(Fig.CompleteH(BarIndx+1), 'string', sprintf('%d %%', Prop*100));
    end

    %======== Download selected stimulus subsets
    function DownloadMF3D(Subset)
        
        %==== Create sub folder
        Dest = fullfile(Params.RootDir, Params.SubsetDirs{Subset}); % Get destination directory
        if ~isfolder(Dest)                                          % If destination directory doesn't exist...
            success     = mkdir(Dest);                              % Create destination directory
        end
        
        %==== Download CSV file
        CSVfile = fullfile(Dest, Params.SubsetStructs{Subset}.CsvFile);
        if ~exist(CSVfile)
            websave(CSVfile, sprintf('%s%d', Params.URLprefix, Params.SubsetStructs{Subset}.CsvID));
            set(Fig.CsvInstalled(Subset), 'color', [0,1,0]);  
        end
        
        %==== Download stimulus files
        for n = 1:numel(Params.SubsetStructs{Subset}.IDs)
            Params.SubsetStructs{Subset}.URLs{n}  = sprintf('%s%d', Params.URLprefix, Params.SubsetStructs{Subset}.IDs(n));
        end
        for f = 1:numel(Params.SubsetStructs{Subset}.URLs)
            if ~isfolder(fullfile(Dest, Params.SubsetStructs{Subset}.Files{f}))
                String          = sprintf('Downloading %s %s (%d / %d)...', Params.SubsetDirs{Subset}, Params.SubsetStructs{Subset}.Files{f}, f, numel(Params.SubsetStructs{Subset}.URLs));
                UpdateProgress(Subset, f/numel(Params.SubsetStructs{Subset}.URLs));
                Params.SubsetStructs{Subset}.Filenames{f} = unzip(Params.SubsetStructs{Subset}.URLs{f}, Dest);
            else
                fprintf('Folder ''%s'' already exists. Skipping!\n', fullfile(Dest, Params.SubsetStructs{Subset}.Files{f}));
            end
        end
        fprintf('%s stimulus set download complete!\n', Params.SubsetDirs{Subset});
    end

    %========= REorganize downloaded files
    function ReorganizeMF3D(Subset)
        
        if ~isdir(Params.SubsetDirs{Subset})
            mkdir(Params.SubsetDirs{Subset});
        end
        for f = 1:numel(Params.SubsetStructs{Subset}.Files)
            SourceDir = fullfile(MF3D_ExpDir, Params.SubsetStructs{Subset}.Files{f});
            movefile(SourceDir, MF3D_ExpDirRGB)
        end
        if ~isfolder(MF3D_ExpDirLabel)
            mkdir(MF3D_ExpDirLabel);
        end
        SourceDir = fullfile(MF3D_ExpDir, ExpressionFiles{exp+1});
        movefile(SourceDir, MF3D_ExpDirLabel);

    end

end