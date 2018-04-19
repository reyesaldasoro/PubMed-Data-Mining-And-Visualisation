% Figure 6 Display
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
figure
%%
clf
hold on
plot(yearsAnalysis(1:67),Entries_With_DNA(2,1:67)./(sum(Entries_With_DNA(2:end,1:67))),'b-','linewidth',2);

    plot(yearsAnalysis(1:67),Entries_With_Comp(2,1:67)./(sum(Entries_With_Comp(2:end,1:67))),'k--','linewidth',2);
%%
grid on;
axis tight
ylabel('Ratio of  Entries','fontsize',14)
  hLegend3 =legend('DNA AND Cancer','(Computational OR Mathematical) AND Cancer','location','south');
 set(hLegend3,'fontsize',14,'location','northwest')

set(gcf,'Position',[   266   497   817   245])

%%

filename='Fig_DNA_Comp_2017_02_09.tif';
set(gcf,'PaperPositionMode','auto')
print('-dtiff','-r300',filename)