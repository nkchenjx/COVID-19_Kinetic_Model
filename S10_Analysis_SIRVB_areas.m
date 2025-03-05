%
% analyzie countries
clear;
load('data_SIRVB.mat');
% Rt_maxAllowed = 20;
movemedianWindow = 10;

listOfAreas = [2, 13, 71, 72, 97, 128, 129, 163, 170, 212, 242, 251];
areaIndex = {};
for i = 1:length(listOfAreas)
    areaIndex(i,1) = {listOfAreas(i)};
    areaIndex(i,2) = {country(listOfAreas(i)).country};
end    
listOfCountries = 1:length(country);
listOfCountries(listOfAreas) = [];


%% Rt vs incomes
CountryIncomeGroup = country([128, 129, 242, 97]);

data1 = [];
figure; hold on;
for c = [128, 129, 242, 97] %1:length(country)

    Rt = country(c).SIRVB.Rt;
%    Rt = smoothdataMedian(Rt, 10);
    Rt = smoothdata(Rt,'movmedian', movemedianWindow);
    t = 1:length(Rt);
    RE = country(c).SIRVB.RE;
%    RE = smoothdataMedian(RE, 10);
    RE = smoothdata(RE,'movmedian', movemedianWindow);
    S = country(c).SIRVB.S;
    I = country(c).SIRVB.I;
    R = country(c).SIRVB.R;
    V = country(c).SIRVB.V;
    

    rr = country(c).rr;
    pfvpm = country(c).pfvpm;
    ndspm = country(c).new_deaths_smoothed_per_million;
    ndspm(isnan(ndspm)) = 0;
    whapm = country(c).weekly_hosp_admissions_per_million;
    whapm(isnan(whapm)) = 0;
    ntspm = country(c).new_tests_smoothed_per_thousand * 1E3;
    ntspm(isnan(ntspm)) = 0;
    stringencyi = country(c).stringency_index/100;
    stringencyi(isnan(stringencyi)) = 0;
    emcpm = country(c).excess_mortality_cumulative_per_million;
    emcpm(1) = 0;
    for i = 2:length(emcpm)
        if isnan(emcpm(i))
            emcpm(i) = emcpm(i-1);
        end
    end
    
    % if sum(rr) == 0
    %     Rt = Rt*0;
    %     RE = RE*0;
    % end

    % Rt(Rt<0) = 0;
    % RE(RE<0) = 0;
    % Rt(Rt>R_maxAllowed) = Rt_maxAllowed; % remove the large value on the last dates that have no data
    % RE(RE>R_maxAllowed) = Rt_maxAllowed; % remove the large value on the last dates that have no data

  %  figure; hold on;
    plot(t, Rt); title('SIRVB income low to high')
    Rt = Rt(:);
    data1 = [data1,Rt(1:1600)];
    % plot(t, RE); plot(t, rr); plot(t, stringencyi); title(['Rt, Re, rr, stringency ', country(c).country]);
    % 
    % figure; hold on;
    % plot(S); plot(I); plot(R); plot(V); plot(S+I+R+V); title('S, I, R, V, sum');
    % 
    % 
    % figure; hold on;
    % plot(t, ndspm); plot(t, whapm); plot(t, ntspm); title('nds, wha, nts pm');
    % 
    % figure; 
    % plot(t, emcpm); title('cummulated excess death')
    
    fprintf('.')
end
fprintf('\n');

%% area by continent 

data2 = [];
figure; hold on;
for c = [2, 13, 71, 163, 170, 212] %1:length(country)

    Rt = country(c).SIRVB.Rt;
%    Rt = smoothdataMedian(Rt, 10);
    Rt = smoothdata(Rt,'movmedian', movemedianWindow);
    t = 1:length(Rt);
    RE = country(c).SIRVB.RE;
%    RE = smoothdataMedian(RE, 10);
    RE = smoothdata(RE,'movmedian', movemedianWindow);
    S = country(c).SIRVB.S;
    I = country(c).SIRVB.I;
    R = country(c).SIRVB.R;
    V = country(c).SIRVB.V;
    

    rr = country(c).rr;
    pfvpm = country(c).pfvpm;
    ndspm = country(c).new_deaths_smoothed_per_million;
    ndspm(isnan(ndspm)) = 0;
    whapm = country(c).weekly_hosp_admissions_per_million;
    whapm(isnan(whapm)) = 0;
    ntspm = country(c).new_tests_smoothed_per_thousand * 1E3;
    ntspm(isnan(ntspm)) = 0;
    stringencyi = country(c).stringency_index/100;
    stringencyi(isnan(stringencyi)) = 0;
    emcpm = country(c).excess_mortality_cumulative_per_million;
    emcpm(1) = 0;
    for i = 2:length(emcpm)
        if isnan(emcpm(i))
            emcpm(i) = emcpm(i-1);
        end
    end
    
    % if sum(rr) == 0
    %     Rt = Rt*0;
    %     RE = RE*0;
    % end

    % Rt(Rt<0) = 0;
    % RE(RE<0) = 0;
    % Rt(Rt>R_maxAllowed) = Rt_maxAllowed; % remove the large value on the last dates that have no data
    % RE(RE>R_maxAllowed) = Rt_maxAllowed; % remove the large value on the last dates that have no data

  %  figure; hold on;
    plot(t, Rt); title('SIRVB continents')
    Rt = Rt(:);
    data2 = [data2,Rt(1:1600)];
    % plot(t, RE); plot(t, rr); plot(t, stringencyi); title(['Rt, Re, rr, stringency ', country(c).country]);
    % 
    % figure; hold on;
    % plot(S); plot(I); plot(R); plot(V); plot(S+I+R+V); title('S, I, R, V, sum');
    % 
    % 
    % figure; hold on;
    % plot(t, ndspm); plot(t, whapm); plot(t, ntspm); title('nds, wha, nts pm');
    % 
    % figure; 
    % plot(t, emcpm); title('cummulated excess death')
    
    fprintf('.')
end
fprintf('\n');