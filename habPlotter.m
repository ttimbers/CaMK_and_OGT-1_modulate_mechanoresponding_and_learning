function habPlotter()
%%Plot full habituation curves 
%type "habPlotter" in the MATLAB command line and select the directory with
%the experiment of interest.

selpath = uigetdir;
cd(selpath)
dirData = dir('*.txt');
figure
hold on
legendLabels=strings(1,size(dirData,1));
for txtFile = 1:size(dirData,1)
    revData = (dlmread(dirData(txtFile).name));
    toPlot=nan(3,30);
    for stimNum = 1:30
        dataOI = revData(revData(:,2)==stimNum,3); 
        toPlot(1,stimNum)=nanmean(dataOI);
        toPlot(2,stimNum)=nanstd(dataOI);
        toPlot(3,stimNum)=toPlot(2,stimNum)/sqrt(size(dataOI,1));
    end
   errorbar(1:30,toPlot(1,1:30),toPlot(3,1:30)); 
   strainOI=strsplit(dirData(txtFile).name,'.');
   legendLabels(1,txtFile)=strainOI(:,1);
end
ylabel('Reversal distance (mm)');xlabel('Stimulus');
legend(legendLabels)
if size(revData,2)==4
    figure
    hold on
    for txtFile = 1:size(dirData,1)
        revData = (dlmread(dirData(txtFile).name));
        toPlot=nan(3,30);
        for stimNum = 1:30
            dataOI = revData(revData(:,2)==stimNum,4); 
            toPlot(1,stimNum)=nanmean(dataOI);
            toPlot(2,stimNum)=nanstd(dataOI);
            toPlot(3,stimNum)=toPlot(2,stimNum)/sqrt(size(dataOI,1));
        end
        errorbar(1:30,toPlot(1,1:30),toPlot(3,1:30)); 
    end
    ylabel('Reversal duration (s)');xlabel('Stimulus');
end
legend(legendLabels)


