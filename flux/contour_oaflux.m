function [h,co0,co1]=contour_oaflux(filename,varname,yr,Ylabel,Title,scl,range)

% yr is an index to which [month year] to plot
% range is [W E S N]

if exist('yr','var')~=1, yr=[]; end

if exist('range','var')~=1, error('Provide sampling area'); end

if exist('scl','var')~=1, scl=[]; end;
if isempty(scl), scl=1; end;

% E=loadcdf('evapr_oaflux.nc');
E=loadcdf(filename);

if isempty(yr), yr=[1 size(E.(varname),4)]; end % choose january of last year
if length(yr)==1, yr=[1 yr]; end % if you give me only a year, use month of january

I=find(E.(varname)>32765);
E.(varname)(I)=NaN;

% i=(360-(37:38));
i=between(wrapTo180(E.lon),range(1:2));
% j=(90+(25:26));
j=between(E.lat,range(3:4));

% keyboard
% e=reshape(E.(varname)(i,j,:,:).*scl,length(i)*length(j),12,nyrs);

% time series
% disp([ filename ' ' varname ' ' num2str(minmax(e(:))) ]);

e=scl.*E.(varname)(i,j,yr(1),yr(2)).';

h(1)=figure;
	m_proj('Mercator','latitudes',range(3:4),'longitudes',range(1:2));
	[cout,H]=m_contourf(E.lon(i),E.lat(j),e);

% keyboard

	m_coast('speckle');
	m_grid;
	title(Title);
	xlabel(Ylabel);
	[co0,co1]=ecolorbar(e,'bo');
	set(co1,'position',[0.13 0.08 0.775 0.04]);

	% colorbar('southoutside');
	% colorbarf(cout,H,'horiz');
	% cbarf(e,cout,'horiz','linear');

% d=datevec(t); 

% f=squeeze(mean(e,1));
% h(1)=figure; plot(t,f(:));
	% title(Title)
	% xlabel('Date')
	% ylabel(Ylabel)
	% xaxis(datenum([min(d(:,1)) 1 0;max(d(:,1))+1 1,0]));
	% set(gca,'xticklabel',['JFMAMJJASOND'].');
	% datetick('keeplimits','keepticks')

% seasonal

% h(2)=figure; plot(mean(f.'));
	% title(Title)
	% xlabel('Month')
	% ylabel(Ylabel)
	% axis tight
	% set(gca,'xtick',[1:12],'xticklabel',['JFMAMJJASOND'].');


% stats

% h(3)=figure; boxplot(f(:));
	% hold on; plot(1,mean(f(:)),'gd','markerfacecolor','g'); 
	% set(gca,'xtick',1,'xticklabel',['Bay of Bengal Site']);
	% ylabel(Ylabel)
	% title(Title)


