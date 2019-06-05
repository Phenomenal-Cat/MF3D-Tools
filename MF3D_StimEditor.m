
%========================== MF3D_StimEditor.m =============================
% Ths Matlab function launches a graphical user interface (GUI) to simplify
% the selection, editing and saving of visual stimuli from the MF3D R1
% database. It must be run from the 'MF3D_Code' folder inside the MF3D folder
% in order for relative paths to work. Custom image processing operations
% can be added by adding code inside the 'ProcessAndSaveImages'subfunction.
%
% Written by murphyap@nih.gov
%==========================================================================

function MF3D_StimEditor()

%================== Load summary data
Params.SubSets          = {'Expressions','Identities'};
Params.RootDir          = fileparts(fileparts(mfilename('fullpath')));
Params.ExpDir           = fullfile(Params.RootDir, 'MF3D_Expressions');
Params.IdDir            = fullfile(Params.RootDir, 'MF3D_Identities');
Params.SetDirs          = {Params.ExpDir, Params.IdDir};
Params.OutputDir        = fullfile(Params.RootDir, 'EditedStim');

Params.IdSummaryFile    = fullfile(Params.IdDir, 'MF3D_IdentitySet_Summary.csv');
Params.Table        	= readtable(Params.IdSummaryFile);
Params.IdentityLevels   = unique(Params.Table.IdentityLevel(Params.Table.IdentityLevel~=0));
Params.PCcombos         = unique(Params.Table.PCcombo);
Params.PCangles         = unique(Params.Table.PCangle);
Params.PCangles         = Params.PCangles(Params.PCangles>0);
Params.ExpSummaryFile   = fullfile(Params.ExpDir, 'MF3D_ExpressionSet_Summary.csv');
Params.Table        	= readtable(Params.ExpSummaryFile);
Params.Azimuths         = -90:10:90;
Params.Elevations       = unique(Params.Table.Elevation);
Params.Expressions      = unique(Params.Table.Expression);
Params.ExpMag           = unique(Params.Table.ExpLevel);

%========== Set masking parameters
Params.Mask.Labels              = {'Background', 'Eyes', 'Inner eye', 'Outer eye', 'Head', 'Ears', 'Body', 'Nose', 'Outer mouth', 'Inner mouth'};
Params.Mask.Selected            = [0, ones(1, numel(Params.Mask.Labels)-1)];
Params.Mask.Colors              = jet(numel(Params.Mask.Labels));
Params.Mask.TextColor           = [1,1,1,0,0,0,0,0,0,1];
Params.Mask.SmoothEnable        = exist('imgaussfilt.m','file')>0;
Params.Mask.Smoothing           = 0;
Params.Mask.SmoothSigma         = 6;
Params.Mask.CenterCyclops       = 0;
Params.Mask.EllipseIso          = 1;
Params.Mask.EllipseRadius       = 800;
Params.Mask.BackgroundIndx      = 1;

Params.Selected.SubSet          = 1;
Params.Selected.Expressions     = 1;
Params.Selected.ExpLevels       = 1;
Params.Selected.Azimuths        = 1;
Params.Selected.Elevations      = 1;
Params.Selected.IdentityLevels  = 1;
Params.Selected.PCcombos        = 1;
Params.Selected.PCangles        = 2;
Params.TotalStim                = 1;
Actions.NormalizeLum          	= 0;
Actions.ResizeImages            = 0;
Actions.Greyscale               = 0;
Actions.CustomProcess           = 0;
GetImageDirs();

