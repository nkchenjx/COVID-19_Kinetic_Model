clear;
load('data_group1_and_2_final.mat');
%% read democracy index
DI = readtable('electoral-democracy-index.csv');

% find index of countries
iso_code = {};
iso = string(table2cell(DI(1,"Code")));
iso_code.iso(1) = iso;
iso_code.start(1) = 1;
iso_code.last(1) = 1;

for i = 1:size(DI,1)
    iso = string(table2cell(DI(i,"Code")));
    iso_code1 = iso_code.iso;
    index = find(ismember(iso_code1, iso));
    if ~any(index)
        iso_code.iso(end+1, 1) = iso;
        iso_code.start(end+1, 1) = i;
        iso_code.last(end+1, 1) = i;
    else
        iso_code.last(end, 1) = i;
    end
end

% add location information
for i = 1: length(iso_code.iso)
    iso_code.country(i,1) = string(table2cell(DI(iso_code.start(i),"Entity")));
end


countryDI = {};
for i = 1:length(iso_code.iso)
    s = iso_code.start(i);
    l = iso_code.last(i);
    countryDI(i).iso = iso_code.iso(i);
    countryDI(i).country = iso_code.country(i);
    countryDI(i).Year = string(table2cell(DI(s:l,"Year")));
    countryDI(i).EDI = cell2mat(table2cell(DI(s:l,"ElectoralDemocracyIndex_bestEstimate_Aggregate_Average_")));
  end

for c = 1:length(country1_2)
    ind = find(iso_code1==country1_2(c).iso);
    if ~isempty(ind)
        country1_2(c).Year_EDI = str2double([countryDI(ind).Year, countryDI(ind).EDI]);
    else
        country1_2(c).Year_EDI = [NaN, NaN];
    end
end

for c = 1:length(country2)
    ind = find(iso_code1==country2(c).iso);
    if ~isempty(ind)
        country2(c).Year_EDI = str2double([countryDI(ind).Year, countryDI(ind).EDI]);
    else
        country2(c).Year_EDI = [NaN, NaN];
    end
end


%% calcuate some correlatins
data1 = [];
for c = 1:length(country1_2)
    data1(c).iso = country1_2(c).iso;
    data1(c).continent = country1_2(c).continent;
    data1(c).country = country1_2(c).country;
    data1(c).t4 = country1_2(c).SIRVB2.parafinal(4);
    data1(c).maxV = country1_2(c).pfvpm(end)/1E4;
    data1(c).human_development_index = country1_2(c).human_development_index;
    data1(c).life_expectancy = country1_2(c).life_expectancy;
    data1(c).median_age = country1_2(c).median_age;
    data1(c).handwashing_facilities = country1_2(c).handwashing_facilities;
    data1(c).gdp_per_capita = country1_2(c).gdp_per_capita;
    data1(c).election_democracy_index = country1_2(c).Year_EDI(end,2);
    data1(c).population_density = country1_2(c).population_density;
end
data2 = [];
for c = 1:length(country2)
    data2(c).iso = country2(c).iso;
    data2(c).continent = country2(c).continent;
    data2(c).country = country2(c).country;
    data2(c).t4 = country2(c).SIRVB.parafinal(4);
    data2(c).maxV = country2(c).pfvpm(end)/1E4;
    data2(c).human_development_index = country2(c).human_development_index;
    data2(c).life_expectancy = country2(c).life_expectancy;
    data2(c).median_age = country2(c).median_age;
    data2(c).handwashing_facilities = country2(c).handwashing_facilities;
    data2(c).gdp_per_capita = country2(c).gdp_per_capita;
    data2(c).election_democracy_index = country2(c).Year_EDI(end,2);
    data2(c).population_density = country2(c).population_density;
end

d1 = struct2table(data1);
d1 = table2array(d1(:,4:end));
for i = 1:size(d1,2)
    dtemp = d1(:,i);

    dtemp(isnan(dtemp)) = 0;
    dtemp(dtemp==0) = mean(dtemp);
    d1(:,i) = dtemp;
end

