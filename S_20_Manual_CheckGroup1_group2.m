clear;
load('data_group1_and_2.mat');

c = 37;  % show a example country. Manually change to theck each country manually and lable those still do not follow the pattern.

%% show a country in group 2
figure; hold on
t = 1:length(country2(c).SIRVB.Rt);
t = t(:);
yfit = mdl(country2(c).SIRVB.parafinal, t);
plot(country2(c).SIRVB.Rt);
plot(yfit);

title(['Rt group 2', country2(c).country]);

%
%% a country in group 1
figure; hold on

t = 1:length(country1_2(c).SIRVB.Rt);
t = t(:);
yfit = mdl(country1_2(c).SIRVB.parafinal, t);
plot(country1_2(c).SIRVB.Rt);
plot(yfit);

t = 1:length(country1_2(c).SIRVB2.Rt);
t = t(:);
yfit = mdl(country1_2(c).SIRVB2.parafinal, t);
plot(country1_2(c).SIRVB2.Rt);
plot(yfit,'color','black'); title(['Rt & Rt_corrected Group 1', country1_2(c).country]);


% jcPlotStyle; xlim([0,1700]);
% figure; plot(country1_2(c).stringency_index);
% jcPlotStyle; xlim([0,1700]);
% title(['stringency ', country1_2(c).country]);



G1_remove = [79, 55, 51, 23, 21];
G2_remove = [82];

country1_2(G1_remove) = [];
country2(G2_remove) = [];

save('data_group1_and_2_final.mat', 'country1_2', 'country2', "option");