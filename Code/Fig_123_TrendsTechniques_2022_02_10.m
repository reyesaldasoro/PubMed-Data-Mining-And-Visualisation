clear all

%% Find out the occurrence of different terms related to cancer AND pathology AND keywords:

allF                    = '%5BAll%20Fields%5D'; % all fields code
%allF2                    = '%5BMeSH%20Terms%5D'; % all fields code
basicURL                = 'https://www.ncbi.nlm.nih.gov/pubmed/?term=';

yearsAnalysis           = 1990:2022;                            
KW_Pathology            =  strcat('%20AND%20(pathology)');
KW_Cancer               =  strcat('%20AND%20(cancer)');
KW_ImageAnalysis        =  strcat('%20AND%20((image)+OR+(imaging))');                       
KW_Dates                = strcat('%20AND%20(',num2str(yearsAnalysis(1)),':',num2str(yearsAnalysis(end)),'[dp])');


keywords={  'texture analysis','Fourier','geometric','tracing','linear discriminant analysis',...
            'thresholding','feature extraction',...
            'tracking','clustering', 'scale space','hessian', 'self-organizing',...
            'region growing','mutual information','wavelet','multiresolution',...
            'principal component analysis','filtering','active contour','fractal',...
            'linear regression','ensemble',...
            'transfer learning','convolutional neural',...
            'machine learning','deep learning',''};

keywords2={ 'texture analysis','Fourier','geometric','tracing','linear disc. anal.',...
            'thresholding','feature extraction',...
            'tracking','clustering', 'scale space','hessian', 'self-organizing',...
            'region growing','mutual information','wavelet','multiresolution',...
            'principal comp. anal.','filtering','active contour','fractal',...
            'linear regression','ensemble',...
            'transfer learning','convolutional neural',...
            'machine learning','deep learning',''};        
        
numKeywords = numel(keywords);                       
                       


        
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
        
        for index_year=1:2:numel(years_tokens)
            val_year    = str2double(years_tokens{index_year});
            num_entries = str2double(years_tokens{index_year+1});
            entries_per_KW(index_kw,round((val_year)-(yearsAnalysis(1)-1))) = num_entries;
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
h20.XTickLabel=keywords2(index_all(end:-1:1));
h20.XTickLabelRotation=270;
h20.FontSize = 11;
h20.YLabel.FontSize=16;
h20.YLabel.String='Num. entries';
h01.Position = [100  100  700  410];
h20.Position     = [ 0.1    0.38    0.89   0.58];
h20.FontName='Arial';
grid on
filename = 'Fig_A_TrendsTechniques.png';
%print('-dpng','-r400',filename)


%% Display as ribbons per year total
% Prepare colormap blue-red
% colormap1 = bone;
% colormap1(:,3)=1;
% colormap2 = colormap1(end:-1:1,[3 2 1]);
% colormap3 = [colormap1;colormap2];

% Prepare colormap random
% colormap3 = rand(numKeywords,3);

% colormap2 =...
%    [1.0000         0         0
%     1.0000    0.5000         0
%     0.6000    0.4000         0
%          0    0.8000         0
%          0         0    1.0000
%     0.5       0.5       0.5
%     0.6667         0    1.0000
%     0.7000         0         0
%     0.4000    0.6000         0
%     0.2000    0.0000         0.9
%     0.4       0.70000        0.5
%     0.04         0    0.7000
%     0.7       0.7       0.7 
%     0.6667         0    0.4000
%     1.0000         0       0.2
%     1.0000    0.5000       0.2
%     0.4000    0.4000       0.2
%        0.3    0.2000       0.2
%        0.2       0.2    1.0000
%     0.6667       0.2    1.0000
%     1.0000       0.2         0
%     1.0000    0.5000         0
%     0.1000    0.1000       0.1
%     0.6667         0    1.0000
%          0    0.4000         0
%          0         0    1.0000
%     1.0000         0         0
%     1.0000    0.5000         0
%     0.1000    0.1000        0.1
%     1.0000         0         0
%     1.0000    0.5000         0
%     0.6000    0.4000         0
%     0    1.0000         0
%          0         0    1.0000
%     0.6667         0    1.0000];

