function fdt_automatic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   The function fdt_automatic (Filament detecction tools: automatic method)
%   use a netCDF file obtain from the ROMS model.
%   For both take us the magnitude of current in gray scale and
%   filtered showed strong gradient.
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
%   August, 22. 2011
%   August, 8. 2012
%   December, 19, 2013. Independient file, using with fdt_param.m
%   June, 21,2016. The identification method is added by temperature gradients
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fdt_param

if exist(filename,'file')==0
    error('No Found File');
end

%% initial vector for all features

NZ = []; DD = []; FN = [];
results = []; out = [];

%% Show original figure extracted from netCDF model data
aa = find(filename=='Y');
ab = find(filename=='M');
ac = find(filename=='.');
yy = str2num(filename(aa+1:ab-1));
mm = str2num(filename(ab+1:ac-1));

[lon,lat,coast,time,temp,I] = fdt_readroms(filename,filetype);

D = bwdist(~coast);   % Distance from each pixel to the coast, using a inverted landmask (0 for water, 1 for land)
                      % bwdist calculated the Euclidian distance between each pixel and the nearest non-zero pixel
                      % in this case, the coastline.

switch autmeth
    case {'SST'}
        dif2= dif/2; 
        lon = lon(1+dif2:end-dif2,1+dif2:end-dif2);
        lat = lat(1+dif2:end-dif2,1+dif2:end-dif2);
        D = D(1+dif2:end-dif2,1+dif2:end-dif2);
end

disp('Features extract from ...')
disp(filename)

% length & dimensions
ltim = numel(time);

switch hmd
    case 'all'
        index = 1:ltim;
    otherwise
        index = hmd;
end

for i1 = index
    mask = ones(size(coast));
    mask(coast==0)=NaN;
    
    if ndims(I)==3
        switch autmeth
            case {'MI'}
                T = squeeze(I(i1,:,:));
                G = T.*mask;
            case {'SST'}
                gt0 = squeeze(temp(i1,:,:)).*mask;
                GTx = gt0(:,1:end-dif)-gt0(:,1+dif:end);
                GTy = gt0(1:end-dif,:)-gt0(1+dif:end,:);                
                G = sqrt(GTx(1+dif2:end-dif2,:).^2+GTy(:,1+dif2:end-dif2).^2);  
        end
    elseif ndims(temp)==2
        T = I;
        G = T.*mask;
    else
        error('Incorrect dimensions for temperature')
    end
    
    % Filtered Image
    J = (G>ggt);
    
    % Skel Image
    B = bwmorph(J,'open',1);
    B = bwmorph(B,'skel',Inf);
    B = bwmorph(B,'bridge',Inf);
    B = bwmorph(B,'clean',Inf);
    
    % Plot figures
    switch pfig
        case 1
            figure(1), imshow(G,[]),axis xy
            figure(2), imshow(B),axis xy
    end
    
    switch sfig
        case 1
            datefig = ['Y' num2str(yy) 'M' num2str(mm) 'D' num2str(index(i1))];
            figure(1), print('-dtiff','-r300',['gray_' datefig])
            figure(2), print('-dtiff','-r300',['morfo_' datefig])
    end
    
    [out_aux shape] = fdt_filaments(B,lon,lat,D,lfgt,mdc,pfig,sfig,i1,mm,yy);
    if isempty(out_aux)==0
        out = [out; out_aux];
        lout = length(out_aux(:,1));
        DD = [DD; ones(lout,1)*i1];
        FN = [FN; [1:lout]'];
    end
    form(i1).shape = shape;
end
YY = ones(size(DD))*yy;
MM = ones(size(DD))*mm;

results = [YY MM DD FN out];

if isempty(results)==1
    disp('Not filament detected')
else
    fileoutput = [out_dir,'/roms_automatic_' num2str(datenum(fix(clock))) '.mat'];
    save(fileoutput,'results','form','lon','lat')
    disp(['Saved results file in  ' fileoutput ])
end

return
