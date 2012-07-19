
% first run argo to generate the data we need
% then:

% R=dens(:); % rho (potential density)
R=sw_dens(salt(:),temp(:),pres(:));
D=dept(:); % 
G=nan(size(D));
B=nan(size(D));

fh=0;
fh=fh+1; h(fh)=figure; plot(R,D,'.'); 
	set(gca,'ydir','reverse'); 
	axis([1024 1030 0 500]);
	ylabel('Depth');
	xlabel('Density (kg.m^{-3})');
	title('SPURS Site');

% split into bins and use grpstats
% splitting into bins is done by rounding
% bins are average around the centers of the bins so the bin value is taken
% from the center of the bin

% for depths < 200 then 10 is a good bin size
dd=10; % 0 to 10, 10 to 20, etc
II=find(D<200); G(II)=round((D(II)+dd/2)/dd);
B(II)=round(G(II))*dd-dd/2;

% for depths > 200 & < 400 then 20 is a good bin size
dd=25; % 0 to 10, 10 to 20, etc
JJ=find(D>200); G(JJ)=round((D(JJ)+dd/2)/dd);
B(JJ)=round(G(JJ))*dd-dd/2;

dbins=unique(sort(B(~isnan(B))));

M=grpstats(R, B, @(x)(prctile(x,[0 2.5 25 50 75 97.5 100] ).'));
N=grpstats(R, B, @(x)(sum(~isnan(x))) );

fh=fh+1; h(fh)=figure; plot(N.',dbins,'.-'); 
	set(gca,'ydir','reverse'); yaxis([ 0 500]);
	ylabel('Depth');
	xlabel('Data points per bin');
	title('SPURS Site');


fh=fh+1; h(fh)=figure; plot(M.',dbins,'.-'); 
	set(gca,'ydir','reverse'); axis([1024 1030 0 500]);
	ylabel('Depth');
	xlabel('Density (kg.m^{-3})');
	legend({'Minimum', '2.5%', '25%', 'Median', '75%', '97.5%', 'Maximum'},'location','northeast');
	title('SPURS Site');

DS=[dbins(1:35), M(1:35,:), N(1:35)];
col_ids={'Depth','Minimum', '2.5%', '25%', 'Median', '75%', '97.5%', 'Maximum','Number of points'};
save('density_summary','DS','col_ids');

for i=1:fh
	print(h(i),'-dpsc',['density_summary_fig_' num2str(i) '.ps']);
end


% vi: se nowrap tw=0 :
