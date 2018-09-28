function [out shape] = fdt_filaments(BW,lon,lat,mdistance,lfgt,mdc,pfig,sfig,index,mm,yy)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION [out shape] = fdt_filaments(BW,lon,lat,mdistance,pfig,sfig,index,mm,yy)
%
%   The function fdt_filaments choose the segments that corresponded to
%   filaments. We use the parameters of file fdt_param.m
%
%   This file is part of FILAMENT DETECTION TOOLS
%
%   FILAMENT DETECTION TOOLS is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
% INPUT
%   BW  	=   	Morphological Image
%   lon 	=   	Longitude
%   lat 	=   	Latitude
%   mdistance 	= 	Transform Matrix of distance to the coast
%   lfgt 	=	Length filament longitude gretear than x km
%   mdc 	= 	Minimum distance to the coast (km)
%   pfig 	= 	Plot figure
%   sfig 	= 	Save figure
%   index 	= 	index figure
%   mm 		=	Month
%   yy 		=	Year
%
% OUTPUT
%   out 	= 	This is a matrix with the record initial_latitude
%   initial_longitude, final_latitude,final_longitude,length & angle;
%   shape 	= 	Shape of the filaments.
%
% AUTHOR
%   Osvaldo Artal A.  oartal@dgeo.udec.cl
%
% DATE LAST MODIFIED
%
%   September, 9. 2011
%   December, 19, 2013. Independient file, using with fdt_param.m
%   June, 21, 2016. Variables that are not used are removed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
BWn=BW;


filaments = bwlabel(BWn,8);

filaments_prop = regionprops(filaments,'all');

out = [];
eliminated = [];
for it = 1:numel(filaments_prop)
    pos0 = max(filaments_prop(it).PixelList);        % this selects the rightmost pixel in each filament
    posf = min(filaments_prop(it).PixelList);
    latmean = (lat(fix(pos0(1,2)),1)+lat(fix(posf(1,2)),1))/2;
    dxfil = (fdt_haversine(latmean,latmean,lon(1),lon(2)))/1000; %in km
    minaxes = filaments_prop(it).MajorAxisLength*dxfil;
    d = mdistance(fix(pos0(1,2)),fix(pos0(1,1)));
    
    if minaxes>lfgt && d<=mdc
        lat0 = lat(round(pos0(1,2)),1);
        lon0 = lon(1,round(pos0(1,1)));
        latf = lat(round(posf(1,2)),1);
        lonf = lon(1,round(posf(1,1)));
        initial = [lat0 lon0];
        final = [latf lonf];
        degree = filaments_prop(it).Orientation;
        out = [out ; initial final minaxes degree];
    else
        eliminated = [eliminated, it];
        filaments(filaments==it)=0;
    end
end

filaments_prop(eliminated) = [];

if isempty(filaments_prop)==1
    shape = zeros(size(mdistance));
    return
end

shape = filaments;

if pfig
    fig1 = figure();
    fig2 = figure();
    figure(fig1), imshow(BW, []);axis xy; %title('Filaments')
    plotBoundingBox(fig1,filaments_prop);
    figure(fig2),
    coastfil = filaments; coastfil(coastfil>0)=1;
    imshow(coastfil,[]);axis xy;
end
if sfig && pfig==1
    datefig = ['Y' num2str(yy) 'M' num2str(mm) 'D' num2str(index)];
    figure(fig1); print('-dtiff','-r300',['region_' datefig])
    figure(fig2); print('-dtiff','-r300',['filaments_' datefig])
end
end

function plotBoundingBox(fig,f)

figure(fig),
for it = 1:numel(f)
    x = fix( f(it).BoundingBox(1) );
    y = fix( f(it).BoundingBox(2) );
    h = fix( f(it).BoundingBox(3) );
    w = fix( f(it).BoundingBox(4) );
    
    v = [ x x+h x+h x; y y y+w y+w ];
    
    hold on
    patch( v(1,1:end), v(2,1:end), 'g',...
        'FaceAlpha', 0.4, 'EdgeColor', 'g', 'EdgeLighting', 'flat');
    text(x-15,y-5,num2str(it),'Background','white', 'FontSize',8);
    hold off
end

end
