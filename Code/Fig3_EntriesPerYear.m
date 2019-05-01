%% Text mining of PubMed for Cancer status
%
% (a) Ratio of a series of condition-related entries in PubMed to the total number of
% entries per year. Notice how Cancer entries have increased from around 6% in the
% 1950s to 16% in 2016. All other conditions are considerably below Cancer. (b) Zoom
% into the lower values of the vertical axis of (a). Notice the different trends of
% each condition.
%
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

%% Define the fields that refer to Cancer,
% Articles may appear with oncology but not cancer so use a combination of
% various terms

allF                    = '%5BAll+Fields%5D'; % all fields code
basicURL                = 'https://www.ncbi.nlm.nih.gov/pubmed/?term=';
CancerKeyW_1            =  strcat('%22neoplasms%22',allF);
CancerKeyW_2            =  strcat('OR%22cancer%22',allF);
CancerKeyW_3            =  strcat('OR%22tumor%22',allF);
CancerKeyW_4            =  strcat('OR%22tumour%22',allF);
CancerKeyW_5            =  strcat('OR%22oncology%22',allF);
CancerEntriesURL        =  strcat(CancerKeyW_1,CancerKeyW_2,CancerKeyW_3,CancerKeyW_4,CancerKeyW_5);
%% Run per year per type
% Define the years to search and run the search for all the years and all
% the publication types. Find the "count" where the number of items of both
% cases are listed and store in a matrix

yearsAnalysis = 1950%:2016;
EntriesPerDisease(8,67)=0;
%% 1,2,3 Years, Total Entries, Cancer Entries
% Run a series of queries to find out how many entries exist in PubMed for
% Cancer and in total
for counterYear =1%:67
    year                                = yearsAnalysis(counterYear);

    EntriesPerDisease(1,year-1949)      = year;
    % This is the code to select one year in PubMed
    year                                = yearsAnalysis(counterYear);
    yearURL                             = strcat('AND+%22',num2str(year),'%22%5BDP%5D+');
    disp([year])    
    % This is the code to select PubMed entries combined with year
    urlAddress                          = strcat(basicURL,yearURL);
    PubMedURL                           = urlread(urlAddress);
    % Find the field "Count"
    locCount_init                       = strfind(PubMedURL,'count" content="');
    locCount_fin                        = strfind(PubMedURL(locCount_init+16:locCount_init+300),'"');
    numEntriesPubMed                    = (PubMedURL(locCount_init+16:locCount_init+16+locCount_fin(1)-2));
    EntriesPerDisease(2,year-1949)      = str2double(numEntriesPubMed);
    % Repeat for CANCER all entries of the year
    % This is the code to select cancer entries combined with year
    urlAddress                          = strcat(basicURL,CancerEntriesURL,yearURL);
    PubMedURL                           = urlread(urlAddress);
    % Find the field "Count"
    locCount_init                       = strfind(PubMedURL,'count" content="');
    locCount_fin                        = strfind(PubMedURL(locCount_init+16:locCount_init+300),'"');
    numEntriesPubMed                    = (PubMedURL(locCount_init+16:locCount_init+16+locCount_fin(1)-2));
    EntriesPerDisease(3,year-1949)      = str2double(numEntriesPubMed);
end

%% Display number of publications per year 

figure
%set(h311,'colororder',graphColorOrder)
plot(yearsAnalysis,EntriesPerDisease(3,:),'b--',yearsAnalysis,EntriesPerDisease(2,:),'k','linewidth',2);grid on;axis tight
hLegend1 = legend('Cancer','Total','Location','southeast');
set(hLegend1,'fontsize',14)
set(gca,'yscale','log','fontsize',12,'ytick',[10^3 10^4 10^5 10^6 ])
ylabel('Entries in PubMed','fontsize',14)
set(gcf,'Position',[   266   497   817   245])

%%


%% 4 Run the same per year analysis for AIDS

AIDSKeyW_6         =  '%22acquired%20immunodeficiency%20syndrome%22%5BMeSH%20Terms%5D%20';
AIDSKeyW_7         =  'OR%20(%22acquired%22%5BAll%20Fields%5D%20AND%20%22immunodeficiency%22%5BAll%20Fields%5D%20AND%20%22syndrome%22%5BAll%20Fields%5D)%20';
AIDSKeyW_8         =  'OR%20%22acquired%20immunodeficiency%20syndrome%22%5BAll%20Fields%5D%20';
AIDSKeyW_9         =  'OR%20%22aids%22%5BAll%20Fields%5D';

AIDSEntriesURL   = strcat(AIDSKeyW_6,AIDSKeyW_7,AIDSKeyW_8,AIDSKeyW_9);
for counterYear =1:67
    year                                = yearsAnalysis(counterYear);
    yearURL                             = strcat('AND+%22',num2str(year),'%22%5BDP%5D+');

    disp([ year])
    urlAddress                          = strcat(basicURL,AIDSEntriesURL,yearURL);
    PubMedURL                           = urlread(urlAddress);
    locCount_init                       = strfind(PubMedURL,'count" content="');
    locCount_fin                        = strfind(PubMedURL(locCount_init+16:locCount_init+300),'"');
    numEntriesPubMed                    = (PubMedURL(locCount_init+16:locCount_init+16+locCount_fin(1)-2));
    EntriesPerDisease(4,year-1949)         = str2double(numEntriesPubMed);
