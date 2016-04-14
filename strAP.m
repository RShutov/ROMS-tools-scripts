function outstr = strAP(eta_rho, xi_rho, Amp, Phs, Tides)
    outstr = '';
    if Amp(1, xi_rho, eta_rho) == 0
        return
    end
    
    outstr = [outstr '@AVG=0;' char(10)];
    outstr = [outstr '@Amplitude='];
    len = length(Amp(:,1,1));
    for i=1:len
        if i == 1
            fmt = '%f';
        elseif i == len
            fmt = ', %f;\n';
        else
            fmt = ', %f';
        end
         outstr = [outstr, sprintf(fmt, Amp(i, xi_rho, eta_rho))];
    end
    outstr = [outstr '@Phase='];
    for i=1:len
        if i == 1
            fmt = '%f';
        elseif i == len
            fmt = ', %f;\n';
        else
            fmt = ', %f';
        end
          outstr = [outstr, sprintf(fmt, Phs(i, xi_rho, eta_rho))];
    end

    outstr = [outstr '@Harmonics='];
    for i=1:len
        if i == 1
            fmt = '%s';
        elseif i == len
            fmt = ', %s;\n';
        else
            fmt = ', %s';
        end
          outstr = [outstr, sprintf(fmt, Tides(i,:))];
    end
end