colormap2=[...
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


%%



%numYears        = numel(years);
numYears        = round((val_year)-yearsAnalysis(1)-1);
initialYear     = 1;
h02              = figure(2);
h1              = gca;
h11             = ribbon(entries_per_KW(index_all,1:end-1)');
h1.YTick        = (1:5:numYears);
h1.YTickLabel   = years(1:5:end);
%h1.YLim         = [initialYear numYears+1];
h1.XTick        = (1:numKeywords);
h1.XTickLabel   = keywords2(index_all);
%h1.XLim         = [1 numKeywords];
%h1.ZLim         = [0 max(max(entries_per_KW(1:end-1,initialYear:end)))];
h1.XTickLabelRotation=270;
h1.View         = [ 170 30];
h1.FontSize     = 10;
axis tight
h1.ZLabel.String='Entries';
h1.ZLabel.FontSize=14;
h1.YLabel.String='Years';
h1.YLabel.FontSize=14;
h02.Position = [100  100  700  410];
h1.Position     = [ 0.11    0.32    0.8605    0.65];
colormap (colormap3(1:end-1,:))
for i = 1:numKeywords-1
    h1.XTickLabel{i} = [sprintf('\\color[rgb]{%f,%f,%f}%s',colormap3(i,:)) h1.XTickLabel{i}];
end


%% Obtain relative number of entries
% First, relative to all entries of the year without the keyword
entries_per_KW_rel  = entries_per_KW(1:numKeywords-1,:)./...
                        (1+repmat(entries_per_KW(numKeywords,:),[numKeywords-1 1]));
% Second, relative to the entries of the keywords                    
entries_per_KW_rel2 = entries_per_KW(1:numKeywords-1,:)./...
                        (1+repmat(sum(entries_per_KW(1:end-1,:)),[numKeywords-1 1]));

%% Display as relative metrics
h03              = figure(3);
h2              = subplot(211);
h22             = ribbon(entries_per_KW_rel2(index_all,:)');
h2.YTick        = (1:5:numYears);
h2.YTickLabel   = years(1:5:end);
%h2.YLim         = [initialYear numYears+1];
h2.XTick        = (1:numKeywords);
h2.XTickLabel   = keywords2(index_all);
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
colormap (colormap3)


h2.FontName='Arial';%
%filename = 'Fig_B_TrendsTechniquesYears.png';
%print('-dpng','-r400',filename)
%
%h03              = figure(3);
% h3              = subplot(212);
% h32             = ribbon(entries_per_KW_rel');
% h3.YTick        = (1:10:numYears);
% h3.YTickLabel   = years(1:10:end);
% %h3.YLim         = [initialYear numYears+1];
% h3.XTick        = (1:numKeywords);
% h3.XTickLabel   = keywords2;
% %h3.XLim         = [1 numKeywords];
% %h3.ZLim         = [0 max(max(entries_per_KW_rel(:,initialYear:end)))];
% h3.XTickLabelRotation=270;
% h3.View         = [ 170.3979   32.7538];
% h3.FontSize     = 10;
% axis tight
% 
% h3.ZLabel.String='Entries/Year Total';
% h3.ZLabel.FontSize=16;
% h3.YLabel.String='';
% h3.YLabel.FontSize=16;
colormap (colormap3(1:end-1,:))
%
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
%
for i = 1:numKeywords-1
    h2.XTickLabel{i} = [sprintf('\\color[rgb]{%f,%f,%f}%s',colormap3(i,:)) h2.XTickLabel{i}];
end


%% assign names and print

filename = 'Fig_1_TrendsTechniquesYears_2022_02_12.png';
print(h01,'-dpng','-r400',filename)

filename = 'Fig_2_TrendsTechniquesYears_2022_02_12.png';
print(h02,'-dpng','-r400',filename)

filename = 'Fig_3_TrendsTechniquesYears_2022_02_12.png';
print(h03,'-dpng','-r400',filename)



%%



