clear;
load('data_SIRVB.mat');

listOfAreas = [2, 13, 71, 72, 97, 128, 129, 163, 170, 212, 242, 251];
areaIndex = {};
for i = 1:length(listOfAreas)
    areaIndex(i,1) = {listOfAreas(i)};
    areaIndex(i,2) = {country(listOfAreas(i)).country};
end    
listOfCountries = 1:length(country);
listOfCountries(listOfAreas) = [];


c = 77; %world 251, usa 240, France 77, Japan 111,  
ct = country(c);
figure; plot(ct.ncspm, 'LineWidth', 2); xlim([1,1700]); jcPlotStyle; title(['new case n of ', ct.country]);
figure; plot(ct.SIRVB.V, 'LineWidth', 2); xlim([1,1700]); jcPlotStyle; title(['Fully vaccinated ', ct.country]);
figure; plot(ct.SIRVB.Rt, 'LineWidth', 2); xlim([1,1700]);  jcPlotStyle; title(['Rt b = 0.2 of ', ct.country]);
figure; plot(ct.stringency_index, 'LineWidth', 2); xlim([1,1700]); jcPlotStyle; title(['stringency ', ct.country])
figure; plot(ct.SIRVB.V);

emcpm = ct.excess_mortality_cumulative_per_million;
emcpm(1) = 0;
for i = 2:length(emcpm)
    if isnan(emcpm(i))
        emcpm(i) = emcpm(i-1);
    end
end
figure; plot(emcpm, 'LineWidth', 2); xlim([1,1700]); jcPlotStyle; title(['excess morality ', ct.country])


data = [ct.SIRVB.Rt,...%1 Rt
    ct.ncspm,... %2 new case
    ct.pfvpm,... %3 vacciation
    ct.pfvpm,... %4 new V later
    ct.new_deaths_smoothed_per_million,... %5 new death
    ct.weekly_hosp_admissions_per_million,... %6 weekly hospital    
    ct.new_tests_smoothed_per_thousand,... %7 new test
    ct.stringency_index,... %8 % change to social intensity/frequency/temperautre later
    ct.excess_mortality_cumulative_per_million... %9 change to daily excess mortality later
    ]; 

for j = 1:size(data, 2)
    data(1,j) = 0;
    for i = 2:size(data,1)
        if isnan(data(i,j))
            data(i,j) = data(i-1,j);
        end
    end
end

data2 = data;
data2(1,8) = 100 - data(1,8); % stringency changed to social activity intensity
for i = 2:size(data,1)
    data2(i,4) = data(i,4) - data(i-1,4); % vaccination per day %3
    data2(i,8) = 100 - data(i,8); %7 changed to social activity intensity
    data2(i,9) = data(i,9) - data(i-1,9); % excess mortality per day %8
end

data2(:,4) = smoothdata(data2(:,4),'movmean', 7);
data2(:,9) = smoothdata(data2(:,9),'movmean', 7);

data2 = data2(1:1200,:);


correlation = corrcoef(data2);
figure; imagesc(correlation); 
colormap jet;  
clim([-1,1]); 


figure; plot(ct.new_deaths_smoothed_per_million);
hold on; plot(data2(:,8));