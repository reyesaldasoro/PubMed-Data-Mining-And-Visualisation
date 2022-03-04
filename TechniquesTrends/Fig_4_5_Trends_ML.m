clear all
close all
%% Find out the occurrence of different terms related to cancer AND pathology AND keywords:

allF                    = '%5BAll%20Fields%5D'; % all fields code
%allF2                    = '%5BMeSH%20Terms%5D'; % all fields code
basicURL                = 'https://www.ncbi.nlm.nih.gov/pubmed/?term=';

keywords={'Classification',...
'Regression',...
'Dimensionality reduction',...
'Ensemble learning',...
'Reinforcement learning',...
'Supervised learning',...
'Bayesian',... 
'Decision tree',... 
'Linear classifier',...
'Unsupervised learning',...
'Artificial neural networks',...
'Hierarchical clustering',...
'Cluster analysis',...
'Anomaly detection',...
'Semi-supervised learning',...
'Deep learning',...
'Support Vector Machines',...
'Naive Bayes',...
'Nearest Neighbor',...
'Discriminant Analysis',...
'K-Means',...
'Hidden Markov Model',...
'Feature Selection',...
'Feature Engineering','Random Forest'};
 
 
 
numKeywords = numel(keywords);                       
                       
yearsAnalysis           = 2010:2022;                            
KW_Pathology            =  strcat('%20AND%20(pathology)');
KW_Cancer               =  strcat('%20AND%20(cancer)');
KW_ImageAnalysis        =  strcat('%20AND%20((image)+OR+(imaging))');                       
KW_Dates                = strcat('%20AND%20(',num2str(yearsAnalysis(1)),':',num2str(yearsAnalysis(end)),'[dp])');


        
%% Iterate over pubmed
%clear entries_per_KW
for index_kw=1:numKeywords
    kw=keywords{index_kw};
    
    urlAddress          = strcat(basicURL,'%20%28%22',strrep(kw,' ','%20'),'%22%29',KW_Pathology,KW_Cancer,KW_ImageAnalysis,KW_Dates);
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
        
        numYearsResults = numel(years_tokens);
        
        if numYearsResults>1
            for index_year=1:2:numYearsResults
                val_year    = str2double(years_tokens{index_year});
                num_entries = str2double(years_tokens{index_year+1});
                if val_year>=yearsAnalysis(1)
                    entries_per_KW(index_kw,round((val_year)-(yearsAnalysis(1)-1))) = num_entries;
                end
            end
        end
end
years         = str2num(cell2mat(years_tokens(1:2:end)));     
%years         = str2num(yearsAnalysis);  


%% Display as bar chart
h01=figure(12);
h20=gca;

allEntries_KW = sum(entries_per_KW(1:end,:),2);
[entries_all,index_all]=sort(allEntries_KW,'descend');
h21=bar(allEntries_KW(index_all(end:-1:1)));
h20.XTick=1:numKeywords;
h20.XTickLabel=keywords(index_all(end:-1:1));
h20.XTickLabelRotation=270;
h20.FontSize = 11;
h20.YLabel.FontSize=16;
h20.YLabel.String='Num. entries';
h20.YTick=[1 10 100 1000 10000];
h20.YLim=[1 1.2*max(allEntries_KW)];
h01.Position = [100  100  700  410];
h20.Position     = [ 0.1    0.49    0.89   0.44];
h20.FontName='Arial';
grid on
 set(h20,'yscale','log')

%print('-dpng','-r400',filename)

%% Prepare colormap
% colormap1 = bone;
% colormap1(:,3)=1;
% colormap2 = colormap1(end:-1:1,[3 2 1]);
% colormap3 = [colormap1;colormap2];


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


colormap3=colormap2(1:numKeywords,:);

%% Display as ribbons per year total
%numYears        = numel(years);
numYears        = round((val_year)-yearsAnalysis(1)-1);
initialYear     = 1;
h02              = figure(2);
h1              = gca;
h11             = ribbon(1+entries_per_KW(index_all,1:end-1)');
h1.YTick        = (1:5:numYears);
h1.YTickLabel   = yearsAnalysis(1:5:end);
%h1.YLim         = [initialYear numYears+1];
h1.XTick        = (1:numKeywords);
h1.XTickLabel   = keywords(index_all);
%h1.XLim         = [1 numKeywords];
%h1.ZLim         = [0 max(max(entries_per_KW(1:end-1,initialYear:end)))];
h1.XTickLabelRotation=270;
h1.View         = [ 170 30];
h1.FontSize     = 10;
axis tight
h1.ZLabel.String='Num. Entries';
h1.ZLabel.FontSize=16;
h1.YLabel.String='Years';
h1.YLabel.FontSize=16;
h02.Position = [100  100  700  410];
colormap (colormap3)
h1.ZScale='log';

for i = 1:numKeywords
    h1.XTickLabel{i} = [sprintf('\\color[rgb]{%f,%f,%f}%s',colormap3(i,:)) h1.XTickLabel{i}];
end


%% assign names and print

filename = 'Fig_4_Trends_ML.png';
print(h01,'-dpng','-r400',filename)

filename = 'Fig_5_Trends_ML_Years.png';
print(h02,'-dpng','-r400',filename)




%%



