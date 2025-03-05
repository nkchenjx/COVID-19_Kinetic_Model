%% simulating SIR with 0 v and fixed Rt = 3.0
clear all;
beta0 = 0.6;
gamma0 = 0.2;
N = 1E6;
I_minAllowed = 1;
S_minAllowed = 1;
R_maxAllowed = N;
t = 400;
%initialize
beta(1) = beta0;
gamma = [];
gamma = ones(t,1)*gamma0;
Rt(1) = beta0/gamma0;
RE(1) = beta0/gamma0;
S(1) = N;
I(1) = 1;
R(1) = 0;

for i = 2:t
    beta(i) = beta0;
    Rt(i) = beta(i-1)/gamma(i-1);
    RE(i) = Rt(i-1)*S(i-1)/N;
    S(i) = S(i-1) - beta(i-1)/N*S(i-1)*I(i-1);
    I(i) = I(i-1) + beta(i-1)/N*S(i-1)*I(i-1) - gamma(i-1)*I(i-1);
    R(i) = R(i-1) + gamma(i-1)*I(i-1);

    if I(i) < I_minAllowed
        I(i) = I_minAllowed;
    end
    if S(i) < S_minAllowed
        S(i) = S_minAllowed;
    end
    if R(i) > R_maxAllowed
        R(i) = R_maxAllowed;
    end
end

figure; hold on;
plot(Rt); 
plot(RE); title('Rt, Re simulated SIR');

figure; hold on;
plot(S); plot(I); plot(R); plot(S+I+R); title('S, I, R, sum');