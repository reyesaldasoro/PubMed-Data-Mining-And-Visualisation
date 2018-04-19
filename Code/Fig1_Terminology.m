%% Text mining of PubMed for Cancer status

%% Figure 1 Number of Cancer-related entries for different keywords listed in
% decreasing order.
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


%% Find out the occurrence of different terms related to cancer:

allF                    = '%5BAll%20Fields%5D'; % all fields code
%allF2                    = '%5BMeSH%20Terms%5D'; % all fields code
basicURL                = 'https://www.ncbi.nlm.nih.gov/pubmed/?term=';
CancerKeyWords          = {'neoplasms','cancer','tumor','neoplasm','tumors','oncology',...
                           'metastasis','cancers',...
                           'tumour','tumours','neoplasia'};

%% Find out the occurence of the terms and combination of terms with 'OR'

for counterKW = 1:11
    disp(counterKW)
    for counterKW2 = counterKW:11        
        % This is the code to select cancer entries combined with year
        urlAddress                          = strcat(basicURL,strcat('%22',CancerKeyWords{counterKW},'%22',allF,'OR%22',CancerKeyWords{counterKW2},'%22',allF));
        PubMedURL                           = urlread(urlAddress);
        % Find the field "Count"
        locCount_init                       = strfind(PubMedURL,'count" content="');
        locCount_fin                        = strfind(PubMedURL(locCount_init+16:locCount_init+300),'"');
        % Determine the number of entries with the selected key words
        numEntriesPubMed                    = (PubMedURL(locCount_init+16:locCount_init+16+locCount_fin(1)-2));
        combinedEntries(counterKW,counterKW2) = str2double(numEntriesPubMed);
    end
end

%% Display the keywords as a bar chart
figure
clf
bar(diag(combinedEntries)/1e6);
hAxis  = gca;
set(hAxis,'xticklabel',CancerKeyWords,'fontsize',14)
ylabel('Millions of Entries in PubMed')
%title('(a)','fontsize',18)
hAxis.XTickLabelRotation = 90;
grid on
set(gcf,'Position',[   70   300   800   400]);

