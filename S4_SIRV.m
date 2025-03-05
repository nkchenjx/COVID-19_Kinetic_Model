clear;
load("data_SIR.mat");

% gamma0 = option.gamma0;
% N = option.N; % population. use per million data so N = 1E6.
% R_maxAllowed = option.R_maxAllowed;
gamma0 = 0.2;
N = 1E6;
Rt_maxAllowed = 50;
I_minAllowed = 1;
S_minAllowed = 1;
smoothGaussian = 10;



for c = 1:length(country)

    nc = country(c).ncspm; %new case per million people
    % Gaussian smooth in 7 days
    nc = smoothdata(nc, 'gaussian', smoothGaussian);

    rr = country(c).rr; % reproduction rate calculate by Our World in Data.
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
        vd(i) = V2(i)-V2(i-1); % vd = S*vr
    end
    
    
    for i = 2:t

        beta2(i) = nc(i)*N/S2(i-1)/I2(i-1);
        % S2(i) = S2(i-1)-nc(i-1)-vd(i)*S2(i-1)/N;
        S2(i) = S2(i-1)-nc(i)-vd(i);
        if(S2(i)) < S_minAllowed % avoid too large beta due to no susceptable population.
            S2(i) = S_minAllowed; % set to 1 to avoid singlularity at 0 
        end
        I2(i) = I2(i-1)+ nc(i) - gamma2(i-1)*I2(i-1);
        % R2(i) = R2(i-1)+gamma2(i)*I2(i-1) + vd(i)*S2(i-1)/N;
        R2(i) = R2(i-1)+gamma2(i-1)*I2(i-1);
        if(R2(i))> N-V2(i) % simplify overlap of infected and vaccinated to if sum >N set to N.
             R2(i) = N-V2(i);
        end
        if I2(i) < I_minAllowed % avoid too large beta due to no infected population.
            I2(i) = I_minAllowed;
        end

        %caluclate R values
        Rt2(i) = beta2(i)/gamma2(i);
        RE2(i) = Rt2(i)*S2(i)/N;
        % OR
        % RE2(i) = nc(i)/I2(i)/gamma2(i); 
    end

   
     % store
    Rt2 = Rt2(:);
    RE2 = RE2(:);
   
    country(c).SIRV.Rt = Rt2;
    country(c).SIRV.RE = RE2;
    country(c).SIRV.S = S2(:);
    country(c).SIRV.I = I2(:);
    country(c).SIRV.R = R2(:);
    country(c).SIRV.V = V2(:);
end


save('data_SIRV.mat', 'country', 'option');

% show an example country
c = 251; % usa 240 world 251
Rt2 = country(c).SIRV.Rt;
RE2 = country(c).SIRV.RE;

Rt2(Rt2>Rt_maxAllowed) = Rt_maxAllowed; % remove the large value on the last dates that have no data
RE2(RE2>Rt_maxAllowed) = Rt_maxAllowed; % remove the large value on the last dates that have no data
Rt2(Rt2<0) = 0;
RE2(RE2<0) = 0;

rr = country(c).rr;
figure; plot(Rt2); hold on;
plot(RE2); plot(rr); title(['SIRV example country ', country(c).country]);
figure; plot(cumsum(country(c).SIRV.I)); hold on; plot(country(c).SIRV.S); plot(country(c).SIRV.R); plot(country(c).SIRV.V);