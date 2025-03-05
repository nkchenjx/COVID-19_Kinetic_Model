clear;
load('data_SIRV.mat');

R_maxAllowed = 30;


data = [];

figure; hold on;
for c = [128, 129, 242, 97] %1:length(country)

    Rt = country(c).SIRV.Rt;
    t = 1:length(Rt);
    RE = country(c).SIRV.RE;
    S = country(c).SIRV.S;
    I = country(c).SIRV.I;
    R = country(c).SIRV.R;
    V = country(c).SIRV.V;
    

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

    Rt(Rt<0) = 0;
    RE(RE<0) = 0;
    Rt(Rt>R_maxAllowed) = R_maxAllowed; % remove the large value on the last dates that have no data
    RE(RE>R_maxAllowed) = R_maxAllowed; % remove the large value on the last dates that have no data

    % figure; hold on;
    plot(t, Rt); title('income low to high upside')
 %   plot(t, RE); plot(t, rr); plot(t, stringencyi); title(['Rt, Re, rr, stringency ', country(c).country]);

    % figure; hold on;
    % plot(t, S); plot(t, I); plot(t, R); plot(V); plot(S+I+R+V); title('S, I, R, V, sum');
    % 
    % 
    % figure; hold on;
    % plot(t, ndspm); plot(t, whapm); plot(t, ntspm); title('nds, wha, nts pm');
    % 
    % figure; 
    % plot(t, emcpm); title('cummulated excess death')
    data = [data,Rt(1:1600,1)];

    fprintf('.')
end
fprintf('\n');