medvedFileID = fopen('medvedData.txt','r');

thecells = textscan(medvedFileID, '%f/%f/%f %f:%f:%f %f', 'CollectOutput', 1);
thecells = thecells{1};
datecells = thecells(:,1:3);
timecells = thecells(:,4:6);
medvedZeta = thecells(:,7);
medvedTimes = datetime(datecells(:,3),datecells(:,2),datecells(:,1), timecells(:,1), timecells(:,2), timecells(:,3));
fclose(medvedFileID);
outputFilename = 'Data.txt';

%with average
average = 0;
for i=1:size(medvedZeta)
   average = average + medvedZeta(i); 
end
n = size(medvedZeta);
average = average ./ n(1);
for i=1:size(medvedZeta)
   medvedZeta(i) = medvedZeta(i) - average; 
end