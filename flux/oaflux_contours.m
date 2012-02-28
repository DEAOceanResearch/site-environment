
SITE_ENVIRONMENT_DIR='/usr/local/site-environment/flux/';
RANGE=[75,100,5,25]; 
print_them=false;
print_them=true; 
clear H 
morestate=get(0,'more');
more off

tspan=[2000:2010];
years=[4 find(tspan==2007)];
% dat=[	reshape(ones(12,1)*years, length(years)*12,1), repmat([1:12].', ...
	% length(years),1), ones(length(years)*12,1)*15 ]; 
% t=datenum(dat);

files= [ SITE_ENVIRONMENT_DIR 'evapr_oaflux.nc'];


% disp('here')


% pause


H(1)=contour_oaflux(files,'evapr', years, 'Evaporation rate (cm/year)', ...
		'Evaporation',0.1,RANGE);

files=[ SITE_ENVIRONMENT_DIR 'lh_oaflux.nc'];
H(end+1)=contour_oaflux(files,'lhtfl', years, 'Monthly Mean (W/m^2)', ...
		'Latent Heat Flux',0.1,RANGE);

files=[ SITE_ENVIRONMENT_DIR 'sh_oaflux.nc'];
H(end+1)=contour_oaflux(files,'shtfl', years,'Monthly Mean (W/m^2)', ...
		'Surface Sensible Heat Flux',0.1,RANGE);

files=[ SITE_ENVIRONMENT_DIR 'qa_oaflux.nc'];
H(end+1)=contour_oaflux(files,'hum2m', years,'Monthly Mean (g/kg)', ...
		'Specific Humidity at 2m',0.01,RANGE);

files=[ SITE_ENVIRONMENT_DIR 'ws_oaflux.nc'];
H(end+1)=contour_oaflux(files,'wnd10', years,'Monthly Mean (m/s)', ...
		'Neutral Wind Speed at 10m',0.01,RANGE);


files=[ SITE_ENVIRONMENT_DIR 'ts_oaflux.nc'];
H(end+1)=contour_oaflux(files,'tmpsf', years,'Monthly Mean ( ^\circ{C})', ...
		'Sea Surface Temperature',0.01,RANGE);

files=[ SITE_ENVIRONMENT_DIR 'ta_oaflux.nc'];
H(end+1)=contour_oaflux(files,'tmp2m', years,'Monthly Mean ( ^\circ{C})', ...
		'Air Temperature at 2m',0.01,RANGE);

% the rest have different time base

tspan=[1996:2007]; 
years=[4 find(tspan==2007)];

% dat=[	reshape(ones(12,1)*years,length(years)*12,1), ...
	% repmat([1:12].',length(years),1), ones(length(years)*12,1)*15 ]; 
% t=datenum(dat);

% 1996-2007
files=[ SITE_ENVIRONMENT_DIR 'qnet.nc'];
H(end+1)=contour_oaflux(files,'qnet', years, 'Monthly Mean (W/m^2)', ...
		'Net Surface Heat Flux',0.1,RANGE);

files=[ SITE_ENVIRONMENT_DIR 'lw_isccp.nc'];
H(end+1)=contour_oaflux(files,'nlwrs', years, 'Monthly Mean (W/m^2)', ...
		'Net Surface Longwave Radiation Flux',0.1,RANGE);

files=[ SITE_ENVIRONMENT_DIR 'sw_isccp.nc'];
H(end+1)=contour_oaflux(files,'nswrs', years, 'Monthly Mean (W/m^2)', ...
		'Net Surface Shortwave Radiation Flux',0.1,RANGE);


% want to print them? Use this
if print_them
   for i=1:length(H), 
	fig_publish(H(i));
	% print(H(i),'-depsc',sprintf('oafluxcontours%02d.eps',i)); 
	print(H(i),'-dpng',sprintf('oafluxcontours%02d.png',i)); 
   end
end % print_them

more(morestate);

% vi: se nowrap tw=0 :

