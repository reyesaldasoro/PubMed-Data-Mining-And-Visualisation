clear all
close all
%% Find out the occurrence of different terms related to cancer AND pathology AND keywords:

allF                    = '%5BAll%20Fields%5D'; % all fields code
%allF2                    = '%5BMeSH%20Terms%5D'; % all fields code
basicURL                = 'https://www.ncbi.nlm.nih.gov/pubmed/?term=';

keywords={'Matlab',...
          '(Python)%20NOT%20(snake)%20NOT%20(python%20regius)',...
          '(%22R%20package%22)%20OR%20(Rstudio)',...
          '(%22C programming%22)%20OR%20(%22C language%22)%20OR%20(%22C package%22)' };
    
keywords2={'Matlab','Python','R','C'};
        
numKeywords = numel(keywords);                       
                       
yearsAnalysis           = 2010:2022;                            
KW_Pathology            =  strcat('%20AND%20(pathology)');
KW_Cancer               =  strcat('%20AND%20(cancer)');
KW_ImageAnalysis        =  strcat('%20AND%20((image)+OR+(imaging))');                       
KW_Dates                = strcat('%20AND%20(',num2str(yearsAnalysis(1)),':',num2str(yearsAnalysis(end)),'[dp])');


        

%% Iterate over pubmed 
% Run twice, one with all the keywords and one with only the language and dates
clear entries_per_KW*
for index_kw=1:numKeywords
    kw=keywords{index_kw};    
    urlAddress          = strcat(basicURL,'%20%28',strrep(kw,' ','%20'),'%29',KW_Pathology,KW_Cancer,KW_ImageAnalysis,KW_Dates);
    disp(index_kw)
    PubMedURL                           = urlread(urlAddress);
    % Parse the URL to find the locations of years and count of entries
        location_init   = strfind(PubMedURL,'yearCounts');
        location_fin    = strfind(PubMedURL,'startYear');
        PubMedURL2      = strrep(PubMedURL(location_init+14:location_fin-11),' ','');
        PubMedURL2      = strrep(PubMedURL2,'"','');
        PubMedURL2      = strrep(PubMedURL2,']','');
        PubMedURL2      = strrep(PubMedURL2,'[','');
        years_tokens    = split(PubMedURL2,',');
        %num_entries   = str2num(cell2mat(years_tokens(2:2:end)));     
        numYearsResults = numel(years_tokens);
        % Allocate in the matrix with the results
        if numYearsResults>1
            for index_year=1:2:numYearsResults
                val_year    = str2double(years_tokens{index_year});
                num_entries = str2double(years_tokens{index_year+1});
                if val_year>=yearsAnalysis(1)
                    entries_per_KW_Cancer(index_kw,round((val_year)-(yearsAnalysis(1)-1))) = num_entries;
                end
            end
        end
end

for index_kw=1:numKeywords
    kw=keywords{index_kw};    
    urlAddress          = strcat(basicURL,'%20%28',strrep(kw,' ','%20'),'%29',KW_Dates);
    disp(index_kw)
    PubMedURL                           = urlread(urlAddress);
    % Parse the URL to find the locations of years and count of entries
        location_init   = strfind(PubMedURL,'yearCounts');
        location_fin    = strfind(PubMedURL,'startYear');
        PubMedURL2      = strrep(PubMedURL(location_init+14:location_fin-11),' ','');
        PubMedURL2      = strrep(PubMedURL2,'"','');
        PubMedURL2      = strrep(PubMedURL2,']','');
        PubMedURL2      = strrep(PubMedURL2,'[','');
        years_tokens    = split(PubMedURL2,',');
        %num_entries   = str2num(cell2mat(years_tokens(2:2:end)));     
        numYearsResults = numel(years_tokens);
        % Allocate in the matrix with the results
        if numYearsResults>1
            for index_year=1:2:numYearsResults
                val_year    = str2double(years_tokens{index_year});
                num_entries = str2double(years_tokens{index_year+1});
                if val_year>=yearsAnalysis(1)
                    entries_per_KW_all(index_kw,round((val_year)-(yearsAnalysis(1)-1))) = num_entries;
                end
            end
        end
