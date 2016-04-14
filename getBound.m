%
% Get zeta at boundaries
%
close all
clear all
%boundaries

b_south = 1;
b_north = 0;
b_east  = 1;
b_west  = 0;

%output date fomat

dateFormat = 'yyyy-mm-dd';

%output time format

 timeFormat = 'HH:MM:SS';

fileList = dir(['c:\Shared\', '*.nc']);

nc = netcdf(fileList(1).name, 'read');
zeta = nc{'zeta'}(:).data;
[ntimes, etha_max, xi_max ] = size(zeta);
etha_max
xi_max


initTimeText = nc{'dstart'}.units(12:end,1);
formatIn = 'yyyy-MM-dd HH:mm:ss';
t = datetime(initTimeText,'TimeZone','local','Format',formatIn);
dateInit = datestr(t, dateFormat);
timeInit = datestr(t, timeFormat);

Header = ['# channels number' char(10)  '1' char(10) '# samples number' char(10)  '3625' char(10)  '# sampling rate' char(10)  '0.0002777777777777' char(10) ];
Header = [Header, char(10) '# start date' char(10) char(10)  dateInit '# start time' char(10) timeInit char(10) '# channels names' char(10)  '1' char(10) '0' char(10)];
      
%
%    Direction:
%    N->E->S->W
%

fileIdSet = [];

N =  b_north * etha_max + b_east * xi_max + b_south * etha_max + b_west * xi_max;
fclose('all');
for i=1:N
    f = fopen(['e:\testBound\bound_',int2str(i), '.td'], 'w');
    fileIdSet = [fileIdSet, f];
    fprintf(f, '%s',Header);
end

k = 1;
for fileIdx=1:(size(fileList))
    hfname = fileList(fileIdx).name;
    disp(' ')
    disp(['Read nc file = ', hfname])
    disp(' ')
    nc = netcdf(hfname,'read');
    zeta = nc{'zeta'}(:).data;
    for i=1:ntimes
        if (b_north)
            for j=1:etha_max
                z = zeta(i, j, 1);
                if z > 100
                    z = NaN;
                end
                fprintf(fileIdSet(k), '%f\n', z);
                k = k + 1;
            end 
        end
        
        if (b_east)
            for j=etha_max:-1:1
                z = zeta(i, j, xi_max);
                if z > 100
                    z = NaN;
                end
                fprintf(fileIdSet(k), '%f\n', z);
                k = k + 1;
            end 
        end
        
        if (b_south)
            for j=xi_max:-1:1
                z = zeta(i, 1, xi_max);
                if z > 100
                    z = NaN;
                end
                fprintf(fileIdSet(k), '%f\n', z);
                k = k + 1;
            end 
        end
        
        if (b_west)
            for j=xi_max:-1:1
                z = zeta(i, 1, j);
                if z > 100
                    z = NaN
                end
                fprintf(fileIdSet(k), '%f\n', z);
                k = k + 1;
            end 
        end
        k=1;
    end
    close(nc)
end

fclose('all');