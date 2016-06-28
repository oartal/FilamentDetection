function d = fdt_haversine(a1,a2,b1,b2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   FUNCTION d = fdt_haversine(a1,a2,b1,b2)
%
%   Function that calculates the distance between two points
%
%   This file is part of FILAMENT DETECTION TOOLS
%
%   FILAMENT DETECTION TOOLS is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   INPUT
%       a1 = Latitude Station 1(0 a 90 N)
%       a2 = Longitude Station 1(0 a 180 E) 
%       b1 = Latitude Station 2(0 a 90 N)
%       b2 = Longitude Station 2(0 a 180 E) 
%  
%   OUTPUT
%       d = Distance beetween stations
%
% AUTHOR 
%      OSVALDO ARTAL (oartal@dgeo.udec.cl)
% 
% DATE LAST MODIFIED
%       September, 22. 2010
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


R = 6371; % km change accordingly
% Station 1 
lat1 = (pi/180)*a1;
long1= (pi/180)*a2;

% Station 2
lat2 = (pi/180)*b1;
long2= (pi/180)*b2;

% Haversine 
dlong=long2-long1;
dlat=lat2-lat1;

sinlat=sin(dlat/2);
sinlong=sin(dlong/2);

a=(sinlat*sinlat)+cos(lat1)*cos(lat2)*(sinlong*sinlong);
c=2*asin(min(1,sqrt(a)));
d=round(R*c);
return
