clear
clc

% load ../codigo/OUTPUT/filaments_from_automatic_735770.5269.mat
% load ../codigo/OUTPUT/filaments_from_automatic_735976.7249.mat
load ../codigo/OUTPUT/filaments_from_automatic_736091.6775.mat


% load ../codigo/OUTPUT_201507/filaments_from_automatic_736174.7221.mat
results = filaments;
lim = 20;

latb = -15:-1:-35;
NF = [];
for i1 = latb;
  NF = [NF sum(round(results(:,5))==i1)];
end

coast = load('coast.dat');
lonmenos = find(coast(:,1)> -70.6);
latmenos = find(coast(lonmenos,2) < -29.0);
coast(lonmenos(latmenos),:) = [];


% Figure
screen_size = get(0, 'ScreenSize');
z1=figure(1);clf
set(z1, 'Position', [0 0 screen_size(3) screen_size(4) ] );
set(z1,'color',[1 1 1])


subplot(1,3,1)
set(gca,'fontname','arial','fontsize',8);%,'fontweight','bold');
h1 = barh(latb,NF,0.5);
x = get(h1,'YData');
y = -15.5:-1:-35.5;
for i1=1:numel(y)-1
    text(x(i1)+3,y(i1)+.2,num2str(x(i1)),...
               'HorizontalAlignment','center',...
               'VerticalAlignment','bottom')
end

% set(gca,'ylim',[-35 -15])
axis([0 50 -35.5 -14.5])
set(h1,'facecolor',[0 0 0]);
% set(h1,'xdata',linspace(-15.5,-34.5,21));
xlabel('Number (#)','fontname','arial','fontsize',8);%,'fontweight','bold');
ylabel('Latitude','fontname','arial','fontsize',8);%,'fontweight','bold');
haxes1 = gca; 
haxes1_pos = get(haxes1,'Position'); 
haxes1_pos = [0.1300 0.1166    0.1962    0.8235]; 
set(haxes1,'Position',haxes1_pos);
haxes2 = axes('Position',haxes1_pos,...
    'XAxisLocation','top',...
    'YAxisLocation','right',...
    'Color','none');
line(coast(:,1),coast(:,2),'Parent',haxes2,'Color','k');
text(-72.5,-16,'a)','fontname','arial','fontsize',8);%,'fontweight','bold')
set(haxes2,'xtick',[]);set(haxes2,'ytick',[]);






subplot(1,3,2)
set(gca,'fontname','arial','fontsize',8);%,'fontweight','bold');
LF = nan(12,21);
con=0;
for i1 = latb;
  con=con+1;
  aux = results(round(results(:,5))==i1,9);
  laux = length(aux);
  for i2 = 1:laux
      LF(i2,con) = aux(i2);
  end
end


h2 = boxplot(fliplr(LF),'orientation', 'horizontal','labels',{'','','','','','','','','','','','','','','','','','','','',''},'colors',[.1 .1 .1]);
xlabel('Length (km)','fontname','arial','fontsize',8);%'fontweight','bold');
haxes3 = gca; 
haxes3_pos = get(haxes3,'Position'); 
haxes4 = axes('Position',haxes3_pos,...
    'XAxisLocation','top',...
    'YAxisLocation','right',...
    'Color','none');
line(coast(:,1),coast(:,2),'Parent',haxes4,'Color','k')
text(-72.5,-16,'b)','fontname','arial','fontsize',8);%,'fontweight','bold')
set(haxes4,'xtick',[]);set(haxes4,'ytick',[]);


subplot(1,3,3)
set(gca,'fontname','arial','fontsize',8);%,'fontweight','bold');
PF = nan(12,21);
con=0;
for i1 = latb;
  con=con+1;
  aux = results(round(results(:,5))==i1,11);
  laux = length(aux);
  for i2 = 1:laux
      PF(i2,con) = aux(i2);
  end
end

h3 = boxplot(fliplr(PF),'orientation', 'horizontal','labels',{'','','','','','','','','','','','','','','','','','','','',''},'colors',[.1 .1 .1]);
xlabel('Persistence (days)','fontname','arial','fontsize',8);%,'fontweight','bold');
haxes5 = gca; 
haxes5_pos = get(haxes5,'Position'); 
haxes6 = axes('Position',haxes5_pos,...
    'XAxisLocation','top',...
    'YAxisLocation','right',...
    'Color','none');
line(coast(:,1),coast(:,2),'Parent',haxes6,'Color','k')
text(-72.5,-16,'c)','fontname','arial','fontsize',8);%,'fontweight','bold')
set(haxes6,'xtick',[]);set(haxes6,'ytick',[]);


print('-dtiff','-r300','fig7_espacial')
