%========================== MF3D_RealTimeDemo.m ===========================
% A GUI to demonstrate remote client control of face-space parameters updated 
% in the Blender game engine in (near) real-time.


Fig.MajorFontsize = 14;

Fig.fh      = figure('name', 'MF3D Real-time Demo GUI', 'position', get(0, 'screensize'),'menu','none','toolbar','none');
Fig.ph1     = uipanel('units','normalized','position',[0.01,0.01,0.45,0.48],'title','Settings','fontsize', Fig.MajorFontsize);
Fig.ph2     = uipanel('units','normalized','position',[0.01,0.51,0.45,0.48],'title','Settings','fontsize', Fig.MajorFontsize);
Fig.axh     = axes('parent',Fig.fh,'units','normalized','position',[0.5,0.1,0.4, 0.8]);

Point       = plot3(0, 0, 0, '.b', 'markersize', 20, 'color', [0,0,1]);
grid on;
box off;