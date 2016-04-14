%==================================
%   getZeta.m
%==================================
format long
zetaConfig
fileList = dir([dataPath, '*.nc']);
formatIn = 'yyyy-MM-dd HH:mm:ss';
%refNum is a timestamp
%datestr(refNum,'yyyy-mm-dd HH:MM:SS.FFF');


% array of zeta data
dataOut = [];
average = 0;
% array of dates
dates = [];

[xi_rho, eta_rho] = getRHO(fileList(1).name, lon, lat);
nc = netcdf(fileList(1).name, 'read');
zeta = nc{'zeta'}(:).data;
[ntimes, L, M] = size(zeta);
disp(' ')
disp(['xi_rho = ', int2str(xi_rho)])
disp(' ')

disp(' ')
disp(['eta_rho = ', int2str(eta_rho)])
disp(' ')

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
    if size(fileList) < endFileIDX
        disp('wrond fidx param, max is', size(fileList))
        return
    else
        fidx = endFileIDX;
    end
else
    fidx = size(fileList);
end

for fileIdx=idx:fidx
    [do, dt, a] = getZeta(fileList1(fileIdx).name, xi_rho, eta_rho, ortimestamp);
    dataOut = [dataOut, do];
    dates = [dates, dt];
    average = average + a;
end
%plot(dates,dataOut);
[F,S] = size(dataOut);
average = average./ S;
disp(average);
for i=1:S
    dataOut(1,i) = dataOut(1,i) - average;
end

%Synchronize data
if (plotData == 4)
    initLength = length(dates);
    dates = dates(dates >= odates(1));
     dates = dates(dates <= odates(end));
    buf = length(dates);
    dataOut = dataOut(initLength - buf+1:end);
end

%Data output
if (log == 1)
    OutputID = fopen('E:\zetalog.txt','w');
    if (OutputID == -1)
        disp('Cannot write a log')
    else
        for i=1:length(dates)
            fprintf(OutputID, '%s : %f\n', datestr(dates(i),'yyyy-mm-dd HH:MM:SS'), dataOut(i));
        end
        fclose(OutputID)
    end
end

figure
if (plotData == 1)
    plot(dates, dataOut);
elseif (plotData == 2)
    plot(odates, ozeta);
elseif (plotData ~= 0)
    plot(dates,dataOut,'b', odates, ozeta,'g');
end


title(['Graph of sea surface since ',initTimeText]);
xlabel('date') % x-axis label
ylabel('height, m') % y-axis label
