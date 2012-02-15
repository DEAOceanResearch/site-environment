
% Running on host: erica
% Starting in directory: 
% /erica/home/duncombe/WORK/WHOI/TOM/SPURS/waves/AVISO/wind-wave/nrt/mswh/merged

% /home/duncombe/WORK/WHOI/TOM/SPURS/waves/AVISO/wind-wave/nrt/mswh/merged

% cd /erica/home/duncombe/WORK/WHOI/TOM/SPURS/waves/test
SITE_ENVIRONMENT_DIR='/usr/local/site-environment/waves/data/';
POINT=[83.5 10];

titlestr='Bay of Bengal Site';

print_this=1;
print_this=0;

% of.nc has global wave record
if exist('S','var')~=1,  S=[]; end;
% if sizeof(S)~=417861760, S=loadcdf('of.nc'); end;
% if sizeof(S)~=417861760, 
% FUCK! sizeof returns values that vary from machine to machine!
% Try something else
if ~isstruct(S) || ~isfield(S,'Grid_0001')
	disp('Reloading data');
	S=loadcdf([ SITE_ENVIRONMENT_DIR 'aviso_global_swh.nc']); 
end

%   Name          Size               Bytes  Class     Attributes
% 
%   cdfdata       1x1             28002616  struct              
%   fid           1x1                    8  double              
%   fname         1x5                   10  char                
%   i             1x1                    8  double              
%   name          1x6                  786  cell                
%   ndims         1x1                    8  double              
%   ngatts        1x1                    8  double              
%   nvars         1x1                    8  double              
%   status        1x1                    8  double              
%   unlimdim      1x1                    8  double              

% S = 
% 
%           header: ''
%           LatLon: [2x1 int32]
%      NbLatitudes: [180x1 double]
%     NbLongitudes: [360x1 double]
%        LatLonMin: [2x108 double]
%       LatLonStep: [2x108 double]
%        Grid_0001: [180x360x108 single]

% figure; plot(squeeze(S.Grid_0001(116,322,:)))

% SPURS
% J=find(S.NbLatitudes==25);
% I=find(S.NbLongitudes==wrapTo360(-38));


ceilfloor=@(x)([floor(x) ceil(x)]);

% Bay of Bengal
J=find(S.NbLatitudes==POINT(2));
I=between(S.NbLongitudes,wrapTo360(ceilfloor(POINT(1))));

% time base
tb=load([ SITE_ENVIRONMENT_DIR 'tb.dat' ]);

SWH=(squeeze(S.Grid_0001(J,I,:)));
SWH(SWH>100)=NaN;

% B=S.Grid_0001(115:117,321:323,:);
% A=reshape(B,9,806);
% swh=mean(A);
% swh(swh>100)=NaN; 

t=datenum(tb);

clear H

yax=[0 6];
xax=[734000 734866];

H(1)=figure;
	plot(t,SWH)
	% axis('tight');
	yaxis(yax);
	xaxis(xax);
	datetick('keeplimits');
	title(titlestr);
	xlabel('Date');
	ylabel('AVISO SWH (m)');

H(2)=figure;
	boxplot(SWH);
	yaxis(yax);
	set(gca,'xtickLabel',titlestr);
	set(gca,'xtick',1);
	ylabel('AVISO SWH (m)');
	xlabel([]);

if print_this
	for i=1:length(H)
		fig_publish(H(i));
		print(H(i),'-depsc',['waves_fig_' num2str(i) '.eps']);
	end
end

