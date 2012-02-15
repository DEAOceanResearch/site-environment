
% titlestr='SPURS Site';
titlestr='Bay of Bengal Site';
POINT=[83.5 10];

SITE_ENVIRONMENT_DIR='/usr/local/site-environment/precip/';

morestate=get(0,'more');
more off;

print_them=false;
print_them=true;

data_loaded=1;
data_loaded=0;

if ~data_loaded

H=[];

% files={'gpcp_1dd_v1.1_p1d.199610','gpcp_1dd_v1.1_p1d.199702'};
files=dir([SITE_ENVIRONMENT_DIR 'gpcp_1dd*']);

% n=36;
n=length(files);

Mday=[];
Spurs=[];

% for i=1:length(files),
for i=1:n,

	fid=fopen([SITE_ENVIRONMENT_DIR files(i).name],'r','ieee-be');
	disp(files(i).name);

	% header is always 1440 bytes; data is the rest 
	hdr=fread(fid,1440,'char');
	% data is in units of mm/day (according to header information)
	data=fread(fid,inf,'single');
	fclose(fid);

	% can display header in a readable way by doing this:
	% disp(reshape(char(hdr.'),80,length(hdr)/80).');

	% data is in columns, rows, days. find the days
	ndays=length(data)/360/180;
	Precip=reshape(data,360,180,ndays);
	datestr=files(i).name(end-5:end);

	% now Precip is global grids
	% extract our site data. lon,lat,day
	lat=89.5:-1:-89.5;
	lon=wrapTo180([0.5:1:359.5]);
	mday=datenum([str2num(datestr(1:4)) str2num(datestr(5:6)) 0])+[1:ndays].';

	% % This code makes a movie of the global precipitation
	% figure; 
	% for i=1:size(Precip,3), 
	% 	pcolor(Precip(:,:,i).'); 
	% 	shading flat; 
	% 	set(gca,'ydir','reverse'); 
	% 	pause(0.3); 
	% end

	% pick out the site
	% I=find(lon<-37 & lon>-39);
	I=between(lon,POINT(1)+[-1 1]);
	J=between(lat,POINT(2)+[-1 1]);

	% calculate the mean over the site
	spurs=mean(reshape(Precip(I,J,:),length(I)*length(J),ndays));

	% construct long time series
	Mday=[Mday, mday.']; % keep 'em the same shape
	Spurs=[Spurs, spurs]; 

end %  for i=1:length(files),

% now draw some pictures: a time series and some seasonal and averages 

DV=datevec(Mday);

% BULLSHIT!
% % bin it like this:
% yrs=[min(DV(:,1)):max(DV(:,1))]; % every year
% mth=1:12;
% bins=[datenum( ...
% 	[reshape(repmat(yrs,12,1),length(yrs)*12,1) ...
% 	repmat(mth,1,length(yrs)).' ...
% 	zeros(length(yrs)*12,1)] ); inf];

P=nan(12,1);
N=nan(12,1);
for j=1:12,
	K=find(DV(:,2)==j);
	P(j)=sum(Spurs(K)); % sum each months rainfall
	% N(j)=sum(uniq(DV(:,2))==j); % count how many years of data there are
	N(j)=length(unique(DV(K,1))); % count how many years of data there are
	% calculate the monthly rainfall as P(:)./N(:)
end

% fetch out the monthly data a different way as monthly totals
[Y,K]=uniq(DV(:,1:2)); % identify unique rows of [year month]
K(end+1)=size(DV,1)+1; % make a necessary adjustment for our purpose to returned K
MP=nan(length(K)-1,1); % total monthly precip
for i=1:length(K)-1, % how do I GET RID of the LOOP!?!?
	I=K(i):[K(i+1)-1];
	MP(i)=sum(Spurs(I)); % total monthly precip
end

end % ~data_loaded

H(1)=figure;
	plot(Mday,Spurs);
	datetick('x',12,'keepticks','keeplimits');
	xlabel('Date');
	ylabel('Precipitation (mm/day)');
	title(titlestr);

H(2)=figure;
	plot(P(:)./N(:));
	set(gca,'xtick',1:12,'xticklabel','JFMAMJJASOND'.','xlim',[0 13]);
	xlabel('Month');
	ylabel('Mean Monthly Precipitation (mm/month)' );
	title(titlestr);

H(3)=figure;
	boxplot(Spurs,DV(:,2));
	yaxis([0,65]);
	set(gca,'xtick',1:12,'xticklabel','JFMAMJJASOND'.','xlim',[0 13]);
	xlabel('Month');
	ylabel('Daily Precipitation by Month (mm/day)');
	title(titlestr);

H(4)=figure;
	boxplot(MP,DV(K(1:end-1),2));
	set(gca,'xtick',1:12,'xticklabel','JFMAMJJASOND'.','xlim',[0 13]);
	yaxis([0,330]);
	ylabel('Monthly Precipitation (mm/month)' );
	xlabel('Month');
	title(titlestr);

H(5)=figure;
	boxplot(MP);
	% set(gca,'xticks',1:12);
	yaxis([0,330]);
	ylabel('Monthly Precipitation (mm/month)');
	% xlabel('Month');
	title(titlestr);


if print_them
	for i=1:length(H),
		fig_publish(H(i));
		print(H(i),'-depsc',['gpcp_fig_' num2str(i) '.eps']);
	end
end

more(morestate); 

% vim: se nowrap tw=0 :

