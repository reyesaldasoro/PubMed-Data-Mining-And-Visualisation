%% Figure 4 Display
%
% Author: Constantino Carlos Reyes-Aldasoro
%--------------------------------------------------------------------------
%
% This m-file is part of a series of queries on PubMed to investigate the number of
% entries related to Cancer and other conditions. The manuscript has been submitted
% for publication in PLOS ONE
%--------------------------------------------------------------------------
%     These files are distributed as free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, version 3 of the License.
%
%     These files are  distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
%
% The author shall not be liable for any errors or responsibility for the accuracy,
% completeness, or usefulness of any information, or method in the content, or for
% any actions taken in reliance thereon.
%--------------------------------------------------------------------------



%%

totalEntries    = repmat((EntriesPerOrgan(2,1:67)),[18,1]);

EntriesPerOrganRel      = EntriesPerOrgan(3:end,1:67)./totalEntries;
DecreaseRate            = mean(EntriesPerOrganRel(:,1:5),2)-mean(EntriesPerOrganRel(:,end-4:end),2);

[sortedDecrease,indexDecrease]= sort(DecreaseRate);
%%


figure(1)


 clf
 hold on
 plot(yearsAnalysis(1:67),EntriesPerOrganRel(indexDecrease(1),:),'-','color',[0 0 0],'linewidth',3,'markersize',6);
 plot(yearsAnalysis(1:67),EntriesPerOrganRel(indexDecrease(2),:),'-v','color',[1 0 0],'linewidth',1,'markersize',6);
 plot(yearsAnalysis(1:67),EntriesPerOrganRel(indexDecrease(3),:),'-o','color',[0.5 0 0.5],'linewidth',1,'markersize',5);
 plot(yearsAnalysis(1:67),EntriesPerOrganRel(indexDecrease(4),:),'-','color',[0 0.8 0],'linewidth',3,'markersize',6);
 plot(yearsAnalysis(1:67),EntriesPerOrganRel(indexDecrease(5),:),'--x','color',[0 0 1],'linewidth',1,'markersize',6);
 plot(yearsAnalysis(1:67),EntriesPerOrganRel(indexDecrease(6),:),'-','color',[0 .5 0.8],'linewidth',5,'markersize',6);




%plot(yearsAnalysis(1:67),EntriesPerOrganRel(indexDecrease(1:6),:),'linewidth',2,'markersize',6);


hLegendOrgan =legend(organList{indexDecrease(1:6)},'location','eastoutside');
 grid on;axis tight

 set(hLegendOrgan,'fontsize',14)
ylabel('Ratio of Cancer Entries','fontsize',16)
            
set(gca,'position',[    0.1122    0.1100    0.7287    0.8150])
set(gcf,'Position',[   266   497   817   245])
filename='Fig_PerOrgan_1.tif';
print('-dtiff','-r400',filename)


%%



 figure(2)
 
 
  clf
 hold on
 plot(yearsAnalysis(1:67),EntriesPerOrganRel(indexDecrease(7),:),'-','color',[0 0 0],'linewidth',3,'markersize',6);
 plot(yearsAnalysis(1:67),EntriesPerOrganRel(indexDecrease(8),:),'-v','color',[1 0 0],'linewidth',1,'markersize',6);
 plot(yearsAnalysis(1:67),EntriesPerOrganRel(indexDecrease(9),:),'-o','color',[0.5 0 0.5],'linewidth',1,'markersize',5);
 plot(yearsAnalysis(1:67),EntriesPerOrganRel(indexDecrease(10),:),'-','color',[0 0.8 0],'linewidth',3,'markersize',6);
 plot(yearsAnalysis(1:67),EntriesPerOrganRel(indexDecrease(11),:),'--x','color',[0 0 1],'linewidth',1,'markersize',6);
 plot(yearsAnalysis(1:67),EntriesPerOrganRel(indexDecrease(12),:),'-','color',[0 .5 0.8],'linewidth',5,'markersize',6);


 
% plot(yearsAnalysis(1:67),EntriesPerOrganRel(indexDecrease(7:12),:),'linewidth',2,'markersize',6);

hLegendOrgan =legend(organList{indexDecrease(7:12)},'location','eastoutside');
 grid on;axis tight

 set(hLegendOrgan,'fontsize',14)
ylabel('Ratio of Cancer Entries','fontsize',16)
            
set(gca,'position',[    0.1122    0.1100    0.7287    0.8150])
set(gcf,'Position',[   266   497   817   245])

filename='Fig_PerOrgan_2.tif';
print('-dtiff','-r400',filename)

 
 %%
 figure(3)
 
 clf
 hold on
 plot(yearsAnalysis(1:67),EntriesPerOrganRel(indexDecrease(13),:),'-','color',[0 0 0],'linewidth',3,'markersize',6);
 plot(yearsAnalysis(1:67),EntriesPerOrganRel(indexDecrease(14),:),'-v','color',[1 0 0],'linewidth',1,'markersize',6);
 plot(yearsAnalysis(1:67),EntriesPerOrganRel(indexDecrease(15),:),'-o','color',[0.5 0 0.5],'linewidth',1,'markersize',5);
 plot(yearsAnalysis(1:67),EntriesPerOrganRel(indexDecrease(16),:),'-','color',[0 0.8 0],'linewidth',3,'markersize',6);
 plot(yearsAnalysis(1:67),EntriesPerOrganRel(indexDecrease(17),:),'--x','color',[0 0 1],'linewidth',1,'markersize',6);
 plot(yearsAnalysis(1:67),EntriesPerOrganRel(indexDecrease(18),:),'-','color',[0 .5 0.8],'linewidth',5,'markersize',6);


hLegendOrgan =legend(organList{indexDecrease(13:18)},'location','eastoutside');
 grid on;axis tight

 set(hLegendOrgan,'fontsize',14)
ylabel('Ratio of Cancer Entries','fontsize',16)
            
set(gca,'position',[    0.1122    0.1100    0.7287    0.8150])
set(gcf,'Position',[   266   497   817   245])


filename='Fig_PerOrgan_3.tif';
print('-dtiff','-r400',filename)
