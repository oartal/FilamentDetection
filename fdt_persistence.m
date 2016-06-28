function fdt_persistence
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   This function use a criterium of persistence in the time for discrimine
%   a filament.
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
%   December, 30. 2013
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fdt_param
filaments = [];

switch method
    
    case 'automatic'
        list = dir([out_dir,'/roms_automatic_*']);
        
        if isempty(list)==1
            error('No Files of Automatic Method');
        end
        
        NF = length(list); dat = [];
        for i1 = 1:NF
            file = [out_dir,'/',list(i1).name];
            load(file)
            dat = [dat;results];
        end
        
        dat = sortrows(dat,1);
        dat = sortrows(dat,2);
        
        while isempty(dat)==0
            
            poslat = dat(1,5); poslon = dat(1,6);
            a1 = dat(:,5)<poslat+tol & dat(:,5)>poslat-tol & dat(:,6)<poslon+tol & dat(:,6)>poslon-tol;
            aux = dat(a1,:);
            
            [pos val] = find(diff(aux(:,2))~=0);
            if isempty(pos)==0 &&  aux(1,1)<1900
                aux(pos+1,3) = aux(pos+1,3)+(val*30);
            elseif isempty(pos)==0 &&  aux(1,1)>1900
                aux(pos+1:end,3) = aux(pos+1:end,3)+(val*eomday(aux(pos+1:end,1),aux(pos+1:end,2)-1));
            end
            
            per = diff(aux(:,3)); con = -2;
            for i4 = 1:length(per)
                cond = per(i4);
                if cond == 1
                    con = con + 1;
                end
            end
            if con >= perdays
                filam = [aux(1,:) con];
                filaments = [filaments; filam];
                rempos = find(a1==1);
                dat(rempos(1:con+1),:)=[];
            else
                dat(1,:)=[];
            end
        end
        
        fileoutput = [out_dir,'/filaments_from_automatic_' num2str(datenum(fix(clock))) '.mat'];
        save(fileoutput,'filaments')
        disp(['Saved results file in  ' fileoutput ])
        
        
        
    case 'assisted'
        list = dir([out_dir,'/roms_assisted_*']);
        
        if isempty(list)==1
            error('No Files of Assisted Method');
        end
        
        NF = length(list); dat = [];
        for i1 = 1:NF
            file = [out_dir,'/',list(i1).name];
            load(file)
            dat = [dat;results];
        end
        
        dat = sortrows(dat,1);
        dat = sortrows(dat,2);
        
        dat(dat(:,9)<lfgt,:)=[];
        
        while isempty(dat)==0
            
            poslat = dat(1,5); poslon = dat(1,6);
            a1 = dat(:,5)<poslat+tol & dat(:,5)>poslat-tol & dat(:,6)<poslon+tol & dat(:,6)>poslon-tol;
            aux = dat(a1,:);
            
            [pos val] = find(diff(aux(:,2))~=0);
            if isempty(pos)==0 &&  aux(1,1)<1900
                aux(pos+1,3) = aux(pos+1,3)+(val*30);
            elseif isempty(pos)==0 &&  aux(1,1)>1900
                aux(pos+1:end,3) = aux(pos+1:end,3)+(val*eomday(aux(pos+1:end,1),aux(pos+1:end,2)-1));
            end
            
            per = diff(aux(:,3)); con = -2;
            for i4 = 1:length(per)
                cond = per(i4);
                if cond == 1
                    con = con + 1;
                end
            end
            if con >= perdays
                filam = [aux(1,:) con];
                filaments = [filaments; filam];
                rempos = find(a1==1);
                dat(rempos(1:con+1),:)=[];
            else
                dat(1,:)=[];
            end
        end
        
        fileoutput = [out_dir,'/filaments_from_assisted_' num2str(datenum(fix(clock))) '.mat'];
        save(fileoutput,'filaments')
        disp(['Saved results file in  ' fileoutput ])
        
end
return
