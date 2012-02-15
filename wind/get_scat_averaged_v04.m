function [windspd,winddir,scatflag,radrain]=get_scat_averaged_v04(filename)
%this subroutine will read the RSS scatterometer time-averaged bytemaps (3-day, week, month).
%reads version-3a files released October 2006
%reads version-4 files released April 2011
%
%input argument is the full path file name:
%   get_scat_averaged_v04(filename)
%
%output arguments:
%   [windspd,winddir,scatflag,radrain]
%   windspd in m/s	(10 meter surface wind)
%   winddir in degrees 	(oceanographic convention, blowing North = 0)
%   scatflag		(0=no rain, 1=rain)
%   radrain   in km*mm/hr  (-999.0 = no collocation available)
%                       (  -1.0 = adjacent cells had rain, but not this cell)
%                       (   0.0 = radiometer data exist and show no rain)
%				(   0.5 - 31.0 = columnar rain rate in km*mm/hr)
%
%  The center of the first cell of the 1440 column and 720 row map is at 0.125 E longitude and -89.875 latitude.
%  The center of the second cell is 0.375 E longitude, -89.875 latitude.
% 		XLAT=0.25*ILAT-90.125
%		XLON=0.25*ILON-0.125
%
% Data from the daily files are scalar (wind speed) and vector (wind direction) averaged
% to produce the values in the time-averaged files.  A data value for a given cell is only provided in a 
% time-averaged file if a minimum number of data exist within the time period being produced
% (3-day maps, 2 obs;  week maps, 5 obs;  month maps, 20 obs)
%
%  3-day   = (average of 3 days ending on file date)
%  weekly  = (average of 7 days ending on Saturday of file date)
%  monthly = (average of all days in month)
%
%please read the description file on www.remss.com
%for infomation on the various fields, or contact RSS support:
% http://www.remss.com/support
%
%

xscale=[.2,1.5];
xdim=1440;ydim=720;numvar=3;
mapsiz=xdim*ydim;

if ~exist(filename)
    % file does not exist
    error = ['file not found: ', filename]
    windspd=[];winddir=[];scatflag=[];radrain=[];
    return;
end;


fid=fopen(filename,'rb');
data=fread(fid,mapsiz*numvar,'uint8');
fclose(fid);
filename
map=reshape(data,[xdim ydim numvar]);

    for ivar=1:numvar,
        if ivar<3,
		dat=map(:,:,ivar);
            map(:,:,ivar) = dat*xscale(ivar);
        else,
            dat=map(:,:,ivar);
            scatflag(:,:) = dat-2*fix(dat/2); % bit 1
            rad_flag(:,:) = fix((dat-4*fix(dat/4))/2); % bit 2
            temp=fix(dat/4); % bits 3-8
            temp2 = -999*ones(size(dat));
            rflag=rad_flag(:,:);
            for j=1:prod(size(temp2))
                if rflag(j)==1
                    if temp(j)==0
                        temp2(j)=0;
                    elseif temp(j)==1
                        temp2(j)=-1;
                    else
                        temp2(j)=temp(j)/2-0.5;
                    end;
                end;
            end;  % j loop
            radrain(:,:)=temp2;
        end;   % 
    end;	  % ivar loop

windspd = map(:,:,1);
winddir = map(:,:,2);

index = find(windspd > 50.0);
windspd(index) = -999.;
winddir(index) = -999.;
scatflag(index)= -999.;
radrain (index)= -999.;
    
return;



