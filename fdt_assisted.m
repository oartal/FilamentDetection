function fdt_assisted
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   The function fdt_assisted (Filament detecction tools: assisted method
%   for filament count) used a netCDF file obtained from the ROMS AGRIF
%   model. Counter the filament and record latitude, longitude, number of
%   filament, length and angle with respect to the coast.
%
%   This file is part of FILAMENT DETECTION TOOLS
%
%   FILAMENT DETECTION TOOLS is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
% AUTHOR
%   Osvaldo Artal A.  oartal@dgeo.udec.cl
%
% DATE LAST MODIFIED
%
%   August, 9. 2011
%   July, 18. 2012. solved problem with month "13"
%   December, 17, 2013. Independient file, using with fdt_param.m
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fdt_param

results = [];
if exist(out_dir,'dir')==0
    eval(['! mkdir ', out_dir]);
    disp(['directory ',out_dir,' was created'])
else
    disp(['directory ',out_dir,' already exists'])
end

M = []; M2 = []; ii = 1; jj = 0; YY = []; MM = []; DD = [];
for i1 = Ymin:Ymax
    for i2 = Mmin:Mmax
        filename = [inp_dir,'/',pfx,'_',ftype,'_Y',num2str(i1),...
            'M',num2str(i2),'.nc'];
        
        if exist(filename,'file')==0
            error('No Found File');
        end
        
        [lon,lat,coast,time,temp,vec] = fdt_readroms(filename,ftype);
        NT = numel(time); jj = jj+NT;
        M(ii:jj,:,:) = temp;
        M2(ii:jj,:,:) = vec;
        YY(ii:jj) = ones(NT,1)*i1; MM(ii:jj) = ones(NT,1)*i2;
        DD(ii:jj) = 1:NT;
        ii = ii+NT;
    end
end

mask = coast;
mask(mask==0) = NaN;

if isempty(zoomarea)==1
    zoomarea = [min(lon(:)) max(lon(:)) min(lat(:)) max(lat(:))];
end

switch rst
    case 0
        rand('seed',8);
        new_vec = randperm(jj);
    case 1
        lista = dir(out_dir);
        if lista(end).name=='..'
            error('Restart option is actived | Not exist file for restart')
        end
        filename = [out_dir '/' lista(end).name];
        eval(['load ', filename])
    otherwise
        disp('Unknown option')
end


disp('Left click for count a filament | Right click 2 times for the next image')
con_fig = 1;
op = 'y';

map = jet;
map(1,:) = [0.86,0.86,0.86];
close
for i1 = new_vec
    T(:,:) = squeeze(M(i1,:,:));
    T = T.*mask;
    
    I(:,:) = squeeze(M2(i1,:,:));
    I = I.*mask;
    
    dif2= dif/2;
    GTx = T(:,1:end-dif)-T(:,1+dif:end);
    GTy = T(1:end-dif,:)-T(1+dif:end,:);
    
    GT = sqrt(GTx(1+dif2:end-dif2,:).^2+GTy(:,1+dif2:end-dif2).^2);
    
    
    screen_size = get(0, 'ScreenSize');
    z1=figure(1);
    set(z1, 'Position', [0 0 screen_size(3) screen_size(4) ] );
    set(z1,'color',[1 1 1])
    
    clf
    suptitle(['Figure  ',num2str(con_fig),'/',num2str(length(new_vec))]);
    subplot 131
    imagesc(lon(1,1+dif2:end-dif2), lat(1+dif2:end-dif2,1),GT,[0.4 2]),colormap(map)
    axis xy; axis equal
    axis(zoomarea)
    title('SST Gradient')
    ejec1 = colorbar('Location','EastOutside');
    title(ejec1,'degC/km');
    caxis([0.4 2]);
    ylabel('Latitude');
    
    subplot 132
    imagesc(lon(1,1+dif2:end-dif2), lat(1+dif2:end-dif2,1),T(1+dif2:end-dif2,1+dif2:end-dif2))
    axis xy; axis equal
    axis(zoomarea)
    ejec2 = colorbar('Location','EastOutside');
    title(ejec2,'degC')
    xlabel('Longitude')
    title('SST  ')
    grid
    
    subplot 133
    imagesc(lon(1,1+dif2:end-dif2), lat(1+dif2:end-dif2,1),I(1+dif2:end-dif2,1+dif2:end-dif2))
    axis xy; axis equal
    axis(zoomarea)
    title('Velocity Magnitude')
    ejec3 = colorbar('Location','EastOutside');
    title(ejec3,'m/s');caxis([0.1 0.8])
    
    button = 1; i2 = 0;
    while button == 1
        [lon0, lat0, button] = ginput(1);
        if button == 3
            break
        end
        [lonf, latf] = ginput(1);
        line([lon0 lonf],[lat0 latf],'color', 'k')
        d = fdt_haversine(lat0,lon0,latf,lonf);
        dr = fdt_haversine(lat0,lon0,lat0,lonf);
        phi = asind(dr/d);
        i2=i2+1;
        results = [results; YY(i1) MM(i1) DD(i1) i2 lat0 lon0 latf lonf d phi];
    end
    con_fig = con_fig+1; clear T
    op = input('Do you want save and exit? y/n:     ','s');
    
    if op == 'y'
        fileoutput = [out_dir '/roms_assisted_' num2str(datenum(fix(clock))) '.mat'];
        disp(['Saved file name:     ' fileoutput]);
        clf
        axis off
        text(0.3,0.5,'THE END','fontsize',100)
        new_vec(1:con_fig-1) = [];
        eval(['save ', fileoutput , ' results new_vec -mat'])
        return
    end
    
end


fileoutput = [out_dir '/roms_assisted_' num2str(datenum(fix(clock))) '.mat'];
disp(['Saved file name:     ' fileoutput]);
clf
axis off
text(0.3,0.5,'THE END','fontsize',100)

eval(['save ', fileoutput , ' results new_vec -mat'])

return
