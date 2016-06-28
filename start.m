%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%   Add the paths of the different toolboxes
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Toolboxs needed for FDT

mypath = eval('pwd ');

addpath([mypath,'/netcdf_toolbox/mexnc'])
addpath([mypath,'/netcdf_toolbox/netcdf'])
addpath([mypath,'/netcdf_toolbox/netcdf/ncsource'])
addpath([mypath,'/netcdf_toolbox/netcdf/nctype'])
addpath([mypath,'/netcdf_toolbox/netcdf/ncutility'])


%% Routines from ROMSTOOLS
addpath([mypath,'/ROMSTOOLS'])
