%% Text mining of PubMed for Cancer status
% Ratio of the number of entries that report a grant number of the National Cancer
% Institute (NCI) over the number of entries that report a grant number of the
% National Institute of Health (NIH) of which the NCI is part. This ratio is an
% indication of the Cancer-funding from this Institute in the United States. It can
% be seen that the the ratio has been relatively constant at around 20% from 1980.
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
NIHEntriesURL            =  strcat('AND%22NIH%22','[gr]');
NCIEntriesURL            =  strcat('AND%22NCI%22','[gr]');

%% Run per year per type
% Define the years to search and run the search for all the years and all
% the publication types. Find the "count" where the number of items of both
% cases are listed and store in a matrix

yearsAnalysis                   = 1950:2016;
Entries_With_NIH_Cancer(1,:)            = yearsAnalysis;


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
    urlAddress                          = strcat(basicURL,yearURL,NIHEntriesURL);
    PubMedURL                           = urlread(urlAddress);
    % Find the field "Count"
    locCount_init                       = strfind(PubMedURL,'count" content="');
    locCount_fin                        = strfind(PubMedURL(locCount_init+16:locCount_init+300),'"');
    numEntriesPubMed                    = (PubMedURL(locCount_init+16:locCount_init+16+locCount_fin(1)-2));
    Entries_With_NIH_Cancer(2,year-1949)        = str2double(numEntriesPubMed);

    % This is the code to select ALL cancer entries combined with year
    urlAddress                          = strcat(basicURL,yearURL,NCIEntriesURL);
    PubMedURL                           = urlread(urlAddress);
    % Find the field "Count"
    locCount_init                       = strfind(PubMedURL,'count" content="');
    locCount_fin                        = strfind(PubMedURL(locCount_init+16:locCount_init+300),'"');
    numEntriesPubMed                    = (PubMedURL(locCount_init+16:locCount_init+16+locCount_fin(1)-2));
    Entries_With_NIH_Cancer(3,year-1949)        = str2double(numEntriesPubMed);


end



%% Display number of publications per year and as a proportion

figure


plot(yearsAnalysis(1:67),Entries_With_NIH_Cancer(3,1:67)./Entries_With_NIH_Cancer(2,1:67),'b-','linewidth',2);

grid on;axis tight
ylabel('Ratio of NCI/NIH Grants','fontsize',14)
set(gcf,'Position',[   266   497   817   245])
 


