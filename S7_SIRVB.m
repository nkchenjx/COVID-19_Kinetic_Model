clear;
load("data_SIRB.mat");

N = 1E6; % total population, use per million data so total is 1 million.
gamma0 = 0.2; % recover/quarantine rate
b = 0.20; % average breakthrough rate on R+V

Rt_maxAllowed = 50;
I_minAllowed = 1;
S_minAllowed = 1;
smoothWindow = 20;



for c = 1:length(country)
    nc = country(c).ncspm; %new case per million people raw data from Our World in Data.
    nc = smoothdata(nc, 'gaussian', smoothWindow); % Gaussian smooth
    rr = country(c).rr; % reproduction rate calculated by Our World in Data.
    V2 = country(c).pfvpm; % fully vaccinated people per million population.
    t = length(nc); % total days
    
    beta2 = [];
    Rt2 = [];
    RE2 = [];
    S2 = [];
    I2 = [];
    R2 = [];
    
    %initialize
    beta2(1) = 0;
    gamma2 = ones(t,1)*gamma0;
    Rt2(1) = 0;
    RE2(1) = 0;
    S2(1) = N;
    I2(1) = 1;
    R2(1) = 0;
    vd(1) = 0;
    for i = 2:t
        vd(i) = V2(i)-V2(i-1);
    end
    
    
    for i = 2:t
        beta2(i) = nc(i)*N/( S2(i-1) + (R2(i-1)+V2(i-1))*b )/I2(i-1);
        S2(i) = S2(i-1)-nc(i)-vd(i);
        if(S2(i)) < S_minAllowed % avoid unreasonably large beta due to no susceptable population.
            S2(i) = S_minAllowed; % set to 1 to avoid singularity at 0
        end

        I2(i) = I2(i-1) + nc(i) - gamma2(i-1)*I2(i-1);
        R2(i) = R2(i-1) + gamma2(i-1)*I2(i-1);

        if(R2(i))>(N-V2(i)-I2(i)-S2(i)) % simplify overlap of infected and vaccinated to if sum >N set to N.
             R2(i) = (N-V2(i)-I2(i)-S2(i));
        end
        if I2(i) < I_minAllowed % avoid unreasonably large beta due to no infected population.
            I2(i) = I_minAllowed;
        end

        % calculate reproduction numbers
        Rt2(i) = beta2(i)/gamma2(i);
        RE2(i) = nc(i)/I2(i)/gamma2(i); 
        % OR
        % RE2(i) = Rt2(i)*S2(i)/N;
    end
    
    % store
    country(c).SIRVB.Rt = Rt2(:);
    country(c).SIRVB.RE = RE2(:);
    country(c).SIRVB.S = S2(:);
    country(c).SIRVB.I = I2(:);
    country(c).SIRVB.R = R2(:);
    country(c).SIRVB.V = V2(:);
end


save('data_SIRVB.mat', 'country', 'option');

% show an example country
c = 251; % USA 240, world 251
Rt2 = country(c).SIRVB.Rt;
RE2 = country(c).SIRVB.RE;

Rt2(Rt2>Rt_maxAllowed) = Rt_maxAllowed; % remove the large value on the last dates that have no data
RE2(RE2>Rt_maxAllowed) = Rt_maxAllowed; % remove the large value on the last dates that have no data
Rt2(Rt2<0) = 0;
RE2(RE2<0) = 0;

rr = country(c).rr;
figure; plot(Rt2); hold on;
plot(RE2); plot(rr); title(['SIRVB example country ', country(c).country]);

figure; hold on; plot(S2), plot(I2); plot(R2), plot(V2); plot(S2(:)+I2(:)+R2(:)+V2(:));