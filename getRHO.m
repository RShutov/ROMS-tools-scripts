%=========================================================================%
%   getRho.m                                                              %
%   Получение RHO координад по соответсвующим значениям долготы и широты  %
%=========================================================================%

function [ xi_rho, eta_rho ] = getRHO(filename, lon, lat)
    nc = netcdf(filename, 'read');
    latData = nc{'lat_rho'}(:);
    lonData = nc{'lon_rho'}(:);
    [M, L]=size(lonData);

    xi_rho = 0;
    eta_rho = 0;
    cur = 0;
   
    for i=1:L
        if abs(lon - cur) > abs(lon - lonData(1, i))
            cur = lonData(1, i);
            xi_rho = i;
        end
    end
    cur = 0;
    for i=1:M
        if abs(lat - cur) > abs(lat - latData(i, 1))
            cur = latData(i, 1);
            eta_rho = i;
        end
    end
end

