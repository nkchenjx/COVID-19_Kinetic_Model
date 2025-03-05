figure; hold on
c = 1; % show a example country
t = 1:length(country1_2(c).SIRVB.Rt);
t = t(:);
yfit = mdl(country1_2(c).SIRVB.parafinal, t);
plot(country1_2(c).SIRVB.Rt);
plot(yfit);

t = 1:length(country1_2(c).SIRVB2.Rt);
t = t(:);
yfit = mdl(country1_2(c).SIRVB2.parafinal, t);
plot(country1_2(c).SIRVB2.Rt);
plot(yfit); title(['Rt & Rt_corrected', country1_2(c).country]);


jcPlotStyle; xlim([0,1700]);
figure; plot(country1_2(c).stringency_index);
jcPlotStyle; xlim([0,1700]);
title(['stringency ', country1_2(c).country]);


figure; hold on;
S = country1_2(c).SIRVB.S;
I = country1_2(c).SIRVB.I;
R = country1_2(c).SIRVB.R;
V = country1_2(c).SIRVB.V;
plot(S);
plot(I);
plot(cumsum(I)*gamma0);
plot(R);
plot(V);
plot(S+I+R+V);
jcPlotStyle; xlim([0,1700]);
title(['SIRVB: S, I, cumuI*gamma, R, V, S+I+R+V, ', country1_2(c).country]);


figure; hold on;
S = country1_2(c).SIRVB2.S;
I = country1_2(c).SIRVB2.I;
R = country1_2(c).SIRVB2.R;
V = country1_2(c).SIRVB2.V;
plot(S);
plot(I);
plot(cumsum(I)*gamma0);
plot(R);
plot(V);
plot(S+I+R+V);
jcPlotStyle; xlim([0,1700]);
title(['SIRVB_C: S, I, cumuI*gamma, R, V, S+I+R+V, ', country1_2(c).country]);


figure; plot(country1_2(c).ncspm);title('n'); % I ~= n/gamma. 
%hold on; plot(country1_2(c).SIRVB2.I*gamma0);
jcPlotStyle; xlim([0,1700]);


maxIm1 = [];
maxIm2 = [];
maxI1 = [];
maxI2 = [];
maxV1 = [];
maxV2 = [];
for c = 1:length(country1_2)
    Icumu = cumsum(country1_2(c).ncspm);
    Vcumu = country1_2(c).pfvpm;
    Im = Icumu*option.gamma0 + Vcumu;
    country1_2(c).Immune = Im;
    country1_2(c).maxIm = Im(end);
    maxI1(c) = Icumu(end)*option.gamma0;
    maxV1(c) = Vcumu(end);
    maxIm1(c) = Im(end);
end

for c = 1:length(country2)
    Icumu = cumsum(country2(c).ncspm);
    Vcumu = country2(c).pfvpm;
    Im = Icumu*option.gamma0 + Vcumu;
    country2(c).Immune = Im;
    country2(c).maxIm = Im(end);
    maxI2(c) = Icumu(end)*option.gamma0;
    maxV2(c) = Vcumu(end);
    maxIm2(c) = Im(end);
end

M = 10:10:140;
figure; hist(maxI1/1E4, M); xlim([0,140]);
figure; hist(maxV1/1E4, M); xlim([0,140]);
figure; hist(maxIm1/1E4, M);xlim([0,140]);

figure; hist(maxI2/1E4, M); xlim([0,140]);
figure; hist(maxV2/1E4, M); xlim([0,140]);
figure; hist(maxIm2/1E4, M);xlim([0,140]);


save('data_group1_and_2.mat','country1_2', 'country2', 'option');