%================== Open GUI window
Fig.MajorFontsize = 12;
Fig.MinorFontsize = 10;
Fig.fh      = figure('Name','MF3D Stim Editor','units','normalized','position',[0,0,0.7, 1],'Menu','none','Toolbar','none');
Fig.ph      = uipanel('position',[0.01,0.67,0.8,0.32],'title','Stimulus selection','fontsize', Fig.MajorFontsize);
Fig.ph2     = uipanel('position',[0.01,0.34,0.35,0.32],'title','Preview','fontsize', Fig.MajorFontsize);
Fig.ph3     = uipanel('position',[0.37,0.34,0.6,0.32],'title','Masking','fontsize', Fig.MajorFontsize);
Fig.ph4     = uipanel('position',[0.01,0.01,0.8,0.32],'title','Editing','fontsize', Fig.MajorFontsize);
Fig.bph     = uipanel('position',[0.82,0.67,0.15,0.32],'title','Actions','fontsize', Fig.MajorFontsize);
Fig.Labels  = {'Expressions', 'Expression levels', sprintf('Head azimuths (%s)',char(176)), sprintf('Head elevations (%s)',char(176)), 'Identity combos','Identity angles','Identity levels'};
Fig.Enable  = {[1,1,1,1,0,0,0],[0,0,1,1,1,1,1]};
Fig.Strings = {Params.Expressions, Params.ExpMag, Params.Azimuths, Params.Elevations, Params.PCcombos, Params.PCangles, Params.IdentityLevels};
Fig.Buttons = {'Resize','Normalize luminance','Greyscale','Export'};
Fig.OffOn   = {'Off','On'};
for n = 1:numel(Fig.Labels)
    Xpos = 0.02 + (n-1)*0.13;
    Fig.UI.sh(n) = uicontrol('Style','Text','String',Fig.Labels{n}, 'Fontsize', Fig.MinorFontsize, 'HorizontalAlignment','Left','parent',Fig.ph, 'units','normalized','position', [Xpos, 0.78, 0.12, 0.1]);
    Fig.UI.lh(n) = uicontrol('Style','Listbox','String',Fig.Strings{n},'max',10,'min',1,'HorizontalAlignment','Left','parent',Fig.ph, 'units','normalized','position', [Xpos, 0.05, 0.12, 0.75],'callback',{@StimSelection,n},'enable', Fig.OffOn{Fig.Enable{Params.Selected.SubSet}(n)+1});
end
Fig.UI.lh(n+1) = uicontrol('Style','Popup','String', Params.SubSets, 'Value', Params.Selected.SubSet, 'HorizontalAlignment','Left','parent',Fig.ph, 'units','normalized','position', [0.02, 0.9, 0.2, 0.1],'callback',{@StimSelection,n+1});


for b = 1:numel(Fig.Buttons)
    Ypos = 0.1+(b-1)*0.15;
    Fig.UI.bh(b) = uicontrol('Style','ToggleButton','String',Fig.Buttons{b},'parent',Fig.bph, 'units','normalized','position', [0.1, Ypos, 0.8, 0.1],'callback',{@PerformAction, b});
end
Fig.TotalStim   = uicontrol('Style','Text','String','Total stim = 1', 'fontsize', Fig.MajorFontsize, 'parent',Fig.bph, 'units','normalized','position', [0.1, 0.8, 0.8, 0.1]);
Fig.PrevH       = uicontrol('Style','Popup','String', Params.Table.RGBA_file, 'Value', 1, 'parent', Fig.ph2,  'units','normalized','position', [0.02, 0.88, 0.96, 0.1],'callback',@ChangePreviewImage);
Fig.PrevSH      = uicontrol('Style','Slider','Value',1, 'Max', 100, 'Min', 1,'SliderStep',[0.01,0.1],'parent', Fig.ph2,  'units','normalized','position', [0.02, 0.82, 0.96, 0.05],'callback',@ChangePreviewImageSlide);

GenerateMaskEditor();
SwitchStimSet();

%% ===================== Nested callback functions

%================== 
function GetImageDirs()
  	Params.ImageDir         = fullfile(Params.SetDirs{Params.Selected.SubSet}, 'ColorImages');
    Params.LabelDir         = fullfile(Params.SetDirs{Params.Selected.SubSet}, 'LabelMaps');
    if Params.Selected.SubSet == 1
        Params.DemoImFile       = fullfile(Params.ImageDir, sprintf('MF3D_%s%.2f_Haz%d_Hel%d_Gaz0_Gel0_RGBA.png', 'Fear', 1, 30, 0));
        Params.DemoLabelFile	= fullfile(Params.LabelDir, sprintf('MF3D_%s%.2f_Haz%d_Hel%d_Gaz0_Gel0_Label.hdr', 'Fear', 1, 30, 0));
        Params.Table        	= readtable(Params.ExpSummaryFile);
    elseif Params.Selected.SubSet == 2
     	Params.DemoImFile       = fullfile(Params.ImageDir, sprintf('MF3D_%s=%.2f_Haz%d_Hel%d_Gaz0_Gel0_RGBA.png', 'Mean', 1, 30, 0));
        Params.DemoLabelFile	= fullfile(Params.LabelDir, sprintf('MF3D_%s=%.2f_Haz%d_Hel%d_Gaz0_Gel0_Label.hdr', 'Mean', 1, 30, 0));
        Params.Table        	= readtable(Params.IdSummaryFile);
    end
end

