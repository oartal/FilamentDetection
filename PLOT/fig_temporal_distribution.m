clear
clc

% load ../codigo/OUTPUT/filaments_from_automatic_735770.5269.mat
% load ../codigo/OUTPUT/filaments_from_automatic_735976.7249.mat

load ../codigo/OUTPUT/filaments_from_automatic_736091.6775.mat % Este se uso para el paper

% load ../codigo/OUTPUT_201507/filaments_from_automatic_736174.7221.mat
results = filaments;

%%figure
screen_size = get(0, 'ScreenSize');
z1=figure(1);clf
set(z1, 'Position', [0 0 screen_size(3) screen_size(4) ] );
set(z1,'color',[1 1 1])


subplot(3,1,1)
set(gca,'fontname','arial','fontsize',12);%,'fontweight','bold');
nbar=[];
for i1 = 1:12;
    aux = results(results(:,2)==i1,:);
    nbar = [nbar length(aux(:,1))];
end

% for mm = 1:12
%     fx(mm) = datenum(2000,mm,15);
% end

fx = 1:12;

haxes1 = gca; 
haxes1_pos = get(haxes1,'Position'); 
h = bar(fx,nbar,'k');

x = get(h,'XData'); y = get(h,'YData');
for i1=1:numel(y)
    text(x(i1),y(i1),num2str(y(i1)),...
               'HorizontalAlignment','center',...
               'VerticalAlignment','bottom')
end

% set(gca,'xticklabel',{'J','F','M','A','M','J','J','A','S','O','N','D'});
set(gca,'XTickLabel',{' '},'XAxisLocation','bottom')
set(gca,'Position',[0.1231 0.7093 0.7851 0.1975]);
set(gca,'fontname','arial','fontsize',12);%,'fontweight','bold');
ylabel('Number (#)','fontname','arial','fontsize',12);%,'fontweight','bold');
text(11.75,90,'a)','fontname','arial','fontsize',12);%,'fontweight','bold')
% set(gca,'xlim',[0.5 12.5])
axis([0.5 12.5 0 100])


subplot(3,1,2)
set(gca,'fontname','arial','fontsize',12);%,'fontweight','bold');
LF = nan(500,12);
con=0;
for i1 = 1:12;
  con=con+1;
  aux = results(results(:,2)==i1,9);
  laux = length(aux);
  for i2 = 1:laux
      LF(i2,con) = aux(i2);
  end
end

boxplot(LF,'labels',{'J','F','M','A','M','J','J','A','S','O','N','D'},'colors',[.1 .1 .1])
set(gca,'XTickLabel',{' '})
haxes2 = gca; 
haxes2_pos = get(haxes2,'Position');
set(gca,'fontname','arial','fontsize',12);%,'fontweight','bold');
ylabel('Length (km)','fontname','arial','fontsize',12);%,'fontweight','bold');
text(11.75,1000,'b)','fontname','arial','fontsize',12);%,'fontweight','bold')
axis([0.5 12.5 0 1100])



subplot(3,1,3)
set(gca,'fontname','arial','fontsize',12);%,'fontweight','bold');
PF = nan(500,12);
con=0;
for i1 = 1:12;
  con=con+1;
  aux = results(results(:,2)==i1,11);
  laux = length(aux);
  for i2 = 1:laux
      PF(i2,con) = aux(i2);
  end
end

boxplot(PF,'labels',{'J','F','M','A','M','J','J','A','S','O','N','D'},'colors',[.1 .1 .1])
haxes3 = gca; 
haxes3_pos = get(haxes3,'Position');
set(gca,'fontname','arial','fontsize',12);%,'fontweight','bold');
ylabel('Persistence (days)','fontname','arial','fontsize',12);%,'fontweight','bold');
text(11.75,30,'c)','fontname','arial','fontsize',12);%,'fontweight','bold')

print('-dpng','-r300','fig8_temporal')


