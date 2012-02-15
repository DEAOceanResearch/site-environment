function h=plot_oaflux(filename,t,varname,Ylabel,Title,scl,point)

if exist('point','var')~=1, error('Provide sampling point'); end

if exist('scl','var')~=1, scl=[]; end;
if isempty(scl), scl=1; end;

% E=loadcdf('evapr_oaflux.nc');
E=loadcdf(filename);

nyrs=size(E.(varname),4);

% dat=[	reshape(ones(12,1)*[2000:2010],11*12,1), repmat([1:12].',11,1), ones(11*12,1)*15 ];

% t=datenum(dat);

% i=(360-(37:38));
i=between(wrapTo180(E.lon),point(1)+[-1 1]);
% j=(90+(25:26));
j=between(E.lat,point(2)+[-1 1]);

% e=reshape(E.evapr(i,j,:,:),4,12,11);

% keyboard
e=reshape(E.(varname)(i,j,:,:).*scl,length(i)*length(j),12,nyrs);

% time series
disp([ filename ' ' varname ' ' num2str(minmax(e(:))) ]);

d=datevec(t); 

f=squeeze(mean(e,1));
h(1)=figure; plot(t,f(:));
	title(Title)
	xlabel('Date')
	ylabel(Ylabel)
	xaxis(datenum([min(d(:,1)) 1 0;max(d(:,1))+1 1,0]));
	% set(gca,'xticklabel',['JFMAMJJASOND'].');
	datetick('keeplimits','keepticks')

% seasonal

h(2)=figure; plot(mean(f.'));
	title(Title)
	xlabel('Month')
	ylabel(Ylabel)
	axis tight
	set(gca,'xtick',[1:12],'xticklabel',['JFMAMJJASOND'].');


% stats

h(3)=figure; boxplot(f(:));
	hold on; plot(1,mean(f(:)),'gd','markerfacecolor','g'); 
	set(gca,'xtick',1,'xticklabel',['Bay of Bengal Site']);
	ylabel(Ylabel)
	title(Title)