end
%% 5 Run the same per year analysis for Malaria 
MalariaKeyW_10         =  'OR%20%22malaria%22%5BAll%20Fields%5D';

for counterYear =1:67
    disp([ year])
    % This is the code to select one year in PubMed
    year                                = yearsAnalysis(counterYear);
    yearURL                             = strcat('AND+%22',num2str(year),'%22%5BDP%5D+');
    
    % This is the code to select PubMed entries combined with year
    urlAddress                          = strcat(basicURL,MalariaKeyW_10,yearURL);
    PubMedURL                           = urlread(urlAddress);
    % Find the field "Count"
    locCount_init                       = strfind(PubMedURL,'count" content="');
    locCount_fin                        = strfind(PubMedURL(locCount_init+16:locCount_init+300),'"');
    numEntriesPubMed                    = (PubMedURL(locCount_init+16:locCount_init+16+locCount_fin(1)-2));
    EntriesPerDisease(5,year-1949)      = str2double(numEntriesPubMed);
end
%% 6 Tuberculosis
TuberculosisKeyW_11         =  'OR%20%22tuberculosis%22%5BAll%20Fields%5D';

for counterYear =1:67

    % This is the code to select one year in PubMed
    year                                = yearsAnalysis(counterYear);
    yearURL                             = strcat('AND+%22',num2str(year),'%22%5BDP%5D+');
    disp([ year])    
    urlAddress                          = strcat(basicURL,TuberculosisKeyW_11,yearURL);
    PubMedURL                           = urlread(urlAddress);
    % Find the field "Count"
    locCount_init                       = strfind(PubMedURL,'count" content="');
    locCount_fin                        = strfind(PubMedURL(locCount_init+16:locCount_init+300),'"');
    numEntriesPubMed                    = (PubMedURL(locCount_init+16:locCount_init+16+locCount_fin(1)-2));
    EntriesPerDisease(6,year-1949)      = str2double(numEntriesPubMed);
end

%% 7 Cardiovascular
CardioKeyW_12         =  'OR%20%22cardiovascular%22%5BAll%20Fields%5D';

for counterYear =1:67

    % This is the code to select one year in PubMed
    year                                = yearsAnalysis(counterYear);
    yearURL                             = strcat('AND+%22',num2str(year),'%22%5BDP%5D+');
    disp([ year])
    urlAddress                          = strcat(basicURL,CardioKeyW_12,yearURL);
    PubMedURL                           = urlread(urlAddress);
    % Find the field "Count"
    locCount_init                       = strfind(PubMedURL,'count" content="');
    locCount_fin                        = strfind(PubMedURL(locCount_init+16:locCount_init+300),'"');
    numEntriesPubMed                    = (PubMedURL(locCount_init+16:locCount_init+16+locCount_fin(1)-2));
    EntriesPerDisease(7,year-1949)      = str2double(numEntriesPubMed);

end
%% 8 Diabetes
DiabetesKeyW_13         =  'OR%20%22diabetes%22%5BAll%20Fields%5D';

for counterYear =1:67

    % This is the code to select one year in PubMed
    year                                = yearsAnalysis(counterYear);
    yearURL                             = strcat('AND+%22',num2str(year),'%22%5BDP%5D+');
    disp([ year])    
    urlAddress                          = strcat(basicURL,DiabetesKeyW_13,yearURL);
    % Find the field "Count"
    PubMedURL                           = urlread(urlAddress);
    locCount_init                       = strfind(PubMedURL,'count" content="');
    locCount_fin                        = strfind(PubMedURL(locCount_init+16:locCount_init+300),'"');
    numEntriesPubMed                    = (PubMedURL(locCount_init+16:locCount_init+16+locCount_fin(1)-2));
    EntriesPerDisease(8,year-1949)      = str2double(numEntriesPubMed);
end

%% 9 stroke
strokeKeyW_13         =  'OR%20%22stroke%22%5BAll%20Fields%5D';

for counterYear =1:67

    % This is the code to select one year in PubMed
    year                                = yearsAnalysis(counterYear);
    yearURL                             = strcat('AND+%22',num2str(year),'%22%5BDP%5D+');
    disp([ year])    
    urlAddress                          = strcat(basicURL,strokeKeyW_13,yearURL);
    % Find the field "Count"
    PubMedURL                           = urlread(urlAddress);
    locCount_init                       = strfind(PubMedURL,'count" content="');
    locCount_fin                        = strfind(PubMedURL(locCount_init+16:locCount_init+300),'"');
    numEntriesPubMed                    = (PubMedURL(locCount_init+16:locCount_init+16+locCount_fin(1)-2));
    EntriesPerDisease(9,year-1949)      = str2double(numEntriesPubMed);
