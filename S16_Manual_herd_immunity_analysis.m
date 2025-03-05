clear;
load('data_SRIVB_fit.mat');
% open up the Excel table and then do a manual check country by country to
% exclude and label data don't follow the pattern.

c = 6; % manually change this value from 1 to 254 and check the Rt shape and fitting % lable 0 for not follow the pattern and 1 for following the pattern
Rt = country(c).SIRVB.Rt; %77 France, 240 USA, world 251
L = length(Rt);
if L<1500
    Rt = Rt(:);
    Rt = [Rt;zeros(1500-L,1)];
end

t = 1:length(Rt);
t = t(:);
yfit = mdl(country(c).SIRVB.parafinal, t);
figure; plot(Rt);
hold on
plot(yfit); title(country(c).country);

