clear;
load 'data.mat';

% initialize parameters
gamma0 = 0.2;
N = 1E6; % population. use per million data
Rt_maxAllowed = 50; % remove larger R values caused by lack of data on later days
I_minAllowed = 1;
smoothGaussian = 10;

option.gamma0 = gamma0;
option.N = 1E6;
option.Rt_maxAllowed = Rt_maxAllowed;
option.I_minAllowed = I_minAllowed;
option.smoothGaussian = smoothGaussian;

%c = 227; 
for c = 1:length(country)

    nc = country(c).ncspm; %new case per million people
    nc = smoothdata(nc, 'gaussian', smoothGaussian);
    rr = country(c).rr; % reproduction rate calculate by Our World in Data.
    t = length(nc); % total days
    
    beta = [];
    Rt = [];
    RE = [];
    S = [];
    I = [];
    R = [];
    
    %initialize
    beta(1) = 0;
    gamma = [];
    gamma = ones(t,1)*gamma0;
    Rt(1) = 0;
    RE(1) = 0;
    S(1) = N;
    I(1) = 1;
    R(1) = 0;
    
    for i = 2:t
        beta(i) = nc(i)*N/S(i-1)/I(i-1);
        S(i) = S(i-1)- nc(i);
        I(i) = I(i-1)+ nc(i) - gamma(i-1)*I(i-1);
        R(i) = R(i-1)+gamma(i-1)*I(i-1);

        if I(i) < I_minAllowed
            I(i) = I_minAllowed;
        end

        %calculate R valuses
        Rt(i) = beta(i)/gamma(i);
        RE(i) = Rt(i)*S(i)/N;
        % OR
        % RE(i) = nc(i)/I(i)/gamma(i); 
    end
    
    % store
    Rt = Rt(:);
    RE = RE(:);
    country(c).SIR.Rt = Rt;
    country(c).SIR.RE = RE;
    country(c).SIR.S = S;
    country(c).SIR.I = I;
    country(c).SIR.R = R;
end

save('data_SIR.mat', 'country', 'option');

% show an example country
c = 240; % 240 USA, 251 world
Rt = country(c).SIR.Rt;
RE = country(c).SIR.RE;

Rt(Rt>Rt_maxAllowed) = Rt_maxAllowed; % remove the large values for display
RE(RE>Rt_maxAllowed) = Rt_maxAllowed; % remove the large values for display


rr = country(c).rr;
figure; plot(Rt); hold on;
plot(RE); plot(rr); title(['SIR example country ', country(c).country]);

figure; hold on;
S = country(c).SIR.S;
I = country(c).SIR.I;
R = country(c).SIR.R;
plot(S);
plot(cumsum(I)); % cummulative I is 5 times infected people because gamma = 1/5. Each person is counted five times/days.
plot(R);
plot(S+I+R);


