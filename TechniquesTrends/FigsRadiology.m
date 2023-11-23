clear all
close all
%cd('C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\PubMed-Data-Mining-And-Visualisation\TechniquesTrends')
cd('/Users/ccr22/Academic/GitHub/PubMed-Data-Mining/TechniquesTrends')

%% Find out the occurrence of different terms related to cancer AND pathology AND keywords:

allF                    = '%5BAll%20Fields%5D'; % all fields code
%allF2                    = '%5BMeSH%20Terms%5D'; % all fields code
basicURL                = 'https://www.ncbi.nlm.nih.gov/pubmed/?term=';

yearsAnalysis           = 1990:2024;                            
KW_Radiology            =  strcat('%20AND%20(radiology%20OR%20radiography)');
KW_Dates                = strcat('%20AND%20(',num2str(yearsAnalysis(1)),':',num2str(yearsAnalysis(end)),'[dp])');

keywords={  'Deep learning','Artificial intelligence','Machine learning',...
           'Convolutional neural','Expert systems','Generative adversarial','Natural language processing','ChatGPT',...
            'Computer vision',''};               
numKeywords = numel(keywords);                       
                       
        
%% Iterate over pubmed
%clear entries_per_KW
for index_kw=1:numKeywords
    kw=keywords{index_kw};
    
    urlAddress          = strcat(basicURL,'%20%28%22',strrep(kw,' ','%20'),'%22%29',KW_Radiology,KW_Dates);
    disp(index_kw)
    PubMedURL                           = urlread(urlAddress);

        location_init   = strfind(PubMedURL,'yearCounts');
        location_fin    = strfind(PubMedURL,'startYear');
        PubMedURL2      = strrep(PubMedURL(location_init+14:location_fin-11),' ','');
        PubMedURL2      = strrep(PubMedURL2,'"','');
        PubMedURL2      = strrep(PubMedURL2,']','');
        PubMedURL2      = strrep(PubMedURL2,'[','');
        years_tokens    = split(PubMedURL2,',');
        %num_entries   = str2num(cell2mat(years_tokens(2:2:end)));
        if isempty(years_tokens{1,1})
            % there is just one year and thus the results are not broken down per
            % year, add in the last position
            location_init   = strfind(PubMedURL,'data-results-amount');
            location_fin    = strfind(PubMedURL,'data-pages-amount');
            PubMedURL2      = strrep(PubMedURL(location_init+20:location_fin-7),' ','');
            PubMedURL2      = strrep(PubMedURL2,'"','');
            num_entries = str2double(PubMedURL2);
            entries_per_KW(index_kw,numel(yearsAnalysis)-1) = num_entries;           
        else
            for index_year=1:2:numel(years_tokens)
                val_year    = str2double(years_tokens{index_year});
                num_entries = str2double(years_tokens{index_year+1});
                entries_per_KW(index_kw,round((val_year)-(yearsAnalysis(1)-1))) = num_entries;
            end
        end
end
years         = str2num(cell2mat(years_tokens(1:2:end)));     
       
%% Display as bar chart
h01=figure(1);
h20=gca;

allEntries_KW = sum(entries_per_KW(1:end-1,:),2);
[entries_all,index_all]=sort(allEntries_KW,'descend');
h21=bar(allEntries_KW(index_all(end:-1:1)));
h20.XTick=1:numKeywords-1;
h20.XTickLabel=keywords(index_all(end:-1:1));
h20.XTickLabelRotation=270;
h20.FontSize = 11;
h20.YLabel.FontSize=16;
h20.YLabel.String='Num. Entries';
h20.YLim=[10 30000];
h20.YScale = 'log';
h01.Position = [100  100  700  410];
h20.Position     = [ 0.1    0.40    0.89   0.55];
h20.FontName='Arial';
grid on
filename = 'Fig_1_Radiography.png';
print('-dpng','-r400',filename)

%%



