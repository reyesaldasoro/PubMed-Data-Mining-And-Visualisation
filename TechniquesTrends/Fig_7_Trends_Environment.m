clear all
close all
%% Find out the occurrence of different terms related to cancer AND pathology AND keywords:

allF                    = '%5BAll%20Fields%5D'; % all fields code
%allF2                    = '%5BMeSH%20Terms%5D'; % all fields code
basicURL                = 'https://www.ncbi.nlm.nih.gov/pubmed/?term=';

keywords={'(Matlab))%20NOT%20((rural)%20AND%20(bangladesh))',...
          '(Python)%20NOT%20(snake)%20NOT%20(python%20regius)',...
          '(%22R%20project%22)%20OR%20(%22R%20package%22)%20OR%20(Rstudio)%20OR%20(R/Shiny)',...
          '(%22C programming%22)%20OR%20(%22C language%22)%20OR%20(%22C package%22)',...
          };
    
        
numKeywords = numel(keywords);                       
                       
yearsAnalysis           = 2010:2022;                            


        

%% Iterate over pubmed 
% Run twice, one with all the keywords and one with only the language and dates
%clear entries_per_KW*
for index_kw=1:numKeywords
    kw=keywords{index_kw};    
    urlAddress          = strcat(basicURL,'%20%28',strrep(kw,' ','%20'),'%29');
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
%%

keywords2={'Matlab','Python','R','C','CellProfiler','Fiji','ICY','ImageJ','QuPath'};

basicURL                = 'https://www.ncbi.nlm.nih.gov/pubmed/?linkname=pubmed_pubmed_citedin&from_uid=';
keywords={'17269487',...
          '22743772',...
          '22743774',...
          '22930834',...
          '29203879'};
numKeywords2 = numel(keywords); 

for index_kw=1+numKeywords:numKeywords+numKeywords2
    kw=keywords{index_kw-numKeywords};    
    urlAddress          = strcat(basicURL,kw);
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
%%


%% Display as bar chart
h0=figure(1);
h0.Position = [100  100  700  410];

h01=subplot(121);

allEntries_KW = sum(entries_per_KW_all(:,:),2);
[entries_all,index_all]=sort(allEntries_KW,'descend');
h21=bar(allEntries_KW(index_all(end:-1:1)));
h01.XTick=1:numKeywords+numKeywords2;
h01.XTickLabel=keywords2(index_all(end:-1:1));
h01.XTickLabelRotation=270;
h01.FontSize = 11;
h01.YLabel.FontSize=16;
h01.YLabel.String='Num. entries';

h01.Position     = [ 0.09    0.26    0.38   0.67];
h01.FontName='Arial';
grid on
h01.YScale='log';
%%
% yearsAnalysis           = 2010:2022;   
% h02=subplot(122);
% 
% allEntries_KW = sum(entries_per_KW_all(:,:),2);
% [entries_all,index_all2]=sort(allEntries_KW,'descend');
% h21=bar(allEntries_KW(index_all2(end:-1:1)));
% h02.XTick=1:numKeywords;
% h02.XTickLabel=keywords2(index_all2(end:-1:1));
% h02.XTickLabelRotation=270;
% h02.FontSize = 11;
% h02.YLabel.FontSize=16;
% h02.YLabel.String='Num. entries';
% h0.Position = [100  170  700  310];
% h02.Position     = [ 0.59    0.26    0.38   0.67];
% h02.FontName='Arial';
% grid on
% %print('-dpng','-r400',filename)
% h01.Title.String='All keywords';
% h02.Title.String='Date and prog. language / software';

%% Prepare colormap
colormap1 = bone;
colormap1(:,3)=1;
colormap2 = colormap1(end:-1:1,[3 2 1]);
colormap3 = [colormap1;colormap2];




