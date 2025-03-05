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



RtA = zeros(1600,1);
figure; hold on
for c = 1:length(country)
    Rt = country(c).SIRVB.Rt;
    %Rt(Rt>Rt_maxAllowed) = Rt_maxAllowed;
    Rt = smoothdata(Rt,'movmedian', movemedianWindow);
    %Rt = smoothdata(Rt,'gaussian', 30);
    
    L = length(Rt);
    if L>=1600
            RtA = RtA + Rt(1:1600);
    else
            RtA(1:L) = RtA(1:L) + Rt;
    end
    plot(Rt);
end

figure; plot(RtA/length(country));




