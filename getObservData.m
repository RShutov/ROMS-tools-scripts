function [ zeta, dates ] = getObservData(filename)
    fileID = fopen(filename,'r');

    thecells = textscan(fileID, '%f/%f/%f %f:%f:%f %f', 'CollectOutput', 1);
    thecells = thecells{1};
    datecells = thecells(:,1:3);
    timecells = thecells(:,4:6);
    zeta = thecells(:,7);
    dates = datetime(datecells(:,3),datecells(:,2),datecells(:,1), timecells(:,1), timecells(:,2), timecells(:,3));
    fclose(fileID);


    %with average
    average = 0;
    for i=1:size(zeta)
       average = average + zeta(i); 
    end
    n = size(zeta);
    average = average ./ n(1);
    for i=1:size(zeta)
       zeta(i) = zeta(i) - average; 
    end
end

