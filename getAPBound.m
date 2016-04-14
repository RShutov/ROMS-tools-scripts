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
DST_CONNECTION = ' ./okhotsk-test/tides.csv';
DATE_0_S = '20070101 00:05';
DATE_0_F = '20070831 23:59';
TIMESTEP = 60;
file = 'e:\ROMS_FILES\roms_frc_tidal.nc';
header = [
    'ACTION=80' char(10) ...
    'ACTION_SUB=COMPOSITION' char(10) ...
    'DST_CONNECTION=' DST_CONNECTION ';' char(10) ...
    'DATE_0_S=' DATE_0_S char(10) ...
    'DATE_0_F=' DATE_0_F char(10) ...
    'PARAMS=' char(10) ...
    '@timeStep=' int2str(TIMESTEP) ';' char(10)...
   ]
nc = netcdf(file, 'read');
Amp = nc{'tide_Eamp'}(:);
Phs = nc{'tide_Ephase'}(:);
Aplitudes = [];
Phases = [];
[tideCount, etha_max, xi_max ] = size(Amp);

Tides = char(strsplit(strtrim(nc.components(:)),' '));

%    Direction:
%    N->E->S->W
%

fileIdSet = [];

N =  b_north * etha_max + b_east * xi_max + b_south * etha_max + b_west * xi_max;
 fclose('all');
 
k = 1;

for i=1:N
    f = fopen(['e:\testBound\bound_',int2str(i), '.td'], 'w');
    fileIdSet = [fileIdSet, f];
    fprintf(f, '%s', header);
end

while k < N
    if (b_north)
        for j=1:etha_max
            fprintf(fileIdSet(k), '%s', strAP(1, j, Amp, Phs, Tides));
             k = k + 1;
        end 
    end

    if (b_east)
        for j=etha_max:-1:1
            fprintf(fileIdSet(k), '%s', strAP(xi_max, j, Amp, Phs, Tides));
            k = k + 1;
        end 
    end

    if (b_south)
        for j=xi_max:-1:1
              fprintf(fileIdSet(k), '%s', strAP(xi_max, 1, Amp, Phs, Tides));
              k = k + 1;
        end 
    end

    if (b_west)
        for j=xi_max:-1:1
            fprintf(fileIdSet(k), '%s', strAP(j, 1, Amp, Phs, Tides));
            k = k + 1;
        end 
    end
end


fclose('all');