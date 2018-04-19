%% Text mining of PubMed for Cancer status
% Ratios of the Cancer entries related to organ-specific keywords. The trends have
% been ranked and presented according to (a) largest increase, (b) intermediate
% increase and (c) largest decrease from 1950s to 2016.
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

%

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

yearsAnalysis                   = 1950:2016;
EntriesPerOrgan(1,:)            = yearsAnalysis;


organList ={'Bladder','Bowel','Brain','Breast','Cervico','Colon','Colorectal','Kidney','Leukaemia','Liver','Lung','Lymphoma','Melanoma','Mouth','Ovarian','Pancreas','Prostate','Sarcoma','Stomach','Testicular','Uterus','Uterine'};
%% 1,2,3 Years, Total Entries, Cancer Entries
% Run a series of queries to find out how many entries exist in PubMed for
% Cancer and in total
for counterYear =3 :67
    year                                = yearsAnalysis(counterYear);
    % This is the code to select one year in PubMed
    year                                = yearsAnalysis(counterYear);
    yearURL                             = strcat('AND+%22',num2str(year),'%22%5BDP%5D+');
    %disp([year])    

    % This is the code to select ALL cancer entries combined with year
    urlAddress                          = strcat(basicURL,CancerEntriesURL,yearURL);
    PubMedURL                           = urlread(urlAddress);
    % Find the field "Count"
    locCount_init                       = strfind(PubMedURL,'count" content="');
    locCount_fin                        = strfind(PubMedURL(locCount_init+16:locCount_init+300),'"');
    if ~isempty(locCount_init)
        numEntriesPubMed                    = (PubMedURL(locCount_init+16:locCount_init+16+locCount_fin(1)-2));
        EntriesPerOrgan(2,year-1949)        = str2double(numEntriesPubMed);
        for counterOrgan = 1:numel(organList)
            % This is the code to select  cancer entries + one organ
            disp([year counterOrgan])
            
            organ_KeyW         =  strcat('AND%20%22',organList{counterOrgan},'%22%5BAll%20Fields%5D');
            urlAddress                          = strcat(basicURL,CancerEntriesURL,yearURL,organ_KeyW);
            PubMedURL                           = urlread(urlAddress);
            % Find the field "Count"
            locCount_init                       = strfind(PubMedURL,'count" content="');
            locCount_fin                        = strfind(PubMedURL(locCount_init+16:locCount_init+300),'"');
            numEntriesPubMed                    = (PubMedURL(locCount_init+16:locCount_init+16+locCount_fin(1)-2));
            EntriesPerOrgan(2+counterOrgan,year-1949)        = str2double(numEntriesPubMed);
        end
    end

end



%% Display number of publications per year and as a proportion

figure(1)

%%
figure(3)
%organList ={'Breast','Lung','Prostate','Liver','Brain','Bowel','Pancreas','Ovarian','Testicular','Mouth','Leukaemia'};
organList ={'Bladder','Bowel','Brain','Breast','Kidney','Leukaemia','Liver','Lung','Lymphoma','Melanoma','Mouth','Ovarian','Pancreas','Prostate','Sarcoma','Stomach','Testicular','Uterus'};

plot(yearsAnalysis(1:67),EntriesPerOrgan(3:end,1:67),'linewidth',2);
grid on;axis tight
hLegendOrgan =legend(organList,'location','southeast');
set(gca,'yscale','log')
%%
ColorOrder_1=[   0           0           0.0000
                 0.65           0.65000      0.65];

ColorOrder_2=[  0           0           0.0000
                0.0         0.0000      1
                0.0         0.5         0
                0.9500      0.0000      0
                0           0.7500      0.7500
                0.300      0           0.7500

                0.8500      0.3250      0.0980
                0.7500      0.75        0.75
                0.4940      0.1840      0.5560
                0.3010      0.7450      0.9330
                0.6350      0.0780      0.1840];
           % set(groot,'defaultAxesColorOrder',NewColOrder,'defaultAxesLineStyleOrder','-|--|-.')

          
set(groot,'defaultAxesColorOrder',ColorOrder_2,...
      'defaultAxesLineStyleOrder','-|--|-.|:|-o|--x|-.v|:+|-^|--d|-.s|-');    
figure(30)
%organList ={'Breast','Lung','Prostate','Liver','Brain','Bowel','Pancreas','Ovarian','Testicular','Mouth','Leukaemia','Other'};

totalEntries    = repmat((EntriesPerOrgan(2,1:67)),[numel(organList),1]);
 plot(yearsAnalysis(1:67),EntriesPerOrgan(3:end,1:67)./totalEntries,'linewidth',2,'markersize',6);
% plot(yearsAnalysis(1:67),EntriesPerOrgan(3:end,1:67)./totalEntries,yearsAnalysis(1:67),(EntriesPerOrgan(2,1:67)-   sum(EntriesPerOrgan(3:end,1:67)))./EntriesPerOrgan(2,1:67),'linewidth',2,'markersize',6);
grid on;axis tight
hLegendOrgan =legend(organList,'location','southeastoutside');
%set(gca,'yscale','log')