%numYears        = numel(years);
numYears        = round((val_year)-yearsAnalysis(1)-1);
initialYear     = 1;
h02              = figure(2);
h1              = gca;
h11             = ribbon(1+entries_per_KW([ 2  9   7 3 1  4  6  8 5],1:end-1)');
h1.YTick        = (1:5:numYears);
h1.YTickLabel   = years(1:5:end);
%h1.YLim         = [initialYear numYears+1];
h1.XTick        = (1:numKeywords);
h1.XTickLabel   = keywords([ 2    9 7 3 1  4  6  8 5]);%   keywords(index_all);
%h1.XLim         = [1 numKeywords];
%h1.ZLim         = [0 max(max(entries_per_KW(1:end-1,initialYear:end)))];
h1.XTickLabelRotation=270;
h1.View         = [ 44 25];
h1.FontSize     = 10;
axis tight
h1.ZLabel.String='Num. Entries';
h1.ZLabel.FontSize=14;
h1.YLabel.String='Years';
h1.YLabel.FontSize=14;
h02.Position = [100  100  700  410];
h1.Position     = [ 0.11    0.32    0.8605    0.65];
h1.View = [ 54 33]; 
h1.ZScale='log';

%%
colormap jet
colormap3 = 0.7*jet(numKeywords-1);
%colormap (colormap3(1:end-1,:))
for i = 1:numKeywords-1
    h1.XTickLabel{i} = [sprintf('\\color[rgb]{%f,%f,%f}%s',colormap3(i,:)) h1.XTickLabel{i}];
end
%%

filename = 'Fig_2_Radiography.png';
print('-dpng','-r400',filename)

%% Obtain relative number of entries

% First, relative to all entries of the year without the keyword
entries_per_KW_rel  = entries_per_KW(1:numKeywords-1,:)./...
                        (1+repmat(entries_per_KW(numKeywords,:),[numKeywords-1 1]));
% Second, relative to the entries of the keywords                    
entries_per_KW_rel2 = entries_per_KW(1:numKeywords-1,:)./...
                        (repmat(sum(entries_per_KW(1:end-1,:)),[numKeywords-1 1]));

%% Display as relative metrics
h03              = figure(3);
h2              = subplot(211);
h22             = ribbon(entries_per_KW_rel2(index_all,:)');
h2.YTick        = (1:5:numYears);
h2.YTickLabel   = years(1:5:end);
%h2.YLim         = [initialYear numYears+1];
h2.XTick        = (1:numKeywords);
h2.XTickLabel   = keywords(index_all);
%h2.XLim         = [1 numKeywords];
%h2.ZLim         = [0 max(max(entries_per_KW_rel2(:,initialYear:end)))];
h2.XTickLabelRotation=270;
h2.View         = [ 170   30];
h2.FontSize     = 10;
axis tight
%h2.ZLabel.String='Entries/Keyword Total';
h2.ZLabel.String='Rel. Num. Entries';
h2.ZLabel.FontSize=14;
h2.YLabel.String='Years';
h2.YLabel.FontSize=14;
%h03.Position = [100  100  700  410];

h03.Position = [100  100  700  410];

%h2.XTickLabel=[];
h2.Position     = [ 0.11    0.32    0.8605    0.65];

%h3.Position     = [ 0.11    0.26    0.8605    0.35];
% h3.FontName='Arial';
filename = 'Fig_B_TrendsTechniquesYears.png';
%print('-dpng','-r400',filename)
h2.YLabel.FontSize=12;
% h3.YLabel.FontSize=12;
h2.ZLabel.FontSize=11;
% h3.ZLabel.FontSize=11;
h2.ZLabel.Position = [ 28.5769    0.1747    0.1823];
% h3.ZLabel.Position = [22.6    0.5034    0.0265];
%%
% for i = 1:numKeywords-1
%     h2.XTickLabel{i} = [sprintf('\\color[rgb]{%f,%f,%f}%s',colormap3(i,:)) h2.XTickLabel{i}];
% end