%================== Stim selection was updated
function StimSelection(hObj, Evnt, Indx)
    switch Indx
        case 1
            Params.Selected.Expressions = get(hObj, 'value');
        case 2
            Params.Selected.ExpLevels = get(hObj, 'value');
        case 3
            Params.Selected.Azimuths = get(hObj, 'value');
        case 4
            Params.Selected.Elevations = get(hObj, 'value');
        case 5
            Params.Selected.PCcombos = get(hObj, 'value');
        case 6
            Params.Selected.PCangles = get(hObj, 'value');
        case 7
            Params.Selected.IdentityLevels = get(hObj, 'value');
        case 8
            Params.Selected.SubSet = get(hObj, 'value');
            SwitchStimSet;

    end
    NoOreintations      = numel(Params.Selected.Azimuths)*numel(Params.Selected.Elevations);
    if Params.Selected.SubSet == 1      %======= For expressions....
        NoNonNeutral        = sum(Params.Selected.Expressions ~= find(~cellfun(@isempty, strfind(Params.Expressions,'Neutral'))));
        NoNeutral           = sum(Params.Selected.Expressions == find(~cellfun(@isempty, strfind(Params.Expressions,'Neutral'))));
        Params.TotalStim    = NoNonNeutral*numel(Params.Selected.ExpLevels)*NoOreintations + NoNeutral*NoOreintations;
        
    elseif Params.Selected.SubSet == 2 %======= For identities....
        NoPCangles          = numel(Params.Selected.PCangles);
        NoMean              = sum(Params.Selected.PCcombos == find(~cellfun(@isempty, strfind(Params.PCcombos,'Mean'))));
        NoSinglePC          = sum(ismember(Params.Selected.PCcombos, find(cellfun(@numel, Params.PCcombos)==3)));
        NoMultiPC           = numel(Params.Selected.PCcombos)-NoSinglePC;
        Params.TotalStim    = (NoSinglePC*numel(Params.Selected.IdentityLevels)*NoOreintations) + (NoMultiPC*numel(Params.Selected.IdentityLevels)*NoOreintations*NoPCangles) + (NoMean*NoOreintations);

    end
    set(Fig.TotalStim, 'string', sprintf('Total stim = %d', Params.TotalStim));
    GetSelectionIndices;
    set(Fig.PrevH, 'String', Params.Table(Params.SelectionIndx,:).RGBA_file, 'value', 1);
    set(Fig.PrevSH, 'Max', Params.TotalStim, 'SliderStep', [1/Params.TotalStim, 1/Params.TotalStim*10]);
    ChangePreviewImage;
end

%================== Get filenames for all selected files
function GetSelectionIndices()
    Params.SelectionIndx = [];
	if Params.Selected.SubSet == 1      %======= For expressions....
        NeutralIndx = find(~cellfun(@isempty, strfind(Params.Expressions, 'Neutral')));
        if any(Params.Selected.Expressions == NeutralIndx)     % For Neural epxression...
            for az = Params.Selected.Azimuths
                for el = Params.Selected.Elevations
                    SearchRow = cell2table({'Neutral', 1, Params.Azimuths(az), Params.Elevations(el)}, 'VariableNames', {'Expression','ExpLevel','Azimuth','Elevation'});
                    Params.SelectionIndx(end+1) = find(ismember(Params.Table(:,3:6), SearchRow),1,'first');
                end
            end
        end
        if any(Params.Selected.Expressions~= NeutralIndx)
            for exp = Params.Selected.Expressions(Params.Selected.Expressions~= NeutralIndx)
                for expl = Params.Selected.ExpLevels 
                    for az = Params.Selected.Azimuths
                        for el = Params.Selected.Elevations
                            SearchRow = cell2table({Params.Expressions{exp}, Params.ExpMag(expl), Params.Azimuths(az), Params.Elevations(el)}, 'VariableNames', {'Expression','ExpLevel','Azimuth','Elevation'});
                            Params.SelectionIndx(end+1) = find(ismember(Params.Table(:,3:6), SearchRow));
                        end
                    end
                end
            end
        end
        
    elseif Params.Selected.SubSet == 2 %======= For identities....
        MeanIndx = find(~cellfun(@isempty, strfind(Params.PCcombos, 'Mean')));
        if any(Params.Selected.PCcombos== MeanIndx)     % For Mean identity...
            for az = Params.Selected.Azimuths
                for el = Params.Selected.Elevations
                    SearchRow = cell2table({'Mean', Params.Azimuths(az), Params.Elevations(el)}, 'VariableNames', {'PCcombo','Azimuth','Elevation'});
                    Params.SelectionIndx(end+1) = find(ismember(Params.Table(:,[3,6,7]), SearchRow),1,'first');
                end
            end
        end
        if any(Params.Selected.PCcombos~= MeanIndx)
            for pcc = Params.Selected.PCcombos
                
                if numel(Params.PCcombos{pcc})==3
                    for idl = Params.Selected.IdentityLevels
                        for az = Params.Selected.Azimuths
                            for el = Params.Selected.Elevations
                                SearchRow = cell2table({Params.PCcombos{pcc}, Params.IdentityLevels(idl), Params.Azimuths(az), Params.Elevations(el)}, 'VariableNames', {'PCcombo','IdentityLevel','Azimuth','Elevation'});
                                if isempty(find(ismember(Params.Table(:,[3,5:7]), SearchRow)))
                                    SearchRow
                                end
                                Params.SelectionIndx(end+1) = find(ismember(Params.Table(:,[3,5:7]), SearchRow));
                            end
                        end
                    end
                    
                elseif numel(Params.PCcombos{pcc})>3
                
                    for ang = Params.Selected.PCangles(Params.Selected.PCangles>1)
                        for idl = Params.Selected.IdentityLevels
                            for az = Params.Selected.Azimuths
                                for el = Params.Selected.Elevations
                                    SearchRow = cell2table({Params.PCcombos{pcc}, Params.PCangles(ang), Params.IdentityLevels(idl), Params.Azimuths(az), Params.Elevations(el)}, 'VariableNames', {'PCcombo','PCangle','IdentityLevel','Azimuth','Elevation'});
                                    if isempty(find(ismember(Params.Table(:,3:7), SearchRow)))
                                        SearchRow
                                    end
                                    Params.SelectionIndx(end+1) = find(ismember(Params.Table(:,3:7), SearchRow));
                                end
                            end
                        end
                    end
                    
                end
            end
        end
    end