end


%% 10 infection
infectionKeyW_13         =  'OR%20%22infection%22%5BAll%20Fields%5D';

for counterYear =1:67

    % This is the code to select one year in PubMed
    year                                = yearsAnalysis(counterYear);
    yearURL                             = strcat('AND+%22',num2str(year),'%22%5BDP%5D+');
    disp([ year])    
    urlAddress                          = strcat(basicURL,infectionKeyW_13,yearURL);
    % Find the field "Count"
    PubMedURL                           = urlread(urlAddress);
    locCount_init                       = strfind(PubMedURL,'count" content="');
    locCount_fin                        = strfind(PubMedURL(locCount_init+16:locCount_init+300),'"');
    numEntriesPubMed                    = (PubMedURL(locCount_init+16:locCount_init+16+locCount_fin(1)-2));
    EntriesPerDisease(10,year-1949)      = str2double(numEntriesPubMed);
end




%% Display number of publications per year  as a proportion

figure
% plot(yearsAnalysis,100*EntriesPerDisease(3,:)./EntriesPerDisease(2,:),'b-',...
%     yearsAnalysis,100*EntriesPerDisease(4,:)./EntriesPerDisease(2,:),'r--',...
%     yearsAnalysis,100*EntriesPerDisease(5,:)./EntriesPerDisease(2,:),'g-.',...
%     yearsAnalysis,100*EntriesPerDisease(6,:)./EntriesPerDisease(2,:),'k:',...
%     yearsAnalysis,100*EntriesPerDisease(7,:)./EntriesPerDisease(2,:),'m-',...
%     yearsAnalysis,100*EntriesPerDisease(8,:)./EntriesPerDisease(2,:),'c--',...
%     'linewidth',2);
hold off
plot(   yearsAnalysis,EntriesPerDisease(3,:)./EntriesPerDisease(2,:),'color',[0     0   0], 'linestyle','-','linewidth',4)
    hold on
plot(   yearsAnalysis,EntriesPerDisease(4,:)./EntriesPerDisease(2,:),'color',[0     0   1], 'linestyle','-','linewidth',2)

plot(   yearsAnalysis,EntriesPerDisease(5,:)./EntriesPerDisease(2,:),'color',[0     0.5 0], 'linestyle','-','linewidth',0.5)

plot(   yearsAnalysis,EntriesPerDisease(6,:)./EntriesPerDisease(2,:),'color',[1     0   0], 'linestyle','--','linewidth',2)

plot(   yearsAnalysis,EntriesPerDisease(7,:)./EntriesPerDisease(2,:),'color',[0.3   0   0.75],'linestyle','--','linewidth',0.5)

plot(   yearsAnalysis,EntriesPerDisease(8,:)./EntriesPerDisease(2,:),'color',[0.5   0.5 0.5],'linestyle','-.','linewidth',2);

plot(   yearsAnalysis,EntriesPerDisease(9,:)./EntriesPerDisease(2,:),'color',[0.75  0   0.25],'linestyle','-.','linewidth',0.5);

plot(   yearsAnalysis,EntriesPerDisease(10,:)./EntriesPerDisease(2,:),'color',[0.25   0.75 0.25],'linestyle',':','linewidth',2);


% plot(   yearsAnalysis(6:10:end),EntriesPerDisease(7,6:10:end)./EntriesPerDisease(2,6:10:end),'color',[0.3   0   0.75],'linestyle','none','linewidth',2,'marker','x','markersize',6)
% plot(   yearsAnalysis(1:10:end),EntriesPerDisease(4,1:10:end)./EntriesPerDisease(2,1:10:end),'color',[0     0   1], 'linestyle','none','linewidth',2,'marker','o','markersize',6)
% plot(   yearsAnalysis(3:10:end),EntriesPerDisease(6,3:10:end)./EntriesPerDisease(2,3:10:end),'color',[1     0   0], 'linestyle','none','linewidth',2,'marker','v','markersize',6)
% plot(   yearsAnalysis(9:10:end),EntriesPerDisease(10,9:10:end)./EntriesPerDisease(2,9:10:end),'color',[0.25   0.75 0.25],'linestyle','none','linewidth',2,'marker','d','markersize',6);



grid on;axis([1950 2016 -.005 0.18])
set(gca,'Position',[    0.1111    0.1100    0.71    0.8150]);

hLegend3 =legend('Cancer','AIDS','Malaria','Tuberculosis','Cardiovascular','Diabetes','Stroke','Infection','Location','Eastoutside');
set(hLegend3,'fontsize',12)
ylabel('Ratio of Total Entries in PubMed','fontsize',14)
set(gcf,'Position',[   266   497   817   245])

%%


%% zoom into the lower portion to highlight entries lower than cancer.

grid on;axis([1950 2016 -.001 0.055])


