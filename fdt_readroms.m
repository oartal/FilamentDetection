function [lon lat mask time temp I] = fdt_readroms(filename,filetype)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION  [lon lat mask time temp I] = fdt_readroms(filename,filetype)
%
%   This function read a netCDF data and extracts longitude, latitude, 
%   time, mask and the temperature. You need the toolbox snctools for matlab
%
%   This file is part of FILAMENT DETECTION TOOLS
%
%   FILAMENT DETECTION TOOLS is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
% INPUT
%   filename	 = 	This is the name of netCDF file
%   filetype	 = 	Type of the netcdf output (avg, his) 
%
% OUTPUT
%   lon 	=	 longitude
%   lat 	= 	 latitude
%   mask 	= 	 mask
%   time 	= 	 time
%   temp 	= 	 temperature
%
% EXAMPLE
%  [lon lat mask temp] = fdt_readroms('Example/roms_avg_Y8M1.nc');
%  
% AUTHOR
%   Osvaldo Artal A.  osvaldo.artal@ifop.cl
%
% DATE LAST MODIFIED
%
%   May, 31. 2011
%   Nov, 27, 2012 (change version of netcdf toolbox)
%   Dec, 17, 2013 (Add filetype)
%   Jun, 04. 2018 (Add case grd)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nc = netcdf(filename,'r');
lon = nc{'lon_rho'}(:);     % Obtain longitude
lat = nc{'lat_rho'}(:);     % Obtain latitude
mask = nc{'mask_rho'}(:);   % Obtain mask


% Obtain dimensions
ns = length(nc('s_rho'));

switch filetype
    case 'avg'
        time = nc{'scrum_time'}(:);
        temp = squeeze(nc{'temp'}(:,ns,:,:));
        u = u2rho_3d(squeeze(nc{'u'}(:,ns,:,:)));
        v = v2rho_3d(squeeze(nc{'v'}(:,ns,:,:)));
    case 'his'
        time = nc{'scrum_time'}(2:end);
        temp = squeeze(nc{'temp'}(2:end,ns,:,:));
        u = u2rho_3d(squeeze(nc{'u'}(2:end,ns,:,:)));
        v = v2rho_3d(squeeze(nc{'v'}(2:end,ns,:,:)));
    case 'grd'
        xspon = nc.x_sponge(:);
        close(nc)
        gradespon = (xspon/1000)/111;
        dlon = lon(1,2)-lon(1,1);
        dlat = lat(2,1)-lat(1,1);
        x_remove = numel(0:dlon:gradespon);
        y_remove = numel(0:dlat:gradespon);
        lon(1:x_remove,:)=[];
        lon(:,1:y_remove)=[];
        lon(:,end-y_remove:end)=[];
        lat(1:x_remove,:)=[];
        lat(:,1:y_remove)=[];
        lat(:,end-y_remove:end)=[];
        mask(1:x_remove,:)=[];
        mask(:,1:y_remove)=[];
        mask(:,end-y_remove:end)=[];
        return    
end

xspon = nc.x_sponge(:);
close(nc)

I = sqrt(u.^2+v.^2);
gradespon = (xspon/1000)/111;
dlon = lon(1,2)-lon(1,1);
dlat = lat(2,1)-lat(1,1);

x_remove = numel(0:dlon:gradespon);
y_remove = numel(0:dlat:gradespon);

lon(1:x_remove,:)=[];
lon(:,1:y_remove)=[];
lon(:,end-y_remove:end)=[];

lat(1:x_remove,:)=[];
lat(:,1:y_remove)=[];
lat(:,end-y_remove:end)=[];

temp(:,1:x_remove,:)=[];
temp(:,:,1:y_remove)=[];
temp(:,:,end-y_remove:end)=[];

I(:,1:x_remove,:)=[];
I(:,:,1:y_remove)=[];
I(:,:,end-y_remove:end)=[];


mask(1:x_remove,:)=[];
mask(:,1:y_remove)=[];
mask(:,end-y_remove:end)=[];

return
