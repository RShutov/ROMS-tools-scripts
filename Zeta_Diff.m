%=========================================================================%
%   Zeta_Diff.m                                                           %
%   Сравнение двух наборов данных модели в точке                          %
%=========================================================================%

format long
zetaConfig
formatIn = 'yyyy-MM-dd HH:mm:ss';

% пути к каталогам данных модели
path1 = '/test/';
path2 = '/test2/';


fileList1 = dir([dataPath, path1, '*.nc']);
fileList2 = dir([dataPath, path2, '*.nc']);


average = 0;

dates = [];
dates2 = [];
dataOut =[];
dataOut2 = [];

[xi_rho, eta_rho] = getRHO(fileList1(1).name, lon, lat);

nc = netcdf(fileList1(1).name, 'read');
zeta = nc{'zeta'}(:).data;
[ntimes, L, M] = size(zeta);
disp(' ')
disp(['xi_rho = ', int2str(xi_rho)])
disp(' ')

disp(' ')
disp(['eta_rho = ', int2str(eta_rho)])
disp(' '),


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
    if (endFileIDX > length(fileList1)) || (endFileIDX > length(fileList2)) 
        disp(['wrond fidx param, max is ', int2str(length(fileList))])
        return
    else
        fidx = endFileIDX;
    end
else
    fidx = min(length(fileList1),length(fileList2)) - 1;
end

for fileIdx=idx:fidx
    [do, dt, a] = getZeta([path1, fileList1(fileIdx).name], xi_rho, eta_rho, ortimestamp);
    dataOut = [dataOut, do];
    dates = [dates, dt];
    average = average + a;
end

[~, S] = size(dataOut);
average = average./ S;
disp(['average =', int2str(average)]);
for i=1:S
    dataOut(1,i) = dataOut(1,i) - average;
end

average = 0;

for fileIdx=idx:fidx
    [do, dt, a] = getZeta([path2, fileList2(fileIdx).name], xi_rho, eta_rho, ortimestamp);
    dataOut2 = [dataOut2, do];
    dates2 = [dates2, dt];
    average = average + a;
end

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