colormap2=[...
         0    0.4470    0.7410
    1.0000         0         0
    0.8500    0.3250    0.0980
    0.9290    0.6940    0.1250
    0.4940    0.1840    0.5560
    0.3660    0.5740    0.0880
    0.3010    0.7450    0.9330
    0.6350    0.0780    0.1840
    0.7       0.7       0.7
    0.3       0.3       0.3
    1.0000         0         0
         0    0.4470    0.7410
    0.8500    0.3250    0.0980
    0.9290    0.6940    0.1250
    0.4940    0.1840    0.5560
    0.3660    0.5740    0.0880
    0.3010    0.7450    0.9330
    0.6350    0.0780    0.1840
    0.7       0.7       0.7
    0.3       0.3       0.3
    1.0000         0         0
         0    0.4470    0.7410
    0.8500    0.3250    0.0980
    0.9290    0.6940    0.1250
    0.4940    0.1840    0.5560
    0.3660    0.5740    0.0880
    0.3010    0.7450    0.9330
    0.6350    0.0780    0.1840
    0.7       0.7       0.7
    0.3       0.3       0.3 ];


colormap3=colormap2(1:numKeywords+numKeywords2,:);

%% Display as ribbons per year total
% %numYears        = numel(years);
% numYears        = round((val_year)-yearsAnalysis(1)-1);
% initialYear     = 1;
% 
% %h1=figure(2);
% h11=subplot(122);
% 
% h111             = ribbon(1+entries_per_KW_all(index_all,1:end-1)');
% h11.YTick        = (1:5:numYears);
% h11.YTickLabel   = yearsAnalysis(1:5:end);
% %h11.YLim         = [initialYear numYears+1];
% h11.XTick        = (1:numKeywords);
% h11.XTickLabel   = keywords2(index_all);
% %h11.XLim         = [1 numKeywords];
% %h11.ZLim         = [0 max(max(entries_per_KW(1:end-1,initialYear:end)))];
% h11.XTickLabelRotation=0;
% 
% h11.FontSize     = 10;
% axis tight
% h11.ZLabel.String='Entries';
% h11.ZLabel.FontSize=16;
% h11.YLabel.String='Years';
% h11.YLabel.FontSize=16;
% h1.Position = [100  100  700  410];
%%

yearsAnalysis           = 2010:2022;   
numYears        = round((val_year)-yearsAnalysis(1)-1);
h02=subplot(122);

h112             = ribbon(1+entries_per_KW_all(index_all,1:end-1)');
h02.YTick        = (1:5:numYears);
h02.YTickLabel   = yearsAnalysis(1:5:end);
%h02.YLim         = [initialYear numYears+1];
h02.XTick        = (1:numKeywords+numKeywords2);
h02.XTickLabel   = keywords2(index_all);
%h02.XLim         = [1 numKeywords];
%h02.ZLim         = [0 max(max(entries_per_KW(1:end-1,initialYear:end)))];
h02.XTickLabelRotation=0;

h02.FontSize     = 10;
axis tight
h02.ZLabel.String='Num. Entries';
h02.ZLabel.FontSize=16;
h02.YLabel.String='Years';
h02.YLabel.FontSize=16;


%h11.Title.String='All keywords';
%h02.Title.String='Date and prog. language / software';
h01.Position     = [ 0.09    0.21    0.36   0.75];
h02.Position     = [ 0.57    0.19    0.36   0.75];
%
h02.View        = [50 20];
%h02.View        = [170 30];
%
colormap (colormap3)

h02.ZScale = 'log';
h02.XTickLabelRotation=270;
%%
for i = 1:numKeywords+numKeywords2
    h02.XTickLabel{i} = [sprintf('\\color[rgb]{%f,%f,%f}%s',colormap3(i,:)) h02.XTickLabel{i}];
end
%%
axis([0.5 9.5 1 12 1 max(entries_per_KW_all(:))])


%% assign names and print

filename = 'Fig_7_TrendsEnvironments.png';
print(h0,'-dpng','-r400',filename)

%filename = 'Fig_8_TrendsEnvironmentsYears.png';
%print(h1,'-dpng','-r400',filename)



%%



