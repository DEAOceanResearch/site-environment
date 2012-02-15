% matlab script

titlestr='Bay of Bengal Site';
printfigs=true;

morestate=get(0,'more');
more off

alreadyloaded=1;

if ~alreadyloaded,

files=dir('qscat*');

% we have to set up some variables, so load one file example to get some of the parameters
[WS,WD]=get_scat_averaged_v04('qscat_19990724v4');
[m,n]=size(WS);

lat=[1:n].*0.25-90.125;
lon=[1:m]*0.25-0.125;

% posn=wrapTo360([-39 -37 24 26]);
posn=wrapTo360([88 90 17 19]);

I=between(lon,posn(1:2));
J=between(lat,posn(3:4));



DV=nan(3,length(files));
WS=nan(length(I),length(J),length(files));
WD=nan(length(I),length(J),length(files));
SF=nan(length(I),length(J),length(files));
RR=nan(length(I),length(J),length(files));

for i=1:length(files)
	[windspd,winddir,scatflag,radrain]=get_scat_averaged_v04(files(i).name);
	dv=[str2num(files(i).name(7:10)) str2num(files(i).name(11:12)) str2num(files(i).name(13:14))];


	DV(:,i)=dv;
	WS(:,:,i)=windspd(I,J);
	WD(:,:,i)=winddir(I,J);
	SF(:,:,i)=scatflag(I,J);
	RR(:,:,i)=radrain(I,J);
end;

end %  alreadyloaded

clear FH

titlestr='RSS wind speeds';

FH(1)=figure; plot(datenum(DV.'),mean(reshape(WS,64,539)));
	datetick('keeplimits');
	title(titlestr);
	xlabel('Date');
	ylabel('Wind Speed (m/s)');
	yaxis([0 16]);



FH(2)=figure; boxplot(mean(reshape(WS,64,539)),DV(2,:));
	title(titlestr);
	xlabel('Month')
	ylabel('Wind Speed (m/s)');
	set(gca,'xtick',1:12,'xticklabel',['JFMAMJJASOND'].');
	yaxis([0 16]);


FH(3)=figure; boxplot(WS(:));
	title(titlestr);
	ylabel('Wind Speed (m/s)');
	xlabel(titlestr);
	yaxis([0 16]);



more(morestate);

if printfigs
    for i=1:length(FH),
	fig_publish(FH(i));
	print(FH(i),'-depsc',['ssmi_fig_' num2str(i)  '.eps']);
    end
end

% vim: se nowrap tw=0 :