set(hLegendOrgan,'fontsize',10)
ylabel('% of Cancer Entries','fontsize',14)
            
set(gcf,'Position',[   266   497   817   245])


%%
%figure
hold off
plot(   yearsAnalysis,EntriesPerOrgan(3,:)./EntriesPerOrgan(2,:),'color',[0     0   0], 'linestyle','-','linewidth',1);         % Bladder
    hold on
plot(   yearsAnalysis,EntriesPerOrgan(4,:)./EntriesPerOrgan(2,:) ,'color',[0     0   1], 'linestyle','-','linewidth',3);         % Bowel
plot(   yearsAnalysis,EntriesPerOrgan(5,:)./EntriesPerOrgan(2,:) ,'color',[0.4     0.4 0.4], 'linestyle','--','linewidth',0.5,'marker','o','markersize',4);       % Brain   5
plot(   yearsAnalysis,EntriesPerOrgan(6,:)./EntriesPerOrgan(2,:) ,'color',[1     0   0], 'linestyle','-','linewidth',5);        % Breast  1
plot(   yearsAnalysis,EntriesPerOrgan(7,:)./EntriesPerOrgan(2,:) ,'color',[0.9   0   0.75],'linestyle','-','linewidth',3.5);    % Kidney
plot(   yearsAnalysis,EntriesPerOrgan(8,:)./EntriesPerOrgan(2,:) ,'color',[0.5   0.5 0.5],'linestyle','-.','linewidth',2,'marker','s','markersize',5);       % Leukaemia
plot(   yearsAnalysis,EntriesPerOrgan(9,:)./EntriesPerOrgan(2,:) ,'color',[0.05  0.5   0.05],'linestyle','-.','linewidth',1,'marker','v','markersize',5);    % Liver   3
plot(   yearsAnalysis,EntriesPerOrgan(10,:)./EntriesPerOrgan(2,:),'color',[0.0   0.0 0.5],'linestyle','-','linewidth',2,'marker','+','markersize',8);    % Lung   2
plot(   yearsAnalysis,EntriesPerOrgan(11,:)./EntriesPerOrgan(2,:),'color',[0.5   0.05 0.5],'linestyle','-','linewidth',1);    % Lymphoma
plot(   yearsAnalysis,EntriesPerOrgan(12,:)./EntriesPerOrgan(2,:),'color',[0.25   0.25 0.75],'linestyle','--','linewidth',1,'marker','*','markersize',6);    % Melanoma
plot(   yearsAnalysis,EntriesPerOrgan(13,:)./EntriesPerOrgan(2,:),'color',[0.25   0.25 0.25],'linestyle','-.','linewidth',3);    % Mouth
plot(   yearsAnalysis,EntriesPerOrgan(14,:)./EntriesPerOrgan(2,:),'color',[0.05   0.78513 0.25],'linestyle','-','linewidth',2);    % Ovarian
plot(   yearsAnalysis,EntriesPerOrgan(15,:)./EntriesPerOrgan(2,:),'color',[0.99   0.05 0.05],'linestyle','-','linewidth',1,'marker','v','markersize',6);    % Pancreas
plot(   yearsAnalysis,EntriesPerOrgan(16,:)./EntriesPerOrgan(2,:),'color',[0.05   0.05 0.05],'linestyle','-','linewidth',4);    % Prostate  4
plot(   yearsAnalysis,EntriesPerOrgan(17,:)./EntriesPerOrgan(2,:),'color',[0.75   0.75 0.75],'linestyle','-.','linewidth',2);    % Sarcoma
plot(   yearsAnalysis,EntriesPerOrgan(18,:)./EntriesPerOrgan(2,:),'color',[0.5   0.0 0.0],'linestyle',':','linewidth',2,'marker','o','markersize',4);    % Stomach
plot(   yearsAnalysis,EntriesPerOrgan(19,:)./EntriesPerOrgan(2,:),'color',[0.0   0.5 0.0],'linestyle','-','linewidth',1,'marker','d','markersize',4);    % Testicular
plot(   yearsAnalysis,EntriesPerOrgan(20,:)./EntriesPerOrgan(2,:),'color',[0.0   0.50 0.95],'linestyle','-','linewidth',4);    % Uterus
plot(   yearsAnalysis,EntriesPerOrgan(21,:)./EntriesPerOrgan(2,:),'color',[0.0   0.50 0.95],'linestyle','-','linewidth',4);    % Uterus
plot(   yearsAnalysis,EntriesPerOrgan(22,:)./EntriesPerOrgan(2,:),'color',[0.0   0.50 0.95],'linestyle','-','linewidth',4);    % Uterus
plot(   yearsAnalysis,EntriesPerOrgan(23,:)./EntriesPerOrgan(2,:),'color',[0.0   0.50 0.95],'linestyle','-','linewidth',4);    % Uterus
plot(   yearsAnalysis,EntriesPerOrgan(24,:)./EntriesPerOrgan(2,:),'color',[0.0   0.50 0.95],'linestyle','-','linewidth',4);    % Uterus



axis tight 
grid on

hLegendOrgan =legend(organList,'location','eastoutside');

