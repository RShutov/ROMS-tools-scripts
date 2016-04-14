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
disp(['xi_rho = ', xi_rho])
disp(' ')

disp(' ')
disp(['eta_rho = ', eta_rho])
disp(' '),

% getting initial model timestamp
initTimeText = nc{'dstart'}.units(12:end,1);
t = datetime(initTimeText,'TimeZone','local','Format',formatIn);
ortimestamp = (datenum(t) - datenummx(1970,1,1,0,0,0)) * 86400;

close(nc);

for fileIdx=1:(size(fileList))
    hfname = fileList(fileIdx).name;
    disp(' ')
    disp(['Read nc file = ', hfname])
    disp(' ')
    nc = netcdf(hfname,'read');
    zeta = nc{'zeta'}(:).data;
    oceantime = nc{'ocean_time'}(:);
    [F,S,T] = size(zeta) ;
    for buf=1:F
        average = average + zeta(buf,eta_rho,xi_rho);
    end
    dataOut = [dataOut, zeta(:,eta_rho,xi_rho)'];
    
    
    for i=1:ntimes
        % conver from unix to matlab date format
        unix_time = oceantime(i) + ortimestamp;
        fdate = unix_time./86400 + datenummx(1970,1,1,0,0,0);
        %sdate = datestr(fdate,'yyyy-mm-dd HH:MM:SS');
        dates = [dates, datetime(fdate,'ConvertFrom','datenum')];
        %disp([sdate,num2str(zeta(i,xi_rho,eta_rho))]);
    end
    close(nc);
    %plot(dates,out);
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
    dates = dates(dates >= medvedTimes(1));
     dates = dates(dates <= medvedTimes(end));
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
    plot(dates,dataOut);
elseif (plotData == 2)
    plot(medvedTimes,medvedZeta);
elseif (plotData ~= 0)
    plot(dates,dataOut,'b',medvedTimes,medvedZeta,'g');
end


title(['Graph of sea surface since ',initTimeText]);
xlabel('date') % x-axis label
ylabel('height, m') % y-axis label
