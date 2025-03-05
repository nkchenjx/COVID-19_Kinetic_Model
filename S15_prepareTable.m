load('data_SRIVB_fit.mat');

fields = {'date', 'ncspm', 'pfvph','rr', 'new_deaths_smoothed_per_million','weekly_hosp_admissions_per_million',...
    'new_tests_smoothed_per_thousand', 'stringency_index', 'excess_mortality_cumulative_per_million', 'pfvpm', 'SIRB', 'SIRVB'};
data = rmfield(country, fields);

for c = 1:length(country)
    data(c).peakn = max(country(c).ncspm);
    data(c).maxV = max(country(c).pfvph);
    data(c).maxDeath = max(country(c).new_deaths_smoothed_per_million);
    data(c).maxWeeklyHosp = max(country(c).weekly_hosp_admissions_per_million);
    data(c).maxTest = max(country(c).new_tests_smoothed_per_thousand)*1E3;
    data(c).maxStringency = max(country(c).stringency_index);
    data(c).maxExcessDeath = max(country(c).excess_mortality_cumulative_per_million);
    data(c).para = country(c).SIRVB.parafinal;
    
end

writetable(struct2table(data), 'data_Summary.csv');
save('data_listOf_well_behaved_country.mat', 'data');