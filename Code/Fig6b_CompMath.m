%% Text mining of PubMed for Cancer status
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
%

%% Define the fields that refer to Cancer,
% Articles may appear with oncology but not cancer so use a combination of
% various terms

allF                    = '%5BAll+Fields%5D'; % all fields code
basicURL                = 'https://www.ncbi.nlm.nih.gov/pubmed/?term=';
CancerEntriesURL            =  strcat('AND(',  '%22neoplasms%22',allF,'OR','%22cancer%22',allF,'OR','%22tumor%22',allF,'OR','%22tumour%22',allF,'OR','%22oncology%22',allF,  ')');
NoCancerEntriesURL          =  strcat('NOT(',  '%22neoplasms%22',allF,'OR','%22cancer%22',allF,'OR','%22tumor%22',allF,'OR','%22tumour%22',allF,'OR','%22oncology%22',allF,  ')');


%% Run per year per type
% Define the years to search and run the search for all the years and all
% the publication types. Find the "count" where the number of items of both
% cases are listed and store in a matrix

yearsAnalysis                   = 1950:2016;
Entries_With_Comp(1,:)            = yearsAnalysis;
        CompMath_KeyW         =  strcat('AND(%22computational%22%5BAll+fields%5D+OR+%22mathematical%22%5BAll+Fields%5D)');
%        CompMath_KeyW         =  strcat('AND%20%22Mathematical%22%5BAll%20Fields%5D');
%% 1,2,3 Years, Total Entries, Cancer Entries
% Run a series of queries to find out how many entries exist in PubMed for
% Cancer and in total
for counterYear =1:67
    year                                = yearsAnalysis(counterYear);
    % This is the code to select one year in PubMed
    year                                = yearsAnalysis(counterYear);
    yearURL                             = strcat('AND+%22',num2str(year),'%22%5BDP%5D+');
    disp([year])    

    % This is the code to select ALL cancer entries combined with year
    urlAddress                          = strcat(basicURL,yearURL,CompMath_KeyW,CancerEntriesURL);
    PubMedURL                           = urlread(urlAddress);
    % Find the field "Count"
    locCount_init                       = strfind(PubMedURL,'count" content="');
    locCount_fin                        = strfind(PubMedURL(locCount_init+16:locCount_init+300),'"');
    numEntriesPubMed                    = (PubMedURL(locCount_init+16:locCount_init+16+locCount_fin(1)-2));
    Entries_With_Comp(2,year-1949)        = str2double(numEntriesPubMed);

    % This is the code to select ALL cancer entries combined with year
    urlAddress                          = strcat(basicURL,yearURL,CompMath_KeyW,NoCancerEntriesURL);
    PubMedURL                           = urlread(urlAddress);
    % Find the field "Count"
    locCount_init                       = strfind(PubMedURL,'count" content="');
    locCount_fin                        = strfind(PubMedURL(locCount_init+16:locCount_init+300),'"');
    numEntriesPubMed                    = (PubMedURL(locCount_init+16:locCount_init+16+locCount_fin(1)-2));
    Entries_With_Comp(3,year-1949)        = str2double(numEntriesPubMed);


end



%% Display number of publications per year and as a proportion

figure

try
    % yyaxis is introduced in release R2016a
    yyaxis right
    plot(yearsAnalysis(1:67),Entries_With_Comp(2,1:67)./(sum(Entries_With_Comp(2:end,1:67))),'--','linewidth',2);
    
    %hold on
    %set(gca,'ylim',[-0.001 0.15])
    yyaxis left
    plot(yearsAnalysis(1:67),Entries_With_Comp(3,1:67)./(sum(Entries_With_Comp(2:end,1:67))),'-','linewidth',2);
catch
    % if yyaxis is not available, use plotyy
    hAxis = plotyy(yearsAnalysis(1:67),Entries_With_Comp(2,1:67)./(sum(Entries_With_Comp(2:end,1:67))),...
        yearsAnalysis(1:67),Entries_With_Comp(3,1:67)./(sum(Entries_With_Comp(2:end,1:67))));
    
    hLine_1 = hAxis(1).Children;
    hLine_2 = hAxis(2).Children;
    set(hLine_1,'color','b','linestyle','--','linewidth',2)
    set(hLine_2,'color','k','linewidth',2)
    hAxis(1).XLim = [1950 2016];
    hAxis(2).XLim = [1950 2016];
    hAxis(1).YLim = [0 0.15];
     hAxis(2).YLim = [ 1-0.15 1];
    hAxis(1).YColor = 'b';
    hAxis(2).YColor = 'k';
    hAxis(1).YTick = 0:0.02:0.16;
    hAxis(2).YTick = 0.84:0.02:1;
    
end

%%
grid on;
%axis tight
ylabel('Ratio of  Entries','fontsize',14)
  hLegend3 =legend('(Computational OR Mathematical) AND Cancer','(Computational OR Mathematical) NOT Cancer','location','South');
 set(hLegend3,'fontsize',14)
grid on
set(gcf,'Position',[   266   497   817   245])

%set(gca,'ylim',[0.85 1.01])
%%
set(gcf,'PaperPositionMode','auto')
filename='Fig9_CompMath_2016_11_03.tif';
print('-dtiff','-r300',filename)
save Fig9_Data Entries_With_Comp yearsAnalysis