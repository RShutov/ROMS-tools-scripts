%=========================================================================%
%   getZeta.m                                                             %
%   ��������� �������� ���������� zeta � �������� ����� � history-������  %
%=========================================================================%

function [dataOut, dates, average]  = getZeta(filename, xi_rho, eta_rho, ortimestamp)
    disp(['������ nc �����: ', filename])
    
    dates = [];
    dataOut = [];
    average = 0;
    
    nc = netcdf(filename, 'read');
    zeta = nc{'zeta'}(:).data;
    oceantime = nc{'ocean_time'}(:);
    [F, ~, ~] = size(zeta) ;
    for buf=1:F
        average = average + zeta(buf, eta_rho, xi_rho);
    end
    dataOut = [dataOut, zeta(:, eta_rho,xi_rho)'];
    for i=1:F
        % ����������� ������� ���� �� unix � matlab
        unix_time = oceantime(i) + ortimestamp;% - 8 * 60 * 60;
        fdate = unix_time./ 86400 + datenummx(1970, 1, 1, 0, 0, 0);
        dates = [dates, datetime(fdate, 'ConvertFrom', 'datenum','TimeZone', 'Europe/London')];
    end
    close(nc);
end