set(hLegendOrgan,'fontsize',10)
ylabel('% of Cancer Entries','fontsize',14)
            
set(gcf,'Position',[   266   497   817   261])


%%



%%
%figure
hold off
% 6   Breast  1
plot(   yearsAnalysis,EntriesPerOrgan(6,:)./EntriesPerOrgan(2,:) ,'color',[1   0   0  ], 'linestyle','-','linewidth',5);     
hold on

% 10  Lung   2
plot(   yearsAnalysis,EntriesPerOrgan(10,:)./EntriesPerOrgan(2,:),'color',[0.0 0.0 0.5],'linestyle','-','linewidth',2,'marker','+','markersize',8);   
% 9   Liver   3
plot(   yearsAnalysis,EntriesPerOrgan(9,:)./EntriesPerOrgan(2,:) ,'color',0.49674*[0.8 0.8 0.8],'linestyle','-','linewidth',1,'marker','v','markersize',1);    
% 16  Prostate  4
plot(   yearsAnalysis,EntriesPerOrgan(16,:)./EntriesPerOrgan(2,:),'color',[0.0 0.0 0.0],'linestyle','-','linewidth',3);    
% 5  Brain   5
plot(   yearsAnalysis,EntriesPerOrgan(5,:)./EntriesPerOrgan(2,:) ,'color',[0.8 0.8 0.8], 'linestyle','-','linewidth',0.5,'marker','.','markersize',1);      
% 11  Lymphoma

plot(   yearsAnalysis,EntriesPerOrgan(11,:)./EntriesPerOrgan(2,:),'color',[0.0 0.4 0.0],'linestyle','--','linewidth',2,'marker','x','markersize',5);    
% 14  Ovarian
plot(   yearsAnalysis,EntriesPerOrgan(14,:)./EntriesPerOrgan(2,:),'color',[0.8 0.8 0.8],'linestyle','-','linewidth',1);    
% 12  Melanoma
plot(   yearsAnalysis,EntriesPerOrgan(12,:)./EntriesPerOrgan(2,:),'color',[0.8 0.4 0.0],'linestyle','-','linewidth',2,'marker','d','markersize',5);   
% 7   Kidney
plot(   yearsAnalysis,EntriesPerOrgan(7,:)./EntriesPerOrgan(2,:) ,'color',[0.8 0.8 0.8],'linestyle','-','linewidth',1); 
% 3  Bladder
plot(   yearsAnalysis,EntriesPerOrgan(3,:)./EntriesPerOrgan(2,:),'color', [0.0 0.3 0.8], 'linestyle','--','linewidth',2);         
% 18  Stomach
plot(   yearsAnalysis,EntriesPerOrgan(18,:)./EntriesPerOrgan(2,:),'color',[0.8 0.8 0.8],'linestyle','-','linewidth',1,'marker','.','markersize',1);    
% 17  Sarcoma
plot(   yearsAnalysis,EntriesPerOrgan(17,:)./EntriesPerOrgan(2,:),'color',[0.8 0.0 0.4],'linestyle','-','linewidth',2);    
% 4  Bowel
plot(   yearsAnalysis,EntriesPerOrgan(4,:)./EntriesPerOrgan(2,:) ,'color',[0.8 0.8 0.8], 'linestyle','-','linewidth',1);     
% 15  Pancreas
plot(   yearsAnalysis,EntriesPerOrgan(15,:)./EntriesPerOrgan(2,:),'color',[0.7 0.0 0.0],'linestyle','-.','linewidth',3,'marker','.','markersize',1);  
% 13  Mouth
plot(   yearsAnalysis,EntriesPerOrgan(13,:)./EntriesPerOrgan(2,:),'color',[0.8 0.8 0.8],'linestyle','-','linewidth',1);   
% 19  Testicular
plot(   yearsAnalysis,EntriesPerOrgan(19,:)./EntriesPerOrgan(2,:),'color',[0.54641 0.0 0.30844],'linestyle','-','linewidth',1,'marker','.','markersize',8);   
% 8   Leukaemia
plot(   yearsAnalysis,EntriesPerOrgan(8,:)./EntriesPerOrgan(2,:) ,'color',[0.8 0.8 0.8],'linestyle','-','linewidth',1,'marker','.','markersize',1);      
% 20  Uterus
plot(   yearsAnalysis,EntriesPerOrgan(20,:)./EntriesPerOrgan(2,:),'color',[0.41053 0.72727 0.60105],'linestyle','-','linewidth',3);    
%
axis tight 
grid on

hLegendOrgan =legend(organList{indexMaxOccurrence-2},'location','eastoutside');

set(hLegendOrgan,'fontsize',10)
ylabel('% of Cancer Entries','fontsize',14)
            
%set(gcf,'Position',[   266   497   817   261])

%%


[maxOccurrence2016,indexMaxOccurrence] = sort(EntriesPerOrgan(3:end,67),'descend');
indexMaxOccurrence = indexMaxOccurrence +2;
qqq= (EntriesPerOrgan(indexMaxOccurrence,1:67))./totalEntries;
area(qqq')

%area((EntriesPerOrgan(3:end,:)./totalEntries)')