end

%================== Switch between Expression vs Identity stim sets
function SwitchStimSet()
    GetImageDirs();
    for n = 1:numel(Fig.Labels)
        set(Fig.UI.lh(n), 'enable', Fig.OffOn{Fig.Enable{Params.Selected.SubSet}(n)+1});
    end
    set(Fig.PrevH,'String', Params.Table.RGBA_file, 'value', 1);
    if Params.Selected.SubSet == 1
        Params.Table = readtable(Params.ExpSummaryFile);

    elseif Params.Selected.SubSet == 2
        Params.Table = readtable(Params.IdSummaryFile);

    end
    Params.Azimuths         = unique(Params.Table.Azimuth);
    Params.Elevations       = unique(Params.Table.Elevation);
    set(Fig.UI.lh(3), 'String', Params.Azimuths, 'Value', 1);
    set(Fig.UI.lh(4), 'String', Params.Elevations, 'Value', 1);
    ChangePreviewImage();
    
end

%================== Action button was pressed
function PerformAction(hObj, Evnt, Indx)
    switch Indx
        case 1  %============== Resize
            if get(hObj,'value') == 1
                Actions.ResizeImages = 1;
                ResizeEditor;
            elseif get(hObj,'value') == 0
                Actions.ResizeImages = 0;
            end
            
        case 2  %============== Normalize luminance
          	if get(hObj,'value') == 1
                Actions.NormalizeLum = 1;
                
            elseif get(hObj,'value') == 0
                Actions.NormalizeLum = 0;
            end
            
        case 3  %============== Greyscale
          	Actions.Greyscale   = get(hObj,'value');
            [Im, c ImAlpha]  	= imread(Params.DemoImFile);
            if Actions.Greyscale == 1
                set(Fig.PrevImh(1), 'cdata', repmat(rgb2gray(Im),[1,1,3]));
            elseif Actions.Greyscale == 0
                set(Fig.PrevImh(1), 'cdata', Im);
            end

        case 4  %============== EXPORT
            ProcessAndSaveImages;

    end
end

%=================== Change the preview image via slider
function ChangePreviewImageSlide(hObj, Evnt, Indx)
    SliderVal = round(get(hObj, 'value'));
    set(Fig.PrevH, 'value', SliderVal);
    ChangePreviewImage(SliderVal);
    
end

