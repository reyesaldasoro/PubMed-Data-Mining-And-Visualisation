clear all

%% Find out the occurrence of different terms related to cancer:

allF                    = '%5BAll%20Fields%5D'; % all fields code
%allF2                    = '%5BMeSH%20Terms%5D'; % all fields code
basicURL                = 'https://www.ncbi.nlm.nih.gov/pubmed/?term=';
CancerKeyWords          = {'neoplasms','cancer','tumor','neoplasm','tumors','oncology',...
                           'metastasis','cancers',...
                           'tumour','tumours','neoplasia'};
                       
KW_Pathology            =  strcat('%20(pathology',allF  );
KW_Cancer               =  strcat('%20AND%20(cancer',allF);

KW_ImageAnalysis        =  strcat('%20AND+%28%28%22image+processing%22',allF,'+OR+%28%22image+analysis%22',allF,'+%29');                       



%%

keywords={  'texture','Fourier','geometric','tracing','linear discriminant analysis',...
            'thresholding','feature extraction',...
            'tracking','clustering','scale space','hessian',...
            'region growing','mutual information','wavelet','multiresolution',...
            'self-organizing maps','principal component analysis',...
            'linear regression','ensemble',...
            'transfer learning','convolutional neural',...
            'machine learning','deep learning',''};


numKeywords = numel(keywords);
yearsAnalysis = 1970:2023;        
        
%%
clear entries_per_KW
for index_kw=1:numKeywords
    kw=keywords{index_kw};
    
    urlAddress          = strcat(basicURL,KW_Pathology,KW_Cancer,KW_ImageAnalysis,'%20AND%20%28%22',strrep(kw,' ','%20'),'%22',allF);
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
            entries_per_KW(index_kw,round((val_year))-1966) = num_entries;
        end
end
       
%%
years         = str2num(cell2mat(years_tokens(1:2:end)));     
%allYears=str2num(cell2mat(years_tokens(1:2:end)));
entries_per_KW_rel = entries_per_KW(1:numKeywords-1,:)./(1+repmat(entries_per_KW(numKeywords,:),[numKeywords-1 1]));

%%
numYears        = numel(years);
initialYear     = 10;
h0              = figure(1);
h1              = gca;
h11             = ribbon(entries_per_KW_rel');
h1.YTick        = (3:5:numYears);
h1.YTickLabel   = years(3:5:end);
h1.YLim         = [initialYear numYears+1];
h1.XTick        = (1:numKeywords);
h1.XTickLabel   = keywords;
h1.XLim         = [1 numKeywords];
h1.ZLim         = [0 max(max(entries_per_KW_rel(initialYear:end,:)))];
h1.XTickLabelRotation=270;
h1.View         = [ 170.3979   32.7538];
h1.FontSize     = 10;

h1.ZLabel.String='Rel. num. entries';
h1.ZLabel.FontSize=16;
h1.YLabel.String='Years';
h1.YLabel.FontSize=16;
h0.Position = [100  100  700  410];
%%
h1.Position     = [ 0.11    0.45    0.8605    0.5261];
h1.FontName='Arial';
filename = 'Fig_B_TrendsTechniquesYears.png';
print('-dpng','-r400',filename)
%%
h1.XTickLabelRotation=0;
h1.View = [   93.9019   51.0676];
h1.Position     = [ 0.11    0.15    0.6605    0.9961];
h1.FontSize     = 9;
h1.ZLabel.FontSize=16;

h1.YLabel.FontSize=16;

filename = 'Fig_C_TrendsTechniquesYears.png';
print('-dpng','-r400',filename)

%% 
colormap1 = bone;
%colormap1 =[linspace(0,1,32)'];
%colormap1(end,3)=0;
colormap1(:,3)=1;
colormap2 = colormap1(end:-1:1,[3 2 1]);
colormap3 = [colormap1;colormap2];
colormap (colormap3)

%%
h2=figure(2);
h20=gca;

allEntries_KW = sum(entries_per_KW(1:end-1,:),2);
[entries_all,index_all]=sort(allEntries_KW,'descend');
h21=bar(allEntries_KW(index_all));
h20.XTick=1:numKeywords-1;
h20.XTickLabel=keywords(index_all);
h20.XTickLabelRotation=270;
h20.FontSize = 11;
h20.YLabel.FontSize=16;
h20.YLabel.String='Num. entries';
h2.Position = [100  100  700  410];
h20.Position     = [ 0.1    0.49    0.89   0.48];
h20.FontName='Arial';
%%
filename = 'Fig_A_TrendsTechniques.png';
print('-dpng','-r400',filename)