
% titlestr='SPURS Site';
titlestr='Bay of Bengal Site';

ARGODATADIR='/usr/local/site-environment/argo/data/';

print_this=false;
print_this=true;
reload=0; 
reload=1; 

morestate=get(0,'more');
more off


Lat=10;
Lon=83.5;

delt=2;

if reload

files=dir([ ARGODATADIR 'nodc_*.nc' ]);

clear t s p H
temp=[]; salt=[]; pres=[]; dept=[];

i=0;

for j=1:length(files)
	disp(files(j).name);

	d=loadcdf([ ARGODATADIR files(j).name ]);

% TODO: check if lat and long are in the required proximity of the site


  if abs(d.longitude-Lon)<=delt/2 && abs(d.latitude-Lat)<=delt/2,


    if isfield(d,'temperature_adjusted'),
	i=i+1;
	lat(i)=d.latitude;
	lon(i)=d.longitude;


	if ischar(d.reference_date_time),
	    mday0=datenum( [ str2num(d.reference_date_time(1:4).'), ...
		str2num(d.reference_date_time(5:6).'), ...
		str2num(d.reference_date_time(7:8).'), ...
		str2num(d.reference_date_time(9:10).'), ...
		str2num(d.reference_date_time(11:12).'), ...
		str2num(d.reference_date_time(13:14).') ] );
	else
	    mday0=datenum([1950 01 01 00 00 00]);
	end
  
	tme(i)=datenum(d.time+mday0);

	t=squeeze(d.temperature_adjusted); I=find(d.temperature_adjusted_qc==1);
	t(I)=NaN;
	J=find(d.temperature_adjusted>50); t(J)=NaN;

	s=squeeze(d.salinity_adjusted); I=find(d.salinity_adjusted_qc==1);
	s(I)=NaN;
	J=find(d.salinity_adjusted>50); s(J)=NaN;

	p=squeeze(d.pressure_adjusted); I=find(d.pressure_adjusted_qc==1);
	p(I)=NaN;
	J=find(d.pressure_adjusted>3500); p(J)=NaN;
	
	J=find(s>36.855 & t<16.4 );
	s(J)=NaN; t(J)=NaN;
	J=find(s<25.000 );
	s(J)=NaN; 

	z=sw_dpth(p,lat(i)); 

	[temp,t]=samerows(temp,t);
	[salt,s]=samerows(salt,s);
	[pres,p]=samerows(pres,p);
	[dept,z]=samerows(dept,z);

	temp(:,i)=t(:);
	salt(:,i)=s(:);
	pres(:,i)=p(:);
	dept(:,i)=z(:);

	
    else
	disp(' no fields');
    end
  end

end
J=find(all(isnan(salt)) & all(isnan(temp)) );
salt(:,J)=[];
temp(:,J)=[];
pres(:,J)=[];
dept(:,J)=[];
lat(J)=[];
lon(J)=[];
tme(J)=[];

% % column 49 is bad
% dept(:,49)=[];
% temp(:,49)=[];
% salt(:,49)=[];
% pres(:,49)=[];
% lat(49)=[];
% lon(49)=[];
% tme(49)=[];


% for i=1:size(salt,2),
% 	[STP(i,:)]=pycnoc([salt(:,i) temp(:,i) pres(:,i)],10);
% end

% and calculate the density
	dens=sw_pden(salt,temp,pres,0);

end % reload

I=find( abs(lon-Lon)<delt/2 & abs(lat-Lat)<delt/2 );

rngy=round(minmax(lat(I)).*10)./10;
rngx=round(minmax(lon(I)).*10)./10;

rng=diff(rngx);

depthrange=[0 250]; 
srange=[30.0 36.0];
trange=[12 33];

% chart
H(1)=figure; plot(lon(I),lat(I),'.');
	% hold on; plot(-38,25,'r*');
	hold on; plot(Lon,Lat,'r*');
	axis('equal');
	xlabel('Longitude');
	ylabel('Latitude');
	title(titlestr);

% density depth
H(2)=figure; plot(dens(:,I)-1000,dept(:,I)); 
	set(gca,'ydir','reverse');
	axis([17.0 27.0  depthrange]);
	xlabel('Potential Density (kg.m^{-3})');
	ylabel('Depth (m)');
	title(titlestr);

% temperature depth
H(3)=figure; plot(temp(:,I),dept(:,I)); set(gca,'ydir','reverse');
	axis([trange depthrange]);
	xlabel('Temperature ( ^\circ{C})');
	ylabel('Depth (m)');
	title(titlestr);

% salinity depth
H(4)=figure; plot(salt(:,I),dept(:,I)); set(gca,'ydir','reverse');
	% axis([36.2 37.7 0 250]);
	axis([srange  depthrange]);
	xlabel('Salinity');
	ylabel('Depth (m)');
	title(titlestr);

% temperature salinity
H(5)=figure; plot(salt(:,I),temp(:,I));
	% axis([31.2 35.2 0 32 ]);
	axis([srange 0 33 ]);
	hold on; % mybox([36.2 37.7], [16 28], 'k' );
	ylabel('Temperature ( ^\circ{C})');
	xlabel('Salinity');
	title(titlestr);

H(6)=figure; plot(tme(I),dept(:,I),'k.');
	datetick;
	set(gca,'ydir','reverse');
	ylabel('Depth (m)');
	title(titlestr);

H(7)=figure;
	scatter(reshape(repmat(tme(I),size(dept,1),1),prod(size(dept(:,I))),1), ...
		reshape(dept(:,I),[],1),20,reshape(temp(:,I),[],1),'filled');
	datetick;
	set(gca,'ydir','reverse');
	ylabel('Depth (m)');
	title(['Temperature within ' num2str(rng./2) '^\circ{} of ' titlestr]);

H(8)=figure;
	scatter(reshape(repmat(tme(I),size(dept,1),1),prod(size(dept(:,I))),1), ...
		reshape(dept(:,I),[],1),20,reshape(salt(:,I),[],1),'filled');
	datetick;
	set(gca,'ydir','reverse');
	ylabel('Depth (m)');
	title(['Salinity within ' num2str(rng./2) '^\circ{} of ' titlestr]);


more(morestate);

if print_this
    for i=1:length(H),
	fig_publish(H(i)); print(H(i),'-depsc', [ 'argo_' num2str(i) '_' num2str(rng) 'deg.eps']);
    end
end

% vim: se tw=0 nowrap :

