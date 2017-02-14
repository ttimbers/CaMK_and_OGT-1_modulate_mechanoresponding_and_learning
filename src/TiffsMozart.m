%%%%for 1 strain!!!!
 
clear all
 
prePlate = 180;
ISI = 10;
numStim = 30;
dt=3;
 
magDat2 = [0 0 0 0 0];
revInit = prePlate:ISI:prePlate+(ISI*numStim)-ISI;
revTerm = prePlate+dt:ISI:prePlate+(ISI*numStim)-ISI +dt;
 
Motherfoldercontents = dir(pwd);
 
%counting counts the group folders
counting = 0;
 
%Loops through folders
for z = 1 : numel(Motherfoldercontents);
    if Motherfoldercontents(z).isdir && ~any(strcmp(Motherfoldercontents(z).name, {'.' '..'}));
        counting=counting+1;
        group(counting).name = Motherfoldercontents(z).name;
        parentfolder = Motherfoldercontents(z).name;
        cd(parentfolder);
 
dirData = dir('*.revSumm');
 
storedData = dlmread(dirData(1).name);
 
for t = 1:size(revInit,2); 
stimRevs = storedData(:,2) > revInit(1,t) & storedData(:,2) < revTerm(1,t);
 
datum = storedData(stimRevs,:);
 
[uniqueID, firstInd, allInd] = unique(datum(:,1));
 
for i = 1:numel(firstInd)
    revComb1(i,1) = sum(datum(allInd == i,3));
end
 
for i = 1:numel(firstInd)
    revComb2(i,1) = sum(datum(allInd == i,4));
end
 
revComb = [revComb1 revComb2];
 
 
deltaDatum = [1;diff(datum(:,1))]; 
condition1 = deltaDatum ==0;
datum(condition1,:)=[];
 
magDat1 = [(counting.*ones(size(revComb,1),1)) (t.*ones(size(revComb,1),1))];
 
magDat2=[magDat2;magDat1 datum(:,2) revComb];
 
clear datum allInd magDat1 amount condition1 uniqueID datum deltaDatum dist1 firstInd stimRevs revComb revComb1 revComb2 
 
end
 
cd ('..');
 
clear dirData storedData t
    end
end
 
magDat2(1,:)=[];
magDat2(:,6)=magDat2(:,4)./magDat2(:,5);
 
revPoints = revInit(1,magDat2(:,2))';
magDat2(:,7)=magDat2(:,3)-revPoints;
 
 
currentDirectory = pwd;
[upperPath, deepestFolder] = fileparts(currentDirectory);
 
 
saveProg = ['save ' deepestFolder '.magDat magDat2 /ascii'];
eval(saveProg);
 
 

