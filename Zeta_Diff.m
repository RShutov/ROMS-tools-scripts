%==================================
%   zetaDiff.m
%==================================

format long
zetaConfig
formatIn = 'yyyy-MM-dd HH:mm:ss';
% refNum is a timestamp
% datestr(refNum,'yyyy-mm-dd HH:MM:SS.FFF');
fileList1 = dir([dataPath, '*.nc']);
fileList2 = dir([dataPath, '/test/*.nc']);


average = 0;

dates = [];
dates2 = [];
dataOut =[];
dataOut2 = [];

% get xi, etha
[xi_rho, eta_rho] = getRHO(fileList(1).name, lon, lat);
nc = netcdf(fileList(1).name, 'read');
zeta = nc{'zeta'}(:).data;
[ntimes, L, M] = size(zeta);
disp(' ')
disp(['xi_rho = ', int2str(xi_rho)])
disp(' ')

disp(' ')
disp(['eta_rho = ', int2str(eta_rho)])
disp(' '),

% getting initial model timestamp
initTimeText = nc{'dstart'}.units(12:end,1);
t = datetime(initTimeText,'TimeZone','local','Format',formatIn);
ortimestamp = (datenum(t) - datenummx(1970,1,1,0,0,0)) * 86400;

close(nc);
if initfileIDX
    idx = initfileIDX;
else
    idx = 1;c
end

if endFileIDX
    if (length(fileList) >= endFileIDX) || (length(fileList2) >= endFileIDX) 
        disp(['wrond fidx param, max is ', int2str(length(fileList))])
        return
    else
        fidx = endFileIDX;
    end
else
    fidx = min(length(fileList),length(fileList2));
end

% read files

for fileIdx=idx:fidx
    [do, dt, a] = getZeta(fileList1(fileIdx).name, xi_rho, eta_rho, ortimestamp);
    dataOut = [dataOut, do];
    dates = [dates, dt];
    average = average + a;
end

% plot(dates,dataOut);

[~, S] = size(dataOut);
average = average./ S;
disp(['average =', int2str(average)]);
for i=1:S
    dataOut(1,i) = dataOut(1,i) - average;
end

average = 0;

for fileIdx=idx:fidx
    [do, dt, a] = getZeta(fileList2(fileIdx).name, xi_rho, eta_rho, ortimestamp);
    dataOut2 = [dataOut2, do];
    dates2 = [dates2, dt];
    average = average + a;
end

% plot(dates, dataOut2);

[~, S] = size(dataOut2);
average = average./ S;
disp(['average =', int2str(average)]);
for i=1:S
    dataOut2(1,i) = dataOut2(1,i) - average;
end


plot(dates, dataOut,'b', dates2, dataOut2, 'g');

title(['differense ',initTimeText]);
xlabel('date')
ylabel('height, m')
figure
plot(dates, abs(dataOut - dataOut2));
title(['delta ',initTimeText]);
xlabel('date') 
ylabel('value, m') 