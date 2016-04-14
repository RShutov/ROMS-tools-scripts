format long
encoding = 'UTF-8';

lon = 141.585593;
lat = 55.161955;
dataDir =  'e:\ROMS_FILES';
[xi_rho, eta_rho] = getRHO([dataDir, '\roms_grd.nc'], lon, lat);
frcfile = [dataDir, '\roms_frc_tidal.nc'];
nc = netcdf(frcfile, 'read');
Amp = nc{'tide_Eamp'}(:);
Phs = nc{'tide_Ephase'}(:);
Aplitudes = [];
Phases = [];

% for i=1:size(Amp)
%     Aplitudes = [Aplitudes, Amp(i, xi_rho, eta_rho)];
% end
% 
% for i=1:size(Phs)
%     Phases = [Phases, Phs(i, xi_rho, eta_rho)];
% end


OutputID = fopen('E:\frcAP.txt','w', 'n' ,encoding);
fprintf(OutputID, 'Волны: K1 O1 M2\n'); %TODO auto detect it
fprintf(OutputID, 'Амплитуды:\n');
for i=1:size(Amp)
     fprintf(OutputID, '\t%f\n', Amp(i, xi_rho, eta_rho));
end
fprintf(OutputID, 'Фазы:\n');
for i=1:size(Phs)
    fprintf(OutputID, '\t%f\n', Phs(i, xi_rho, eta_rho));
end
fclose(OutputID)
