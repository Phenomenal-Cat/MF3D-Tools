function MF3D_IdentitySelection

Az          = -90:30:90;
El          = -30:30:30;
ImFile      = 'MF3D_IdAngles_Mean.png';
[OreintIm, c, OrientAlpha]  = imread(ImFile);
Selected.OrientGrid         = zeros(numel(El),numel(Az));

PCs                     = 1:5;
PC_SDs                  = [-4:-1,1:4];
Angles_rad              = linspace(0, pi-(pi/8), 8);
Anlges_deg              = rad2deg(Angles_rad);
MaxAlpha                = 0.3;
DefaultOffColor         = [0.75,0.75,0.75];
MeanColor               = [0,1,0];
Grid                    = ones(numel(PCs));
Grid(find(tril(Grid)))  = 2;
Grid(diag(1:5)>0)       = 0;
Selected.PCcombos       = zeros(numel(PCs));
Selected.PCvectors      = ones(numel(Angles_rad), numel(PC_SDs));
Mask                    = zeros([numel(PCs), numel(PCs), 3]);
AlphaMask               = ~Selected.PCcombos*MaxAlpha;
Colors                  = [0,0,0.5; 0,1,1; 1,0.5,0];
ColorIndx               = [1,2,2,2,1,3,3,3];
RingColors              = [1,0.7,0.7; 1,0.3,0.3; 1,0,0; 0.5,0,0];


fh = figure('position',[0,0,800,800], 'name', 'MF3D Identity Selection');

%=========== Head oreintation matrix
axh(3)  = subplot(2,2,[1,2]);
imh(3)  = imagesc(1:numel(Az), 1:numel(El), Selected.OrientGrid, 'ButtonDownFcn', {@OrientClick});
hold on;
imm(3) = imagesc(0.5:(numel(Az)+0.5), 0.5:(numel(El)+0.5), OreintIm, 'PickableParts','none');
alpha(imm(3), OrientAlpha);
box off
axis equal tight
set(gca, 'xtick', 1:numel(Az), 'xticklabel', Az, 'ytick', 1:numel(El), 'yticklabels', El, 'tickdir','out');
xlabel(sprintf('Azimuth (%s)', char(176)), 'fontsize', 14);
ylabel(sprintf('Elevation (%s)', char(176)), 'fontsize', 14);
th(3) = title(sprintf('# orientations selected = %d', sum(Selected.OrientGrid(:))), 'fontsize', 12, 'FontWeight', 'normal');
set(axh(3), 'clim', [0,1]);

%=========== PC combo matrix plot
axh(1) = subplot(2,2,3);
imh(1) = imagesc(Grid);
set(imh(1), 'ButtonDownFcn', {@PCcomboClick});
hold on;
imm(1) = imagesc(Mask, 'PickableParts','none');
alpha(imm(1), AlphaMask);
box off
axis equal tight
set(gca, 'xtick', PCs, 'ytick', PCs, 'tickdir','out');
xlabel('PC B', 'fontsize', 14);
ylabel('PC A', 'fontsize', 14);
th(1) = title(sprintf('# PC combinations selected = %d', sum(Selected.PCcombos(:))), 'fontsize', 12, 'FontWeight', 'normal');

%=========== PC vector polar plot
axh(2) = subplot(2,2,4);
for ang = 1:numel(Angles_rad)
    for pcsd = 1:numel(PC_SDs)
        X(ang, pcsd) = sin(Angles_rad(ang))*PC_SDs(pcsd);
        Y(ang, pcsd) = cos(Angles_rad(ang))*PC_SDs(pcsd);
        if ang == 1 & pcsd < 5
            Rh(pcsd) = rectangle('Position', [repmat(PC_SDs(pcsd),[1,2]), repmat(-PC_SDs(pcsd)*2,[1,2])], 'Curvature',1, 'edgecolor',RingColors(pcsd,:), 'linewidth',2, 'tag',num2str(pcsd),'ButtonDownFcn', {@PCmarkerClick, 3});
            hold on;
        end
        pmh(ang, pcsd) = plot(X(ang, pcsd), Y(ang,pcsd), '.','markersize', 30, 'color', Colors(ColorIndx(ang),:),'ButtonDownFcn', {@PCmarkerClick, 1},'tag',num2str(ang));
        hold on;
    end
    plh(ang) = plot(X(ang, :), Y(ang,:), '-','linewidth', 2, 'color', Colors(ColorIndx(ang),:),'ButtonDownFcn', {@PCmarkerClick, 2},'tag',num2str(ang));