end
       


%% Display as bar chart
h0=figure(10);
h01=subplot(121);

allEntries_KW = sum(entries_per_KW_Cancer(:,:),2);
[entries_all,index_all]=sort(allEntries_KW,'descend');
h21=bar(allEntries_KW(index_all));
h01.XTick=1:numKeywords;
h01.XTickLabel=keywords2(index_all);
h01.XTickLabelRotation=270;
h01.FontSize = 11;
h01.YLabel.FontSize=16;
h01.YLabel.String='Num. entries';
h0.Position = [100  100  700  410];
h01.Position     = [ 0.09    0.15    0.38   0.75];
h01.FontName='Arial';
grid on
% set(h20,'yscale','log')
h02=subplot(122);

allEntries_KW = sum(entries_per_KW_all(:,:),2);
[entries_all,index_all]=sort(allEntries_KW,'descend');
h21=bar(allEntries_KW(index_all));
h02.XTick=1:numKeywords;
h02.XTickLabel=keywords2(index_all);
h02.XTickLabelRotation=270;
h02.FontSize = 11;
h02.YLabel.FontSize=16;
h02.YLabel.String='Num. entries';
h0.Position = [100  100  700  410];
h02.Position     = [ 0.59    0.15    0.38   0.75];
h02.FontName='Arial';
grid on
%print('-dpng','-r400',filename)
h01.Title.String='All keywords';
h02.Title.String='Date and prog. language';

%% Prepare colormap
colormap1 = bone;
colormap1(:,3)=1;
colormap2 = colormap1(end:-1:1,[3 2 1]);
colormap3 = [colormap1;colormap2];
%% Display as ribbons per year total
%numYears        = numel(years);
numYears        = round((val_year)-yearsAnalysis(1)-1);
initialYear     = 1;

h1=figure(11);
h11=subplot(121);

h111             = ribbon(1+entries_per_KW_Cancer(index_all,1:end-1)');
h11.YTick        = (1:5:numYears);
h11.YTickLabel   = yearsAnalysis(1:5:end);
%h11.YLim         = [initialYear numYears+1];
h11.XTick        = (1:numKeywords);
h11.XTickLabel   = keywords2(index_all);
%h11.XLim         = [1 numKeywords];
%h11.ZLim         = [0 max(max(entries_per_KW(1:end-1,initialYear:end)))];
h11.XTickLabelRotation=0;
h11.View         = [ 160 20];
h11.FontSize     = 10;
axis tight
h11.ZLabel.String='Entries';
h11.ZLabel.FontSize=16;
h11.YLabel.String='Years';
h11.YLabel.FontSize=16;
h1.Position = [100  100  700  410];

h12=subplot(122);

h112             = ribbon(1+entries_per_KW_all(index_all,1:end-1)');
h12.YTick        = (1:5:numYears);
h12.YTickLabel   = yearsAnalysis(1:5:end);
%h12.YLim         = [initialYear numYears+1];
h12.XTick        = (1:numKeywords);
h12.XTickLabel   = keywords2(index_all);
%h12.XLim         = [1 numKeywords];
%h12.ZLim         = [0 max(max(entries_per_KW(1:end-1,initialYear:end)))];
h12.XTickLabelRotation=0;
h12.View         = [ 160 20];
h12.FontSize     = 10;
axis tight
h12.ZLabel.String='Entries';
h12.ZLabel.FontSize=16;
h12.YLabel.String='Years';
h12.YLabel.FontSize=16;

%%
h11.Title.String='All keywords';
h12.Title.String='Date and prog. language';
h11.Position     = [ 0.09    0.15    0.38   0.75];
h12.Position     = [ 0.59    0.15    0.38   0.75];

h11.View        = [74 20];
h12.View        = [74 20];
colormap (colormap3)



%% assign names and print

filename = 'Fig_7_TrendsEnvironments.png';
print(h0,'-dpng','-r400',filename)

filename = 'Fig_8_TrendsEnvironmentsYears.png';
print(h1,'-dpng','-r400',filename)



%%