%=================== Change the preview image
function ChangePreviewImage(hObj, Evnt, Indx)
    if nargin == 2
        FileIndx = get(hObj, 'value');
    elseif nargin == 1
        FileIndx = hObj;
    elseif nargin == 0
        GetSelectionIndices();
        FileIndx = 1;
    end
    Params.DemoImFile       = fullfile(Params.ImageDir, Params.Table.RGBA_file{Params.SelectionIndx(FileIndx)});
    Params.DemoLabelFile    = fullfile(Params.LabelDir, Params.Table.Label_file{Params.SelectionIndx(FileIndx)});
    
    [Im, c ImAlpha]         = imread(Params.DemoImFile);
    LabelMap                = hdrread(Params.DemoLabelFile);
    Params.Mask.LabelMap    = LabelMap(:,:,1);
    Params.Mask.Alpha       = ImAlpha;
    SmoothLabel();
    if Actions.Greyscale == 1
        set(Fig.PrevImh(1), 'cdata', repmat(rgb2gray(Im),[1,1,3]));
    elseif Actions.Greyscale == 0
        set(Fig.PrevImh(1), 'cdata', Im);
    end
    alpha(Fig.PrevImh(1), Params.Mask.Alpha);
    set(Fig.PrevImh(2), 'cdata', Params.Mask.LabelMap(:,:,1));
    UpdateMaskSelection();
    if Params.Mask.BackgroundIndx == 3
        GenerateFourierScramble;
    end
    if Params.Mask.CenterCyclops == 1
        GetCyclopeanOrigin;
    end
    if isfield(Params.Mask,'EllipseH')
     	CurrentPos = getPosition(Params.Mask.EllipseH);
       	setPosition(Params.Mask.EllipseH, [Params.Mask.CycloOrigin-CurrentPos([3,4])/2, CurrentPos([3,4])]);
    end
    set(Fig.PrevSH, 'Value', FileIndx);
end

%=================== Phase scramble image
function GenerateFourierScramble
    [Im, c ImAlpha] = imread(Params.DemoImFile);
    Im(:,:,4)       = ImAlpha;
    ImSize          = size(Im);
    RandomPhase     = angle(fft2(rand(ImSize(1), ImSize(2))));      % generate random phase offset
    for layer = 1:size(Im, 3)
        ImFourier(:,:,layer) = fft2(Im(:,:,layer));                 % Fast-Fourier transform 
        Amp(:,:,layer) = abs(ImFourier(:,:,layer));                 % amplitude spectrum
        Phase(:,:,layer) = angle(ImFourier(:,:,layer));             % phase spectrum
        Phase(:,:,layer) = Phase(:,:,layer) + RandomPhase;          % add random phase to original phase
%             Phase(:,:,layer) = RandomPhase;                         % OR replace original phase with random phase
        ScrambledImage(:,:,layer) = Amp(:,:,layer).*exp(sqrt(-1)*(Phase(:,:,layer)));  % Combine amplitude and phase 
    end
    NewImage        = real(ifft2(ScrambledImage));               	% perform inverse Fourier & get rid of imaginery part in image
    Range        	= max(NewImage(:)) - min(NewImage(:));          % Normalize Image to range 0:255
    NewImage        = uint8((NewImage - min(NewImage(:)))./Range*255);
    AlphaMask       = NewImage(:,:,4);
    NewImage(:,:,4) = [];
    AlphaMask       = ones(size(NewImage(:,:,1)));
    Params.Mask.PhaseScambled  	= NewImage;
    
    if ~isfield(Params.Mask, 'BackgroundH')
        axes(Fig.PrevAxh(1));
        Params.Mask.BackgroundH = image(Params.Mask.PhaseScambled);
        uistack(Params.Mask.BackgroundH, 'bottom');
    else
        set(Params.Mask.BackgroundH, 'cdata', Params.Mask.PhaseScambled);
    end
    
end

