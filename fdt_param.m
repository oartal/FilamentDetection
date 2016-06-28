%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%   Parameters for Filament Detection Tools (automatic or assisted method)
%   used for outfiles from ROMS version AGRIF .
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
%   June, 21,2016. The identification method is added by temperature gradients
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Directory Out Files
out_dir = 'OUTPUT';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Assisted Method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Directory Input Files
inp_dir = 'INPUT/';
% Options for files
pfx = 'test';
ftype = 'his';
% Set Time
Ymin = 0;
Ymax = 0;
Mmin = 0;
Mmax = 0;

% Option for continue counting filaments. 0 = new experiment | 1 = old experiment
rst = 0;

% zoomarea = Vector with zoom area (lonmin lonmax latmin latmax). [] is default with all domain. 
zoomarea = []; %[-74 -70 -30 -28];
% SST Gradient (6 points is ~30 km in our model) 
dif = 6;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Automatic Method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Name of netCDF
filename = 'INPUT/test_his_Y0M0.nc';

% Type of output from ROMS AGRIF ('his','avg')
filetype = 'his';

% How many days you want analize? 'all', or some specific
hmd = 1; %'all';

% Type of Identification Method, SST Gradient (SST) or magnitude of the
% current (MI)
autmeth = 'MI';

% Magnitude greater than x m/s for MI?
% (SST gradient greater than x ° for SST?)
ggt = .25;

% SST gradient (Only for SST method)
difA = 6; 

% Length filament longitude gretear than x km?
lfgt = 100;

% Minimum distance to the coast (km)?
mdc = 15; 

% VALUE = 1 IS ONLY RECOMMENDED FOR A SPECIFIC DAY
% Plot figure? (1 = yes | 0 = not)
pfig = 1;
% Save figure? ONLY IF pfig = 1 (1 = yes | 0 = not) 
sfig = 0;   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Persistence Criterium
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

method = 'automatic';
% In days and tolerance radius.
perdays = 5;
tol = 0.1;



