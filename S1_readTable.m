RawData = readtable('owid-covid-data_20240725.csv'); % On 20240725, downloaded from https://ourworldindata.org/coronavirus

% find index of countries
iso_code = {};
iso = string(table2cell(RawData(1,"iso_code")));
iso_code.iso(1) = iso;
iso_code.start(1) = 1;
iso_code.last(1) = 1;

for i = 1:size(RawData,1)
    iso = string(table2cell(RawData(i,"iso_code")));
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
    iso_code.continent(i,1) = string(table2cell(RawData(iso_code.start(i),"continent")));
    iso_code.country(i,1) = string(table2cell(RawData(iso_code.start(i),"location")));
end


%% split table into sub tables for each country or area

% date = string(table2cell(RawData(:,"date")));
% ncspm = table2cell(RawData(:,"new_cases_smoothed_per_million"));
% pfvph = table2cell(RawData(:,"people_fully_vaccinated_per_hundred"));
% 
% ncspm = cell2mat(ncspm);
% pfvph = cell2mat(pfvph);

country = {};
for i = 1:length(iso_code.iso)
    s = iso_code.start(i);
    l = iso_code.last(i);
    country(i).iso = iso_code.iso(i);
    country(i).continent = iso_code.continent(i);
    country(i).country = iso_code.country(i);
    country(i).date = string(table2cell(RawData(s:l,"date")));
    country(i).ncspm = cell2mat(table2cell(RawData(s:l,"new_cases_smoothed_per_million")));
    pfvph = cell2mat(table2cell(RawData(s:l,"people_fully_vaccinated_per_hundred")));
    if any([5,67,78,89,90,138,139,142,144,168,173,183,185,189,193,194,220,241,246] == i)
        pfvph = cell2mat(table2cell(RawData(s:l,"people_vaccinated_per_hundred")));
    end
    country(i).pfvph = pfvph; % a few countries has no full vph data, then try vph instead and some both none.
    country(i).rr = cell2mat(table2cell(RawData(s:l,"reproduction_rate")));
    country(i).new_deaths_smoothed_per_million = cell2mat(table2cell(RawData(s:l,"new_deaths_smoothed_per_million")));
    country(i).weekly_hosp_admissions_per_million = cell2mat(table2cell(RawData(s:l,"weekly_hosp_admissions_per_million")));
    country(i).new_tests_smoothed_per_thousand = cell2mat(table2cell(RawData(s:l,"new_tests_smoothed_per_thousand")));
    country(i).stringency_index = cell2mat(table2cell(RawData(s:l,"stringency_index")));
    country(i).excess_mortality_cumulative_per_million = cell2mat(table2cell(RawData(s:l,"excess_mortality_cumulative_per_million")));

    country(i).population_density = cell2mat(table2cell(RawData(s,"population_density")));
    country(i).median_age = cell2mat(table2cell(RawData(s,"median_age")));
    country(i).gdp_per_capita = cell2mat(table2cell(RawData(s,"gdp_per_capita")));
    country(i).cardiovasc_death_rate = cell2mat(table2cell(RawData(s,"cardiovasc_death_rate")));
    country(i).diabetes_prevalence = cell2mat(table2cell(RawData(s,"diabetes_prevalence")));
    country(i).handwashing_facilities = cell2mat(table2cell(RawData(s,"handwashing_facilities")));
    country(i).hospital_beds_per_thousand = cell2mat(table2cell(RawData(s,"hospital_beds_per_thousand")));
    country(i).life_expectancy = cell2mat(table2cell(RawData(s,"life_expectancy")));
    country(i).human_development_index = cell2mat(table2cell(RawData(s,"human_development_index")));
    country(i).population = cell2mat(table2cell(RawData(s,"population")));

end

save('rawdata.mat', 'country');