%=================== Update mask parameters
function UpdateMask(hObj, Evnt, Indx)
    switch Indx
        case 1  %========= Toggle smoothing
            Params.Mask.Smoothing = get(hObj,'Value');
            UpdateMaskSelection;
            
        case 2  %========= Change smoothing kernel width
            Params.Mask.SmoothSigma	= str2double(get(hObj, 'String'));
            UpdateMaskSelection;
            
        case 3  %========= Change background type
            Params.Mask.BackgroundIndx = get(hObj,'Value');
            switch Params.Mask.BackgroundIndx
                case 1
                    if isfield(Params.Mask, 'BackgroundH')
                        set(Params.Mask.BackgroundH, 'visible', 'off');
                    end
                    
                case 2 %========= Solid color
                    
                    %======= Because Mathworks sucks :(
                 	s = settings;
                    oldcolorpicker = 'matlab.ui.internal.dialog.ColorChooser';
                    s.matlab.ui.dialog.uisetcolor.ControllerName.TemporaryValue = oldcolorpicker;

                    %======= Ask user to select color
                    RGB = uisetcolor([0.5,0.5,0.5], 'Select background color');
                    if isempty(RGB)
                        return;
                    end
                    ColorIm = repmat(reshape(RGB,[1,1,3]), Params.Mask.Dims([1,2]));
                	if ~isfield(Params.Mask, 'BackgroundH')
                        axes(Fig.PrevAxh(1));
                        Params.Mask.BackgroundH = image(ColorIm);
                        uistack(Params.Mask.BackgroundH, 'bottom');
                    else
                        set(Params.Mask.BackgroundH, 'cdata', ColorIm, 'visible', 'on');
                    end
                    
                case 3 %========= Fourier phase scrambled
                    GenerateFourierScramble;
                    set(Params.Mask.BackgroundH, 'visible','on');
            end
            
        case 4  %========= Turn ellipse masking on
            Params.Mask.EllipseMaskOn = get(hObj,'Value');
          	if Params.Mask.EllipseMaskOn == 1
                if ~isfield(Params.Mask, 'EllipseH')
                    Params.Mask.EllipsePos  = [Params.Mask.Center([2,1]), repmat(Params.Mask.EllipseRadius*2,[1,2])];
                    Params.Mask.EllipseH    = imellipse(Fig.PrevAxh(1), Params.Mask.EllipsePos);
                else
                    set(Params.Mask.EllipseH, 'visible','on');
                end
              	if Params.Mask.CenterCyclops == 1
                    GetCyclopeanOrigin;
                    CurrentPos = getPosition(Params.Mask.EllipseH);
                    setPosition(Params.Mask.EllipseH, [Params.Mask.CycloOrigin-CurrentPos([3,4])/2, CurrentPos([3,4])]);
                end
               
            else
                set(Params.Mask.EllipseH, 'visible','off');
            end
            
        case 5 %========= 
            
            
        case 6  %========= Center ellipse on the cyclopean origin
            Params.Mask.CenterCyclops = get(hObj,'Value');
            if Params.Mask.CenterCyclops == 1
                GetCyclopeanOrigin;
                if isfield(Params.Mask, 'EllipseH')
                    setPosition(Params.Mask.EllipseH, [Params.Mask.CycloOrigin-Params.Mask.EllipseRadius, repmat(Params.Mask.EllipseRadius*2,[1,2])]);
                end
                set(Fig.CycOriginH, 'visible', 'On');
            else
                set(Fig.CycOriginH, 'visible', 'Off');
            end
            
        case 7 %========= Edit diameter of ellipse mask
            Params.Mask.EllipseRadius = str2double(get(hObj, 'string'));
            CurrentPos = getPosition(Params.Mask.EllipseH);
            setPosition(Params.Mask.EllipseH, [Params.Mask.CycloOrigin-Params.Mask.EllipseRadius, repmat(Params.Mask.EllipseRadius*2,[1,2])]);
            
    end

end

%=================== Calculate cyclopean center of image
function GetCyclopeanOrigin
    EyePix              = find(Params.Mask.LabelMap==1);
    if isempty(EyePix)
        return;
    end
    EyeMap          = double(Params.Mask.LabelMap==1);
    EyeMapFiltered  = round(imgaussfilt(EyeMap, Params.Mask.SmoothSigma));
    [B,L,N,A]       = bwboundaries(EyeMapFiltered);
    NoEyesDetected  = numel(B);
    for e = 1:NoEyesDetected
        MedianPos(e, 1) = median(B{e}(:,1));
        MedianPos(e, 2) = median(B{e}(:,2));
    end
    Params.Mask.CycloOrigin = [median(MedianPos(:,2)), median(MedianPos(:,1))];
    if ~isfield(Fig, 'CycOriginH')
        axes(Fig.PrevAxh(1));
        Fig.CycOriginH(1) = plot(MedianPos(:,2), MedianPos(:,1), '*--r');
        Fig.CycOriginH(2) = plot(Params.Mask.CycloOrigin(1), Params.Mask.CycloOrigin(2), '+g');
    elseif isfield(Fig, 'CycOriginH')
        set(Fig.CycOriginH(1), 'xdata', MedianPos(:,2), 'ydata', MedianPos(:,1));
        set(Fig.CycOriginH(2), 'xdata', Params.Mask.CycloOrigin(1), 'ydata', Params.Mask.CycloOrigin(2));
    end
    
end

%=================== Add mask editing GUI panel
function GenerateMaskEditor
    
    %=========== Load images
    [Im, c ImAlpha]         = imread(Params.DemoImFile);
    LabelMap                = hdrread(Params.DemoLabelFile);
    Params.Mask.LabelMap    = LabelMap(:,:,1);
    Params.Mask.Alpha       = ImAlpha;
  	Params.Mask.Dims        = size(Params.Mask.LabelMap);
    Params.Mask.Center      = Params.Mask.Dims/2;
    
    Fig.Mask.Labels         = {'Apply smoothing','Kernel width','Background','Ellipse crop','Isotropic','Cyclopean center','Radius (px)'};
    Fig.Mask.Backgrounds    = {'Transparent','Solid','Fourier scrambled','Image'};
    Fig.Mask.Styles         = {'Checkbox','Edit','PopupMenu','Checkbox','Checkbox','Checkbox','Edit'};
    Fig.Mask.Strings        = {[],Params.Mask.SmoothSigma, Fig.Mask.Backgrounds, [], [], [], Params.Mask.EllipseRadius};
    Fig.Mask.Values         = {Params.Mask.Smoothing, [], Params.Mask.BackgroundIndx, 0, Params.Mask.EllipseIso, Params.Mask.CenterCyclops, []};
    
    %=========== Create axes
    Fig.PrevAxh(1)          = axes('parent', Fig.ph2, 'position',[0.02, 0.02, 0.96, 0.86]);
    Fig.PrevImh(1)          = image(Im);
    hold on;
    axis equal tight;
    set(gca, 'xtick', [], 'ytick', [], 'box', 'off', 'color', [0,1,0]);
    Fig.PrevAxh(2)         	= axes('parent', Fig.ph3, 'position',[0.02, 0.02, 0.36, 0.96]);
    Fig.PrevImh(2)         	= imagesc(Params.Mask.LabelMap(:,:,1));
    axis equal tight off;
    colormap(jet);
    set(Fig.PrevAxh(2), 'xlim', [800, 3840-800], 'ylim', [400, 2160], 'clim', [0, numel(Params.Mask.Labels)-1]);
    set(Fig.PrevAxh(1), 'xlim', [0, Params.Mask.Dims(2)], 'ylim', [0, Params.Mask.Dims(1)]);
    
    %=========== Add UI controls
    for l = 1:numel(Params.Mask.Labels)
        Ypos = 0.1+(l-1)*0.08;
        Fig.UI.lh2 = uicontrol('Style','checkbox','String', Params.Mask.Labels{l}, 'ForegroundColor', repmat(Params.Mask.TextColor(l),[1,3]), 'backgroundcolor', Params.Mask.Colors(l,:), 'value', Params.Mask.Selected(l), 'parent', Fig.ph3, 'units','normalized','position', [0.4, Ypos, 0.2, 0.08], 'callback', {@UpdateMaskSelection,l});
        Params.Mask.Pix{l} = find(Params.Mask.LabelMap == (l-1));
        Params.Mask.Alpha(Params.Mask.Pix{l}) = uint8(Params.Mask.Selected(l)*255);
    end
    alpha(Fig.PrevImh(1), Params.Mask.Alpha);

   	for l = 1:numel(Fig.Mask.Labels)
        Ypos = 0.8-(l-1)*0.1;
        Fig.UI.MaskT(l)     = uicontrol('Style','text','String',Fig.Mask.Labels{l}, 'parent', Fig.ph3, 'units','normalized', 'HorizontalAlignment','left', 'position', [0.62, Ypos,0.15,0.1]);
        Fig.UI.MaskH(l)    	= uicontrol('Style',Fig.Mask.Styles{l},'String',Fig.Mask.Strings{l}, 'Value', Fig.Mask.Values{l}, 'parent', Fig.ph3,'units','normalized', 'position', [0.82, Ypos+0.01, 0.14,0.1], 'callback', {@UpdateMask,l});
    end
    set(Fig.UI.MaskH(1), 'enable', Fig.OffOn{Params.Mask.SmoothEnable+1});
   	if exist('imellipse.m','file')~=2
        set(Fig.UI.MaskH, 'enable', Fig.OffOn{1});
    end
        
end

%=================== Update selection of label map for masking
function UpdateMaskSelection(hObj, Evnt, Indx)
    if nargin > 0
        Params.Mask.Selected(Indx)  = get(hObj, 'value');
        Params.Mask.Alpha(Params.Mask.Pix{Indx}) = uint8(Params.Mask.Selected(Indx)*255);
    end
    for l = 1:numel(Params.Mask.Labels)
        Params.Mask.Pix{l} = find(Params.Mask.LabelMap == (l-1));
        Params.Mask.Alpha(Params.Mask.Pix{l}) = uint8(Params.Mask.Selected(l)*255);
    end
    if Params.Mask.Smoothing == 1
        Params.Mask.AlphaSmooth = round(imgaussfilt(Params.Mask.Alpha, Params.Mask.SmoothSigma));
        alpha(Fig.PrevImh(1), Params.Mask.AlphaSmooth);
    else
        alpha(Fig.PrevImh(1), Params.Mask.Alpha);
    end

end

%=================== Apply smoothing to label map
function SmoothLabel(hObj, Evnt, Indx)
    if nargin > 0
        Params.Mask.SmoothSigma     = get(hObj, 'value');
    end
    if Params.Mask.SmoothSigma > 0
        Params.Mask.Smooth = 1;
        Params.Mask.LabelMapSmooth  = round(imgaussfilt(Params.Mask.LabelMap(:,:,1), Params.Mask.SmoothSigma));
        set(Fig.PrevImh(2), 'cdata', Params.Mask.LabelMapSmooth);
        Params.Mask.AlphaSmooth = round(imgaussfilt(Params.Mask.Alpha, Params.Mask.SmoothSigma));
        alpha(Fig.PrevImh(1), Params.Mask.AlphaSmooth);
    else
        Params.Mask.Smooth = 0;
        set(Fig.PrevImh(2), 'cdata', Params.Mask.LabelMap);
        alpha(Fig.PrevImh(1), Params.Mask.Alpha);
    end

end

%=================== Open size editing GUI
function ResizeImage

    
end


%=================== Apply selected edits and save new image files
function ProcessAndSaveImages

    %========== Check required directories
    if ~exist(Params.OutputDir)
        success = mkdir(Params.OutputDir);
    end
    if Actions.MaskImages == 1 & ~exist(Params.LabelDir)
        error('Label directory ''%s'' does not exist! Unable to mask images.', Params.LabelDir);
    end

    %========== Generate stimulus list
    stimcount = 1;
    for az = Params.Selected.Azimuths
        for el = Params.Selected.Elevations
            if ismember(1, Params.Selected.Expressions)
                Params.SelectedRGB{stimcount}   = fullfile(Params.ImageDir, sprintf('MF3D_%s%.2f_Haz%d_Hel%d_Gaz0_Gel0_RGBA.png', Params.Expressions{1}, 1, Params.Azimuths(az), Params.Elevations(el)));
                Params.SelectedLabel{stimcount} = fullfile(Params.LabelDir, sprintf('MF3D_%s%.2f_Haz%d_Hel%d_Gaz0_Gel0_Label.hdr', Params.Expressions{1}, 1, Params.Azimuths(az), Params.Elevations(el)));
                stimcount = stimcount +1;
            end
            for exp = Params.Selected.Expressions(Params.Selected.Expressions>1)
                for expL = Params.Selected.ExpLevels
                    Params.SelectedRGB{stimcount}   = fullfile(Params.ImageDir, sprintf('MF3D_%s%.2f_Haz%d_Hel%d_Gaz0_Gel0_RGBA.png', Params.Expressions{exp}, Params.ExpMag(expL), Params.Azimuths(az), Params.Elevations(el)));
                    Params.SelectedLabel{stimcount} = fullfile(Params.LabelDir, sprintf('MF3D_%s%.2f_Haz%d_Hel%d_Gaz0_Gel0_Label.hdr', Params.Expressions{exp}, Params.ExpMag(expL), Params.Azimuths(az), Params.Elevations(el)));
                    if ~exist(Params.SelectedRGB{stimcount}, 'file')
                        ans = questdlg(sprintf('File ''%s'' does not exist! Continue attempting to export new images?', Params.SelectedRGB{stimcount}), 'Missing file','Yes','No','No');
                        if strcmpi(ans{1}, 'no')
                            return;
                        end
                    end
                    stimcount = stimcount +1;
                end
            end
        end
    end
    
    %========== Loop through stimuli
    wbh         = waitbar(0);
    Overwrite   = 0;
    for s = 1:Params.TotalStim
        waitbar(s/Params.TotalStim, wbh, sprintf('Processing MF3D stimulus %d/%d...', s, Params.TotalStim));
        
        %========= Load original image
        [im, c, alph]   = imread(Params.SelectedRGB{s});

        %========= Apply processing
        if Actions.MaskImages == 1
            hdr             = hdread(Params.SelectedLabel{s});
            LabelMap       	= hdr(:,:,1);
            alph            = LabelMap(ismember(LabelMap, find(Params.Mask.Selected==1)));
        end
      	if Actions.ResizeImages == 1
            im      = imresize(im, scale);
            alph    = imresize(alph, scale);
        end
        if Actions.Greyscale == 1
            im = rgb2gray(im);
        end
        %% ============ Add code here for custom image processing
        if Actions.CustomProcess == 1
            

        end
        
        %========= Save new image
        [~, File]   = fileparts(Params.SelectedRGB{s});
        Filename 	= fullfile(Params.OutputDir, sprintf('%s_Edit.png', File));
        if exist(Filename, 'file') && Overwrite == 0
            ans = questdlg(sprintf('A file named %s already exists in %s. Would you like to overwrite this, and any other existing files in this directory?', Filename, Params.OutputDir),'Overwrite?', 'Yes','No','Yes');
            if strcmp(ans, 'Yes')
                Overwrite = 1;
            end
        end
        if ~exist(Filename, 'file') || Overwrite == 1
            imwrite(im, Filename, 'alpha', alph);
        end
    end
    delete(wbh);
    
end


end