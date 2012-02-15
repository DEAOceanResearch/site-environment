
SITE_ENVIRONMENT_DIR='/usr/local/site-environment/flux/'
POINT=[83.5 10];

print_them=true;
print_them=false;

morestate=get(0,'more');
more off

years=[2000:2010];
dat=[	reshape(ones(12,1)*years,length(years)*12,1), repmat([1:12].',length(years),1), ones(length(years)*12,1)*15 ]; 
t=datenum(dat);

files= [ SITE_ENVIRONMENT_DIR 'evapr_oaflux.nc'];
H(1:3)=plot_oaflux(files,t,'evapr', 'Evaporation rate (cm/year)', 'Evaporation',0.1,POINT);

files=[ SITE_ENVIRONMENT_DIR 'lh_oaflux.nc'];
H(end+[1:3])=plot_oaflux(files,t,'lhtfl', 'Monthly Mean (W/m^2)', 'Latent Heat Flux',0.1,POINT);

files=[ SITE_ENVIRONMENT_DIR 'sh_oaflux.nc';
H(end+[1:3])=plot_oaflux(files,t,'shtfl','Monthly Mean (W/m^2)', 'Surface Sensible Heat Flux',0.1,POINT);

files=[ SITE_ENVIRONMENT_DIR 'qa_oaflux.nc'];
H(end+[1:3])=plot_oaflux(files,t,'hum2m','Monthly Mean (g/kg)', 'Specific Humidity at 2m',0.01,POINT);

files=[ SITE_ENVIRONMENT_DIR 'ws_oaflux.nc'];
H(end+[1:3])=plot_oaflux(files,t,'wnd10','Monthly Mean (m/s)', 'Neutral Wind Speed at 10m',0.01,POINT);


files=[ SITE_ENVIRONMENT_DIR 'ts_oaflux.nc'];
H(end+[1:3])=plot_oaflux(files,t,'tmpsf','Monthly Mean ( ^\circ{C})', 'Sea Surface Temperature',0.01,POINT);

files=[ SITE_ENVIRONMENT_DIR 'ta_oaflux.nc'];
H(end+[1:3])=plot_oaflux(files,t,'tmp2m','Monthly Mean ( ^\circ{C})', 'Air Temperature at 2m',0.01,POINT);

% the rest have different time base

years=[1996:2007];
dat=[	reshape(ones(12,1)*years,length(years)*12,1), repmat([1:12].',length(years),1), ones(length(years)*12,1)*15 ]; 
t=datenum(dat);

% 1996-2007
files=[ SITE_ENVIRONMENT_DIR 'qnet.nc'];
H(end+[1:3])=plot_oaflux(files,t,'qnet', 'Monthly Mean (W/m^2)', 'Net Surface Heat Flux',0.1,POINT);

files=[ SITE_ENVIRONMENT_DIR 'lw_isccp.nc'];
H(end+[1:3])=plot_oaflux(files,t,'nlwrs', 'Monthly Mean (W/m^2)', 'Net Surface Longwave Radiation Flux',0.1,POINT);

files=[ SITE_ENVIRONMENT_DIR 'sw_isccp.nc'];
H(end+[1:3])=plot_oaflux(files,t,'nswrs', 'Monthly Mean (W/m^2)', 'Net Surface Shortwave Radiation Flux',0.1,POINT);


% want to print them? Use this
if print_them
   for i=1:length(H), fig_publish(H(i));
	print(H(i),'-depsc',sprintf('oafluxfig%02d.eps',i)); 
   end
end % print_them

more(morestate);

% vi: se nowrap tw=0 :

