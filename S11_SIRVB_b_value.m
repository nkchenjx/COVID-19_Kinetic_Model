clear;
load("data_SIRB.mat");

N = 1E6; % total population, use per million data so total is 1 million.
gamma0 = 0.2; % recover/quarantine rate
Rt_maxAllowed = 50;
I_minAllowed = 1;
S_minAllowed = 1;
smoothWindow = 10;

blist = [0.05, 0.1, 0.2, 0.5, 1];

data = [];

for bi = 1:length(blist)
    b = blist(bi);
    % b = 0.1; % average breakthrough rate on R+V
    
    figure; title(['b = ', num2str(b), ' poor to rich']); xlim([0,1700]); jcPlotStyle; hold on; 
    for c = [128, 129, 242, 97] % country incomes low to high
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
      
        plot(Rt2,'linewidth', 2);
    
        % store
        Rt2 = Rt2(:);
        data = [data, Rt2(1:1600)];

    end


end
