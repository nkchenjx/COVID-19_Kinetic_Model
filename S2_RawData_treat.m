load('rawdata.mat');

for c = 1:length(country)
    if country(c).iso ~= 'ESH' % exclude ESH that has no data
        country(c).ncspm(1) = 0;
        country(c).pfvph(1) = 0;
        country(c).rr(1) = 0;
        for d = 2:length(country(c).date)
            if isnan(country(c).ncspm(d))
                country(c).ncspm(d) = 0;
            end
            if isnan(country(c).pfvph(d))
                country(c).pfvph(d) = country(c).pfvph(d-1);
            elseif country(c).pfvph(d) == 0
                country(c).pfvph(d) = country(c).pfvph(d-1);
            end
            if isnan(country(c).rr(d))
                country(c).rr(d) = 0;
            end
        end
    end
    country(c).pfvpm = country(c).pfvph*1E4; % people fully vaccinated per million. 
end


%remove ESH which has no data
for c = 1:length(country)
    if strcmp(country(c).iso, 'ESH') % exclude ESH that has no data
        c0 = c;
    end
end
country(c0) = [];

save("data.mat");