d2 = struct2table(data2);
d2 = table2array(d2(:,4:end));
for i = 1:size(d2,2)
    dtemp = d2(:,i);
    dtemp(isnan(dtemp)) = 0;
    dtemp(dtemp==0) = mean(dtemp);
    d2(:,i) = dtemp;
end

correlation1 = corrcoef(d1);
figure; imagesc(correlation1); 
colormap jet;  
clim([-1,1]); title('rough check group 1');

correlation2 = corrcoef(d2);
figure; imagesc(correlation2); 
colormap jet;  
clim([-1,1]); title('rough check group 2');


ds = [d1;d2];
correlation3 = corrcoef(ds);
figure; imagesc(correlation3); 
colormap jet;  
clim([-1,1]); 
colorbar; title('rough check all');


% %% draw some correlation maps
% figure; scatter(d1(:,1), d1(:,2),'Color','Blue');
% hold on; scatter(d2(:,1), d2(:,2), 'Color', 'Red');
% jcPlotStyle; title('Vaccination rate vs t4');
% 
% figure; scatter(d1(:,1), d1(:,3),'Color','Blue');
% hold on; scatter(d2(:,1), d2(:,3), 'Color', 'Red');
% jcPlotStyle; title('Development index vs t4');
% 
% figure; scatter(d1(:,1), d1(:,4),'Color','Blue');
% hold on; scatter(d2(:,1), d2(:,4), 'Color', 'Red');
% jcPlotStyle; title('life expency vs t4');
% 
% figure; scatter(d1(:,1), d1(:,5),'Color','Blue');
% hold on; scatter(d2(:,1), d2(:,5), 'Color', 'Red');
% jcPlotStyle; title('GDP per Capita vs t4');
% 
% figure; scatter(d1(:,1), d1(:,6),'Color','Blue');
% hold on; scatter(d2(:,1), d2(:,6), 'Color', 'Red');
% jcPlotStyle; title('Median age vs t4');
% 
% figure; scatter(d1(:,1), d1(:,7),'Color','Blue');
% hold on; scatter(d2(:,1), d2(:,7), 'Color', 'Red');
% jcPlotStyle; title('population density vs t4');
% 
% figure; scatter(d1(:,1), d1(:,8),'Color','Blue');
% hold on; scatter(d2(:,1), d2(:,8), 'Color', 'Red');
% jcPlotStyle; title('Democracy index vs t4');
% 
% figure; scatter(d1(:,1), d1(:,9),'Color','Blue');
% hold on; scatter(d2(:,1), d2(:,9), 'Color', 'Red');
% jcPlotStyle; title('Handwashing facility vs t4');


%% re-analyze every correlation by deleting missing data instead of assigning average.
d1 = struct2table(data1);
d2 = struct2table(data2);
d1 = table2array(d1(:,4:end));
d2 = table2array(d2(:,4:end));
correlationf = [];

for i = 1:size(d1,2)
    d12_1 = d1(:, [1,i]);
    d12_2 = d2(:, [1,i]);   
    
    d12_1(isnan(d12_1(:,2)),:) = [];
    d12_2(isnan(d12_2(:,2)),:) = [];
    d12_3 = [d12_1; d12_2];
 
    correlation12_1 = corrcoef(d12_1);
    correlation12_2 = corrcoef(d12_2);
    correlation12_3 = corrcoef(d12_3);
    correlationf(1, i) = correlation12_1(1,2);
    correlationf(2, i) = correlation12_2(1,2);
    correlationf(3, i) = correlation12_3(1,2);

    figure; scatter(d12_1(:,1), d12_1(:,2),'Color','Blue');
    title(['t4 vs #', num2str(i)]); xlim([0,1500]); jcPlotStyle;

    figure; scatter(d12_2(:,1), d12_2(:,2), 'Color', 'Red');
    title(['t4 vs #', num2str(i)]); xlim([0,1500]); jcPlotStyle; 

end

figure; imagesc(correlationf);
colormap jet;  
clim([-1,1]); 
colorbar; title('final correlations group 1, group 2, and all');