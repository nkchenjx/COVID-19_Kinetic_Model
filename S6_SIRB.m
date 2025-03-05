clear;
load 'data.mat';

% initialize parameters
gamma0 = 0.2;
N = 1E6; % population. use per million data
Rt_maxAllowed = 50; % remove larger R values caused by lack of data on later days
I_minAllowed = 1;
smoothGaussian = 10;
breakthroughR = 0.2;

option.gamma0 = gamma0;
option.N = 1E6;
option.Rt_maxAllowed = Rt_maxAllowed;
option.I_minAllowed = I_minAllowed;
option.smoothGaussian = smoothGaussian;
option.breakthroughR = breakthroughR;

%c = 227; 
for c = 1:length(country)

    nc = country(c).ncspm; %new case per million people
    nc = smoothdata(nc, 'gaussian', smoothGaussian);
    rr = country(c).rr; % reproduction rate calculated by Our World in Data.
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
        beta(i) = nc(i)*N/(S(i-1)+R(i-1)*breakthroughR)/I(i-1);
        S(i) = S(i-1)-nc(i);
        I(i) = I(i-1)+beta(i-1)/N*(S(i-1)+R(i-1)*breakthroughR)*I(i-1)-gamma(i-1)*I(i-1);
        R(i) = R(i-1)+gamma(i-1)*I(i-1);

        if I(i) < I_minAllowed
            I(i) = I_minAllowed;
        end
        
        % calculate R values
        Rt(i) = beta(i)/gamma(i);
        RE(i) = Rt(i)*(S(i)+R(i)*breakthroughR)/N;
    end
    
    % store
    Rt = Rt(:);
    RE = RE(:);
    country(c).SIRB.Rt = Rt;
    country(c).SIRB.RE = RE;
    country(c).SIRB.S = S(:);
    country(c).SIRB.I = I(:);
    country(c).SIRB.R = R(:);
end

save('data_SIRB.mat', 'country', 'option');


% show an example country
c = 251; % USA 240
Rt = country(c).SIRB.Rt;
RE = country(c).SIRB.RE;

Rt(Rt>Rt_maxAllowed) = Rt_maxAllowed; % remove the large values for display purpose
RE(RE>Rt_maxAllowed) = Rt_maxAllowed; % remove the large values for display purpose

rr = country(c).rr;
figure; plot(Rt); hold on;
plot(RE); plot(rr); title(['SIRB example country ', country(c).country]);