end
phmean = plot(0, 0, '.', 'markersize', 30, 'color', MeanColor,'ButtonDownFcn', {@PCmarkerClick, 4});
set(gca,'tickdir','out');
uistack(plh, 'bottom');
for n = numel(Rh):-1:1
    uistack(Rh(n), 'bottom');
end
axis equal tight;
grid on;
box off;
xlabel(sprintf('PC B (%s)', char(417)), 'fontsize', 14);
ylabel(sprintf('PC A (%s)', char(417)), 'fontsize', 14);
zlabel(sprintf('PC C (%s)', char(417)), 'fontsize', 14);
th(2) = title(sprintf('# PC trajectories selected = %d', sum(Selected.PCvectors(:))), 'fontsize', 12, 'FontWeight', 'normal');


%% ============================ Subfunctions ==============================

function PCcomboClick(hObj, Evnt, Indx)
    axH     = get(hObj, 'parent');
    coords  = get(axH, 'CurrentPoint');
    coords  = round(coords(1,1:2));
    Selected.PCcombos(coords(2), coords(1)) = ~Selected.PCcombos(coords(2), coords(1));
    AlphaMask   = ~Selected.PCcombos*MaxAlpha;
    alpha(imm(1), AlphaMask);
    set(th(1), 'string', sprintf('# PC combinations selected = %d', sum(Selected.PCcombos(:))));
end

function OrientClick(hObj, Evnt, Indx)
    axH     = get(hObj, 'parent');
    coords  = get(axH, 'CurrentPoint');
    coords  = round(coords(1,1:2));
    Selected.OrientGrid(coords(2), coords(1)) = ~Selected.OrientGrid(coords(2), coords(1));
    set(imh(3), 'cdata', Selected.OrientGrid);
    set(th(3), 'string', sprintf('# orientations selected = %d', sum(Selected.OrientGrid(:))));
end

function PCmarkerClick(hObj, Evnt, Indx)
    
    switch Indx
        case 1 %============ Individual marker selected
            CurrentColor    = get(hObj, 'Color');
            ang             = str2double(get(hObj,'Tag'));
            if CurrentColor == DefaultOffColor
                set(hObj, 'Color', Colors(ColorIndx(ang),:))
          	elseif CurrentColor ~= DefaultOffColor
                set(hObj, 'Color', DefaultOffColor)
            end
                
        case 2  %=========== iso-identity (linear) trajectory selected
            CurrentColor    = get(hObj, 'Color');
            ang             = str2double(get(hObj,'Tag'));
            if CurrentColor == DefaultOffColor
                set(hObj, 'Color', Colors(ColorIndx(ang),:))
                set(pmh(ang,:), 'Color', Colors(ColorIndx(ang),:))
                Selected.PCvectors(ang,:) = 1;
            elseif CurrentColor ~= DefaultOffColor
                set(hObj, 'Color', DefaultOffColor)
                set(pmh(ang,:), 'Color', DefaultOffColor)
                Selected.PCvectors(ang,:) = 0;
            end
            
        case 3  %=========== iso-distinctive (circular) trajectory
            CurrentColor    = get(hObj, 'EdgeColor');
            pclevel        	= str2double(get(hObj,'Tag'));
            if CurrentColor == DefaultOffColor
                set(hObj, 'EdgeColor', RingColors(pclevel,:))
                set(pmh(:,pclevel), 'Color', RingColors(pclevel,:))
                Selected.PCvectors(:,pclevel) = 1;
            elseif CurrentColor ~= DefaultOffColor
                set(hObj, 'EdgeColor', DefaultOffColor)
                set(pmh(:,pclevel), 'Color', DefaultOffColor)
                Selected.PCvectors(:,pclevel) = 0;
            end
            
        case 4  %=========== mean selected
            CurrentColor    = get(hObj, 'Color');
            if CurrentColor == DefaultOffColor
                set(hObj, 'Color', MeanColor)
                set(phmean, 'Color', MeanColor)
            elseif CurrentColor ~= DefaultOffColor
                set(hObj, 'Color', DefaultOffColor)
                set(phmean, 'Color', DefaultOffColor)
            end
            
    end

    set(th(2), 'string', sprintf('# PC trajectories selected = %d', sum(Selected.PCvectors(:))));
end

end