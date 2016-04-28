%=========================================================================%
%   getZeta.m                                                             %
%   ��������� �������� ���������� zeta � �������� ����� � history-������  %
%=========================================================================%


clear all
close all
format long
zetaConfig

% ���� � ����� � hystory-�������

fileList = dir([dataPath, '*.nc']);
formatIn = 'yyyy-MM-dd HH:mm:ss';

% ����� ������ ���������� zeta 
dataOut = [];
average = 0;

% ������ ���
dates = [];

% ��������� �������� � RHO ����������� �� ������� � ������
[xi_rho, eta_rho] = getRHO([dataPath, fileList(1).name], lon, lat);

nc = netcdf([dataPath, fileList(1).name], 'read');
zeta = nc{'zeta'}(:).data;
[ntimes, L, M] = size(zeta);
disp(' ')
disp(['xi_rho = ', int2str(xi_rho)])
disp(' ')

disp(' ')
disp(['eta_rho = ', int2str(eta_rho)])
disp(' ')

% ��������� �������� ������� ������������� ������
initTimeText = nc{'dstart'}.units(12:end,1);
t = datetime(initTimeText, 'TimeZone', 'Europe/London', 'Format', formatIn);
t2 = datetime(1970,1,1,0,0,0,'TimeZone','Europe/London');
ortimestamp = datenum(t - t2) * 86400;

close(nc);
if initfileIDX
    idx = initfileIDX;
else
    idx = 1;
end

if endFileIDX
    if size(fileList) < endFileIDX
        disp('�������� �������� fidx ,  ������������: ', size(fileList))
        return
    else
        fidx = endFileIDX;
    end
else
    fidx = size(fileList);
end


% ��������� zeta
for fileIdx=idx:fidx
    [do, dt, a] = getZeta([dataPath, fileList(fileIdx).name], xi_rho, eta_rho, ortimestamp);
    dataOut = [dataOut, do];
    dates = [dates, dt];
    average = average + a;
end

% ���������� � ��������
[F,S] = size(dataOut);
average = average./ S;
disp(average);
for i=1:S
    dataOut(1,i) = dataOut(1,i) - average;
end

% �������������
if (plotData == 4)
    start = 0;
    endd = 0;
    for i=1:length(dates)
        if (start == 0) &&  (dates(i) >= odates(1))
            start = i;
           
        end
        if (dates(i) <= odates(end))
            endd = i;
        end
    end
    dates = dates(start:endd);
    dataOut = dataOut(start:endd);
end

% ����� ��������
if (logObs == 1)
    OutputID = fopen(logObsPath,'w');
    if (OutputID == -1)
        disp('Cannot write a log')
    else
        for i=1:length(odates)
            fprintf(OutputID, '%s %f\n', datestr(odates(i),'dd/mm/yyyy HH:MM:SS'), ozeta(i));
        end
        fclose(OutputID)
    end
end

% ������ ����
if (log == 1)
    OutputID = fopen(logPath,'w');
    if (OutputID == -1)
        disp('Cannot write a log')
    else
        for i=1:length(dates)
            fprintf(OutputID, '%s %f\n', datestr(dates(i),'dd/mm/yyyy HH:MM:SS'), dataOut(i));
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
    plot(dates, dataOut, 'b', odates, ozeta,'g');
end


title(['������� ������ ����������� � ',initTimeText]);
xlabel('����') % x-axis label
ylabel('������, m') % y-axis label
