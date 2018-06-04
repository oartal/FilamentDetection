function fdt_plot_automatic(output,grdname)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION fdt_plot_automatic
%
% DESCRIPTION
%   This function plot the output from the automatic method of filament 
% deteccion. 
%
% AUTHOR
%   Osvaldo Artal A.  oartal@dgeo.udec.cl
%
% DATE LAST MODIFIED
%
%   14, April. 2015
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clear
% clc
% grdname = 'INPUT/roms_his_Y8M1.nc';
% output = 'OUTPUT/roms_automatic_736068.486.mat';
%
% e.g. fdt_plot_automatic('OUTPUT/roms_automatic_736068.486.mat','INPUT/roms_his_Y8M1.nc')
%

%
% to use with Octave uncomment the following line
%graphics_toolkit("gnuplot");
%

[lon,lat,mask] = fdt_readroms(grdname,'grd');
dif2 = 3; % Value for calculate the gradients.
lon = lon(1,1+dif2:end-dif2);lat = lat(1+dif2:end-dif2,1);
mask = mask(1+dif2:end-dif2,1+dif2:end-dif2);
mask(mask==0)=NaN;

dat = load(output);
M = struct2array(dat.form);
aux = dat.results;
YY  = aux(1,1); MM = aux(1,2); DD=aux(1,3);

set(gcf,'Position',get(0,'Screensize'));
set(gcf,'color',[1 1 1])

pcolor(lon, lat, M.*mask);shading flat
axis equal
axis([min(lon(:)) max(lon(:)) min(lat(:)) max(lat(:))])
ejec2 = colorbar('Location','EastOutside');
title(ejec2,'°C')
xlabel('Longitude')
title('SST  ')
grid

namefig = ['filaments_Y',num2str(YY),'M',num2str(MM),'D',num2str(DD)];
print('-dtiff','-r300',namefig)
return
