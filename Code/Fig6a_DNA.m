%% Text mining of PubMed for Cancer status
% First define the publication types valid in PubMed and MedLine
%       https://www.nlm.nih.gov/bsd/mms/medlineelements.html#pt
%       https://www.ncbi.nlm.nih.gov/books/NBK3827/table/pubmedhelp.T.publication_types/
%

%% Define the fields that refer to Cancer,
% Articles may appear with oncology but not cancer so use a combination of
% various terms

allF                    = '%5BAll+Fields%5D'; % all fields code
basicURL                = 'https://www.ncbi.nlm.nih.gov/pubmed/?term=';
%CancerEntriesURL            =  strcat('AND%22Cancer%22',allF);
%NoCancerEntriesURL           =  strcat('NOT%22cancer%22',allF);
CancerEntriesURL            =  strcat('AND(',  '%22neoplasms%22',allF,'OR','%22cancer%22',allF,'OR','%22tumor%22',allF,'OR','%22tumour%22',allF,'OR','%22oncology%22',allF,  ')');
NoCancerEntriesURL          =  strcat('NOT(',  '%22neoplasms%22',allF,'OR','%22cancer%22',allF,'OR','%22tumor%22',allF,'OR','%22tumour%22',allF,'OR','%22oncology%22',allF,  ')');


%% Run per year per type
% Define the years to search and run the search for all the years and all
% the publication types. Find the "count" where the number of items of both
% cases are listed and store in a matrix

yearsAnalysis                   = 1950:2016;
Entries_With_DNA(1,:)            = yearsAnalysis;

        DNA_KeyW         =  strcat('AND%20%22DNA%22%5BAll%20Fields%5D');
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
    urlAddress                          = strcat(basicURL,yearURL,DNA_KeyW,CancerEntriesURL);
    PubMedURL                           = urlread(urlAddress);
    % Find the field "Count"
    locCount_init                       = strfind(PubMedURL,'count" content="');
    locCount_fin                        = strfind(PubMedURL(locCount_init+16:locCount_init+300),'"');
    numEntriesPubMed                    = (PubMedURL(locCount_init+16:locCount_init+16+locCount_fin(1)-2));
    Entries_With_DNA(2,year-1949)        = str2double(numEntriesPubMed);

    % This is the code to select ALL cancer entries combined with year
    urlAddress                          = strcat(basicURL,yearURL,DNA_KeyW,NoCancerEntriesURL);
    PubMedURL                           = urlread(urlAddress);
    % Find the field "Count"
    locCount_init                       = strfind(PubMedURL,'count" content="');
    locCount_fin                        = strfind(PubMedURL(locCount_init+16:locCount_init+300),'"');
    numEntriesPubMed                    = (PubMedURL(locCount_init+16:locCount_init+16+locCount_fin(1)-2));
    Entries_With_DNA(3,year-1949)        = str2double(numEntriesPubMed);


end



%% Display number of publications per year and as a proportion

figure(4)

try
% yyaxis is introduced in release R2016a
yyaxis right
plot(yearsAnalysis(1:67),Entries_With_DNA(2,1:67)./(sum(Entries_With_DNA(2:end,1:67))),'b--','linewidth',2);
yyaxis left
plot(yearsAnalysis(1:67),Entries_With_DNA(3,1:67)./(sum(Entries_With_DNA(2:end,1:67))),'k-','linewidth',2);
catch
    % if yyaxis is not available, use plotyy
hAxis = plotyy(yearsAnalysis(1:67),Entries_With_DNA(2,1:67)./(sum(Entries_With_DNA(2:end,1:67))),...
yearsAnalysis(1:67),Entries_With_DNA(3,1:67)./(sum(Entries_With_DNA(2:end,1:67))));

hLine_1 = hAxis(1).Children;
hLine_2 = hAxis(2).Children;
set(hLine_1,'color','b','linestyle','--','linewidth',2)
set(hLine_2,'color','k','linewidth',2)
hAxis(1).XLim = [1950 2016];
hAxis(2).XLim = [1950 2016];
hAxis(1).YColor = 'b';
hAxis(2).YColor = 'k';


%
    hAxis(1).YLim = [0 0.3];
     hAxis(2).YLim = [ 1-0.3 1];
         hAxis(1).YTick = 0:0.05:0.35;
    hAxis(2).YTick = 0.65:0.05:1;

%
end

grid on;%axis tight
ylabel('Ratio of  Entries','fontsize',14)
  hLegend3 =legend('DNA AND Cancer','DNA NOT Cancer','location','south');
 set(hLegend3,'fontsize',14)

set(gcf,'Position',[   266   497   817   245])

%%


filename='Fig8_DNA_2016_11_03.tif';
set(gcf,'PaperPositionMode','auto')
print('-dtiff','-r300',filename)