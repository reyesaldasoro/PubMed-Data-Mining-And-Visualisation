
%% Text mining of PubMed for Cancer: Investigation of a series of keywords that define entries in 2016
% Ratios of the Cancer entries related to other extra keywords. The keywords have
% been chosen from a range of MESH terms from MedLine
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

allF                        = '%5BAll+Fields%5D'; % all fields code
basicURL                    = 'https://www.ncbi.nlm.nih.gov/pubmed/?term=';
yearURL                     =  strcat('%22',num2str(2016),'%22%5BDP%5D+');
   
CancerEntriesURL            =  strcat('AND(',  '%22neoplasms%22',allF,'OR','%22cancer%22',allF,'OR','%22tumor%22',allF,'OR','%22tumour%22',allF,'OR','%22oncology%22',allF,  ')');
NoCancerEntriesURL          =  strcat('NOT(',  '%22neoplasms%22',allF,'OR','%22cancer%22',allF,'OR','%22tumor%22',allF,'OR','%22tumour%22',allF,'OR','%22oncology%22',allF,  ')');

ExtraTerminology            ={  'Adrenal', ...
                                'Alcohol', ...
                                'Allergy',...
                                'Aggression', ...
                                'Alzheimer''s', ...
                                'Antigen', ...
                                'Behavior', ...
                                'Chemistry',...
                                'Dementia', ...
                                'Enzyme', ...
                                'Epidemiology',...
                                'Epilepsy', ...
                                'Fracture', ...
                                'Fungal', ...
                                'Geriatric', ...
                                'Glaucoma', ...
                                'Hepatitis', ...
                                'Hormone',...
                                'Inheritance', ...
                                'Injections', ...
                                'Insurance', ...
                                'Labor', ...
                                'Lactose', ...
                                'Leprosy', ...
                                'Life Expectancy', ...
                                'Lupus', ...
                                'Macular Degeneration', ...
                                'Magnetic Resonance', ...
                                'Microscopy', ...
                                'Mitochondrial',...
                                'Morgue', ...
                                'Neurology',...
                                'Nutrition', ...
                                'Nursing', ...
                                'Osteoporosis', ...
                                'Parasitic', ...
                                'Pain',...
                                'PCR',...
                                'Plaque',...
                                'Poisoning', ...
                                'Polymers',...
                                'Phobia', ...
                                'Therapy', ...
                                'Tomography',...
                                'Toxins',...
                                'Vasectomy',...
                                'Vitamin',...
                                'Wound healing',...
                                };

%%
numberTerms = size(ExtraTerminology,2);

for counterYear =1:numberTerms
  
    % This is the code to select one year in PubMed
   
    disp([counterYear])    

    % This is the code to select ALL cancer entries combined with year
    urlAddress                          = strcat(basicURL,yearURL,NoCancerEntriesURL,'AND%22',ExtraTerminology{counterYear},'%22',allF);
    PubMedURL                           = urlread(urlAddress);
    % Find the field "Count"
    locCount_init                       = strfind(PubMedURL,'count" content="');
    locCount_fin                        = strfind(PubMedURL(locCount_init+16:locCount_init+300),'"');
    numEntriesPubMed                    = (PubMedURL(locCount_init+16:locCount_init+16+locCount_fin(1)-2));
    Entries_PerTerminology(counterYear) = str2double(numEntriesPubMed);
end

%%

 urlAddress                          = strcat(basicURL,yearURL);
    PubMedURL                           = urlread(urlAddress);
    % Find the field "Count"
    locCount_init                       = strfind(PubMedURL,'count" content="');
    locCount_fin                        = strfind(PubMedURL(locCount_init+16:locCount_init+300),'"');
    numEntriesPubMed                    = (PubMedURL(locCount_init+16:locCount_init+16+locCount_fin(1)-2));
    Entries_PerTerminology(numberTerms+1) = str2double(numEntriesPubMed);

    
%% concatenation of results

for counterYear =1:numberTerms
    resultsTerminology{counterYear,1} = strcat(ExtraTerminology{counterYear},' (',num2str(round(10000*Entries_PerTerminology(counterYear)/Entries_PerTerminology(numberTerms+1))/100),'%)');
end
    
    
